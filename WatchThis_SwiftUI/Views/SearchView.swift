//
//  SearchView.swift
//  WatchThis_SwiftUI
//
//  Created by Damonique Thomas on 9/1/19.
//  Copyright © 2019 Damonique Thomas. All rights reserved.
//

import SwiftUI

struct SearchView: View {
    @EnvironmentObject var store: Store<AppState>
    @State var searchModel = SearchModel()
    @State var isActiveBar = false
    
    private var tvResults: [TVShowDetails] {
        let showState = store.state.tvShowState
        return showState.tvShowSearch[searchModel.searchQuery] ?? [TVShowDetails]()
    }
    
    private var previousSearches: [String] {
        let showState = store.state.tvShowState
        return showState.searchQueries 
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                BlurredBackground(image: UIImage(named: "appBackground"), imagePath: nil)
                VStack {
                    SearchBar(searchModel: searchModel)
                        .padding(.top, 25)
                    ScrollView(.vertical) {
                        VStack {
                            if !searchModel.searchQuery.isEmpty {
                                ForEach(tvResults, id: \.id) { show in
                                    NavigationLink(destination: TVShowDetailView(showDetail: show, fetchDetails: true)) {
                                        SearchViewRow(tvShow: show)
                                        .frame(height: 120)
                                    }
                                    
                                }
                            } else {
                                ForEach(previousSearches, id: \.self) { query in
                                    Button(action: {self.searchModel.searchQuery = query}) {
                                        PreviousSearchRow(query: query)
                                    }
                                }.padding(.top)
                            }
                        }
                    }
                }.padding(.vertical, 75)
            }
            .navigationBarTitle(Text("Search"), displayMode: .inline)
        }
    }
}

struct SearchBar: View {
    @ObservedObject var searchModel: SearchModel
    @State var isActiveBar = false
    var body: some View {
        HStack(alignment: VerticalAlignment.center, spacing: 0, content: {
            ZStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.white)
                    TextField("Search", text: $searchModel.searchQuery, onEditingChanged: {_ in
                        self.isActiveBar.toggle()
                    }).foregroundColor(.black)
                        .padding(5)
                        .background(
                            RoundedRectangle(cornerRadius: 5)
                                .foregroundColor(Color.white))
                    
                    if !searchModel.searchQuery.isEmpty {
                        Button(action: {
                            self.searchModel.searchQuery = ""
                        }) {
                            Image(systemName: "multiply.circle")
                                .foregroundColor(.white)
                        }
                    }
                }
            }
            
        }).animation(.default)
            .padding(.horizontal)
    }
}

#if DEBUG
struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView().environmentObject(sampleStore)
    }
}
#endif


struct SearchViewRow: View {
    let tvShow: TVShowDetails
    let rectangleWidth = UIScreen.main.bounds.width - (100 * 8/11) - 50
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                ImageLoaderView(imageLoader: ImageLoaderCache.sharedInstance().loaderFor(path: tvShow.poster_path,
                                                                                         size: .original), contentMode: .fill)
                    .frame(width: 100 * 8/11, height: 100)
                VStack(alignment: .leading) {
                    Text(tvShow.name)
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    if tvShow.overview != nil && !(tvShow.overview?.isEmpty ?? true) {
                        Text(tvShow.overview!)
                            .font(.body)
                            .foregroundColor(.white)
                            .lineLimit(3)
                    } else {
                        Rectangle()
                            .foregroundColor(Color.black.opacity(0))
                            .frame(width: rectangleWidth)
                    }
                    Spacer()
                }
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0)
                .padding(.leading, 4)
            }
            Divider().background(Color.white)
        }.padding()
    }
}

struct PreviousSearchRow: View {
    let query: String
    var body: some View {
        VStack {
            HStack(alignment: .center) {
                Text(query)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }.padding(.bottom)
            Divider().background(Color.white)
        }.padding(.bottom)
    }
}
