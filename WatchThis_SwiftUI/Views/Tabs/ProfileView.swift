//
//  ProfileView.swift
//  WatchThis_SwiftUI
//
//  Created by Damonique Thomas on 9/17/19.
//  Copyright © 2019 Damonique Thomas. All rights reserved.
//

import SwiftUI
import SwiftUIFlux

struct ProfileView: View {
    @EnvironmentObject var store: Store<AppState>
    @State var showSettings = false
    
    private var customLists: [CustomList] {
        return Array(store.state.userState.customLists.values)
    }
    
    var body: some View {
        ZStack {
            BlurredBackground(image: UIImage(named: "appBackground"), imagePath: nil)
            if customLists.count > 0 {
                ScrollView(.vertical) {
                    VStack {
                        ForEach(customLists) { list in
                            CustomListRow(customList: list)
                        }
                    }
                }.padding(.vertical, 44)
            } else {
                VStack {
                    Text("View your custom lists here. To create a custom list, visit a TV Show, Movie or Person screen and click the button that looks like this:")
                        .font(.headline)
                        .foregroundColor(.white)
                        .fixedSize(horizontal: false, vertical: true)
                    Image(systemName: "text.badge.plus")
                        .imageScale(.large)
                        .foregroundColor(.white)
                }.padding()
            }
        }
        .navigationBarTitle(Text("Your Lists"), displayMode: .inline)
        .navigationBarItems(trailing: NavigationLink(destination: SettingsView()) {
            Image(systemName: "gear").font(Font.system(size: 25, weight: .regular))
        })
    }
}

struct CustomListRow: View {
    @EnvironmentObject var store: Store<AppState>
    let customList: CustomList
    
    lazy var computedListItems: [ListItemIdAndImagePath] = {
        var items = [ListItemIdAndImagePath]()
        for item in Array(customList.items.values) {
            switch item.itemType {
            case .TVShow:
                let detail = store.state.tvShowState.tvShowDetail[item.id]
                items.append(ListItemIdAndImagePath(itemType: .TVShow, itemId: item.id, itemName:detail?.name, imagePath: detail?.posterPath))
                break
            case .Movie:
                let detail = store.state.movieState.movieDetails[item.id]
                items.append(ListItemIdAndImagePath(itemType: .Movie, itemId: item.id, itemName:detail?.title, imagePath: detail?.posterPath))
                break
            case .Person:
                let detail = store.state.peopleState.people[item.id]
                items.append(ListItemIdAndImagePath(itemType: .Person, itemId: item.id, itemName:detail?.name, imagePath: detail?.profilePath))
                break
            }
        }
        return items
    }()
    
    private var listItems: [ListItemIdAndImagePath] {
        var mutatableSelf = self
        return mutatableSelf.computedListItems
    }
    
    var body: some View {
        VStack(alignment: HorizontalAlignment.leading) {
            HStack {
                Text(customList.listName)
                    .font(Font.system(.title, design: .rounded))
                    .fontWeight(.bold)
                    .foregroundColor(.orange)
            }
            ScrollView(.horizontal) {
                HStack {
                    ForEach(listItems) { item in
                        CustomListRowCell(item: item)
                    }
                }
            }.frame(height: 200)
            Spacer()
        }.padding(.top, 8)
        .padding(.horizontal, 8)
    }
}

struct CustomListRowCell: View {
    let item: ListItemIdAndImagePath
    
    var body: some View {
        VStack {
            if item.itemType == ItemType.TVShow {
//                NavigationLink(destination: TVShowDetailView(showId: item.itemId)) {
                    RoundedImageCell(title: item.itemName ?? "", posterPath: item.imagePath, height: CGFloat(200))
//                }
            }
            if item.itemType == ItemType.Movie {
                NavigationLink(destination: MovieDetailsView(movieId: item.itemId)) {
                    RoundedImageCell(title: item.itemName ?? "", posterPath: item.imagePath, height: CGFloat(200))
                }
            }
            if item.itemType == ItemType.Person {
                NavigationLink(destination: PersonDetailsView(personId: item.itemId, personName: item.itemName ?? "")) {
                    RoundedImageCell(title: item.itemName ?? "", posterPath: item.imagePath, height: CGFloat(200))
                }
            }
        }
    }
}

struct ListItemIdAndImagePath: Identifiable {
    let itemType: ItemType
    let itemId: Int
    let itemName: String?
    let imagePath: String?
    
    var id = UUID()
}
