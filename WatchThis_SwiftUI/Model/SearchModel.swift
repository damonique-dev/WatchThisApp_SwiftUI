//
//  SearchModel.swift
//  WatchThis_SwiftUI
//
//  Created by Damonique Thomas on 9/3/19.
//  Copyright © 2019 Damonique Thomas. All rights reserved.
//

import Foundation
import Combine

class SearchModel: ObservableObject {
    let didChange = PassthroughSubject<String, Never>()
    @Published var searchQuery = "" {
        willSet {
            DispatchQueue.main.async {
                self.didChange.send(newValue)
            }
        }
    }

    private var cancellable: AnyCancellable? = nil
    init() {
        cancellable = didChange.eraseToAnyPublisher()
            .map {$0}
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .filter { !$0.isEmpty }
            .sink(receiveValue: { (searchText) in
                store.dispatch(action: TVShowActions.SearchTVShows(query: searchText))
            })
    }
    
    deinit {
        cancellable?.cancel()
    }
}
