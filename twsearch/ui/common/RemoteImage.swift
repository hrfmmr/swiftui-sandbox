//
//  RemoteImage.swift
//  twsearch
//
//  Created by hrfm mr on 2020/12/03.
//

import SwiftUI
import Combine

class RemoteImage: ObservableObject {
    @Published var image: UIImage
    
    private var disposables = Set<AnyCancellable>()
    
    init(for url: URL, placeholder: UIImage = UIImage()) {
        self.image = placeholder
        
        loadImage(for: url)
    }
    
    private func loadImage(for url: URL) {
        URLSession.shared.dataTaskPublisher(for: url)
            .compactMap { data, _ in
                UIImage(data: data)
            }
            .receive(on: RunLoop.main)
            .sink { completion in
                switch completion {
                case let .failure(error):
                    print(error)
                case .finished:
                    break
                }
            } receiveValue: {[weak self] image in
                guard let self = self else { return }
                self.image = image
            }
            .store(in: &disposables)
    }
}
