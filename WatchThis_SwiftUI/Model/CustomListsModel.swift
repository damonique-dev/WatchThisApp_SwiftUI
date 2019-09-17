//
//  CustomListsModel.swift
//  WatchThis_SwiftUI
//
//  Created by Damonique Thomas on 9/16/19.
//  Copyright © 2019 Damonique Thomas. All rights reserved.
//

import SwiftUI
import Combine

struct CustomListContent: Identifiable {
    var shouldAdd = false
    var shouldRemove = false
    var shouldCreateNewList = false
    var listName: String?
    let listId: UUID
    let id: Int
}

class CustomListModel: ObservableObject {
    let didChange = PassthroughSubject<CustomListContent, Never>()
    
    @Published var response = CustomListContent(listId: UUID(), id: -1) {
        willSet {
            DispatchQueue.main.async {
                print(newValue)
                self.didChange.send(newValue)
            }
        }
    }
    
    private var cancellable: AnyCancellable? = nil
    init() {
        cancellable = didChange.eraseToAnyPublisher()
            .map {$0}
            .filter { $0.id != -1 }
            .sink(receiveValue: { (response) in
                if response.shouldAdd {
                    self.addToCustomList(response: response)
                }
                
                if response.shouldRemove {
                    self.removeFromCustomList(response: response)
                }
            })
    }
    
    func addToCustomList(response: CustomListContent) {}
    
    func removeFromCustomList(response: CustomListContent) {}
    
    deinit {
        cancellable?.cancel()
    }
}

class TVCustomListModel: CustomListModel {
    override func addToCustomList(response: CustomListContent) {
        store.dispatch(action: TVShowActions.AddTVShowToCustomList(customListUUID: response.listId, tvShowId: response.id))
    }
    
    override func removeFromCustomList(response: CustomListContent) {
        store.dispatch(action: TVShowActions.RemoveTVShowFromCustomList(customListUUID: response.listId, tvShowId: response.id))
    }
}
