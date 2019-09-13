//
//  SearchModel.swift
//  WatchThis_SwiftUI
//
//  Created by Damonique Thomas on 9/3/19.
//  Copyright © 2019 Damonique Thomas. All rights reserved.
//

import Foundation
import Combine

struct SearchContent {
    let searchQuery: String
    let searchCategory: SearchCategories
}

class SearchModel: ObservableObject {
    let didChange = PassthroughSubject<SearchContent, Never>()
    @Published var searchQuery = "" {
        willSet {
            DispatchQueue.main.async {
                print("Search Query Changed")
                self.didChange.send(SearchContent(searchQuery: newValue, searchCategory: self.searchCategory))
            }
        }
    }
    @Published var searchCategory = SearchCategories.TVshows {
        willSet {
            DispatchQueue.main.async {
                print("Search Category Changed")
                self.didChange.send(SearchContent(searchQuery: self.searchQuery, searchCategory: newValue))
            }
        }
    }

    private var cancellable: AnyCancellable? = nil
    init() {
        cancellable = didChange.eraseToAnyPublisher()
            .map {$0}
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
            .filter { !$0.searchQuery.isEmpty }
            .sink(receiveValue: { (searchContent) in
                if searchContent.searchCategory == .TVshows {
                    store.dispatch(action: TVShowActions.SearchTVShows(query: searchContent.searchQuery))
                }
                if searchContent.searchCategory == .Movies {
                    store.dispatch(action: MovieActions.SearchMovies(query: searchContent.searchQuery))
                }
            })
    }
    
    deinit {
        cancellable?.cancel()
    }
}
