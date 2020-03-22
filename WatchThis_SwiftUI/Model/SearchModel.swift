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
                self.didChange.send(SearchContent(searchQuery: newValue, searchCategory: self.searchCategory))
            }
        }
    }
    @Published var searchCategory = SearchCategories.TVshows {
        willSet {
            DispatchQueue.main.async {
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
                    store.dispatch(action: TraktActions.SearchTraktApi(query: searchContent.searchQuery, endpoint: .Search_TV))
                }
                if searchContent.searchCategory == .People {
                    store.dispatch(action: TraktActions.SearchTraktApi(query: searchContent.searchQuery, endpoint: .Search_People))
                }
                if searchContent.searchCategory == .Movies {
                    store.dispatch(action: TraktActions.SearchTraktApi(query: searchContent.searchQuery, endpoint: .Search_Movie))
                }
            })
    }
    
    deinit {
        cancellable?.cancel()
    }
}
