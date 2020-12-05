//
//  SearchStatusesViewModel.swift
//  twsearch
//
//  Created by hrfm mr on 2020/12/02.
//

import Foundation
import Combine

class SearchStatusesViewModel: ObservableObject {
    typealias Dependency = (
        statusRepository: StatusRepository,
        scheduler: DispatchQueue
    )
    @Published var query = ""
    @Published var isEditing = false
    @Published var shouldShowLoading = false
    @Published var shouldShowLoadingNext = false
    @Published var dataSource: [StatusRowViewModel] = []
    private var nextParams: [String: String]?
    private let statusRepository: StatusRepository
    private var disposables = Set<AnyCancellable>()
    
    init(dependency: Dependency) {
        self.statusRepository = dependency.statusRepository
        
        let searchWithQuery = $query
            .filter { !$0.isEmpty }
            .debounce(for: .seconds(0.5), scheduler: dependency.scheduler)

        searchWithQuery
            .sink(receiveValue: searchStatuses(withQuery:))
            .store(in: &disposables)
        
        searchWithQuery
            .map { _ in true }
            .receive(on: RunLoop.main)
            .assign(to: \.shouldShowLoading, on: self)
            .store(in: &disposables)

        $query
            .map { !$0.isEmpty }
            .receive(on: RunLoop.main)
            .assign(to: \.isEditing, on: self)
            .store(in: &disposables)
    }
    
    func clearSearchText() {
        query = ""
    }
    
    func searchStatuses(withQuery q: String) {
        let searchRequest = statusRepository.search(withQuery: q)
            
        searchRequest
            .receive(on: RunLoop.main)
            .sink { [weak self] completion in
                guard  let self = self else { return }
                self.shouldShowLoading = false
                switch completion {
                case let .failure(error):
                    print(error.localizedDescription)
                    self.dataSource = []
                case .finished:
                    break
                }
            } receiveValue: { [weak self] searchResult in
                guard  let self = self else { return }
                self.dataSource = searchResult.statuses.map(StatusRowViewModel.init)
                self.nextParams = searchResult.nextParams
            }
            .store(in: &disposables)
    }
    
    func fetchNextStatuses() {
        guard let nextParams = nextParams else { return }
        shouldShowLoadingNext = true
        let fetchNextRequest = statusRepository.fetchNext(withParams: nextParams)
        fetchNextRequest
            .receive(on: RunLoop.main)
            .sink { [weak self] completion in
                guard let self = self else { return }
                self.shouldShowLoadingNext = false
                switch completion {
                case let .failure(error):
                    print(error.localizedDescription)
                case .finished:
                    break
                }
            } receiveValue: { [weak self] searchResult in
                guard  let self = self else { return }
                self.dataSource.append(contentsOf: searchResult.statuses.map(StatusRowViewModel.init))
                self.nextParams = searchResult.nextParams
            }
            .store(in: &disposables)
    }
    
    func onAppearElement(_ statusModel: StatusRowViewModel) {
        guard
            let lastElement = dataSource.last,
            statusModel == lastElement
        else { return }
        fetchNextStatuses()
    }
}
