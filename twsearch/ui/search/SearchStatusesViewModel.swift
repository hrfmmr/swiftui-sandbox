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
    @Published var dataSource: [StatusRowViewModel] = []
    private let statusRepository: StatusRepository
    private var disposables = Set<AnyCancellable>()
    
    init(dependency: Dependency) {
        self.statusRepository = dependency.statusRepository
        
        $query
            .filter { !$0.isEmpty }
            .debounce(for: .seconds(0.5), scheduler: dependency.scheduler)
            .sink(receiveValue: searchStatuses(withQuery:))
            .store(in: &disposables)
    }
    
    func searchStatuses(withQuery q: String) {
        statusRepository.search(withQuery: q)
            .map { $0.statuses.map(StatusRowViewModel.init) }
            .receive(on: RunLoop.main)
            .sink { [weak self] completion in
                guard  let self = self else { return }
                switch completion {
                case let .failure(error):
                    print(error.localizedDescription)
                    self.dataSource = []
                case .finished:
                    break
                }
            } receiveValue: { [weak self] dataSource in
                guard  let self = self else { return }
                self.dataSource = dataSource
            }
            .store(in: &disposables)
    }
}
