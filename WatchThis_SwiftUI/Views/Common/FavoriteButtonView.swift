//
//  FavoriteButtonView.swift
//  WatchThis_SwiftUI
//
//  Created by Damonique Thomas on 9/15/19.
//  Copyright © 2019 Damonique Thomas. All rights reserved.
//

import SwiftUI

struct FavoriteButtonView: View {
    @EnvironmentObject var store: Store<AppState>
    @Binding var isFavorite: Bool
    let addAction: Action
    let removeAction: Action
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                FavoriteButton(isFavorite: $isFavorite, action: {
                    self.isFavorite.toggle()
                    if self.isFavorite {
                        self.store.dispatch(action: self.addAction)
                    } else {
                        self.store.dispatch(action: self.removeAction)
                    }
                })
                Spacer()
            }.padding(.leading, UIScreen.main.bounds.width / 2 - UIScreen.main.bounds.width/6 - 40)
            Spacer()
        }.padding(.top, 310)
    }
}
