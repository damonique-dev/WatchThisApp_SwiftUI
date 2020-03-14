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
    var id = UUID()
    
    var shouldAdd = false
    var shouldRemove = false
    var shouldCreateNewList = false
    var listName: String?
    let listId: UUID
    let slug: String
    let itemType: ItemType
}

class CustomListModel: ObservableObject {
    let didChange = PassthroughSubject<CustomListContent, Never>()
    
    @Published var response = CustomListContent(listId: UUID(), slug: "", itemType: .Movie) {
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
            .filter { !$0.slug.isEmpty }
            .sink(receiveValue: { (response) in
                if response.shouldAdd {
                    self.addToCustomList(response: response)
                }
                
                if response.shouldRemove {
                    self.removeFromCustomList(response: response)
                }
            })
    }
    
    func addToCustomList(response: CustomListContent) {
        store.dispatch(action: UserActions.AddToCustomList(customListUUID: response.listId, itemType: response.itemType, slug: response.slug))
    }
    
    func removeFromCustomList(response: CustomListContent) {
        store.dispatch(action: UserActions.RemoveFromCustomList(customListUUID: response.listId, itemType: response.itemType, slug: response.slug))
    }
    
    deinit {
        cancellable?.cancel()
    }
}
