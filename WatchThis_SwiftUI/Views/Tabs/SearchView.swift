//
//  SearchView.swift
//  WatchThis_SwiftUI
//
//  Created by Damonique Thomas on 9/1/19.
//  Copyright © 2019 Damonique Thomas. All rights reserved.
//

import SwiftUI

enum SearchCategories {
    case TVshows
    case Movies
    case People
}

struct SearchView: View {
    @EnvironmentObject var store: Store<AppState>
    @State var searchModel = SearchModel()
    @State var isActiveBar = false
    
    private var tvResults: [TVShowDetails]  {
        return store.state.tvShowState.tvShowSearch[searchModel.searchQuery] ?? [TVShowDetails]()
    }
    
    private var movieResults: [MovieDetails]  {
        return store.state.movieState.movieSearch[searchModel.searchQuery] ?? [MovieDetails]()
    }
    
    private var peopleResults: [PersonDetails]  {
        return store.state.peopleState.peopleSearch[searchModel.searchQuery] ?? [PersonDetails]()
    }
    
    private var previousSearches: [String] {
        switch searchModel.searchCategory {
        case .TVshows:
            return store.state.tvShowState.tvSearchQueries
        case .Movies:
            return store.state.movieState.movieSearchQueries
        case .People:
           return store.state.peopleState.peopleSearchQueries
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                BlurredBackground(image: UIImage(named: "appBackground"), imagePath: nil)
                VStack {
                    SearchHeaderView(searchModel: searchModel)
                    ScrollView(.vertical) {
                        VStack {
                            if !searchModel.searchQuery.isEmpty {
                                if searchModel.searchCategory == .TVshows {
                                    ForEach(tvResults) { show in
                                        NavigationLink(destination: TVShowDetailView(showId: show.id)) {
                                            SearchViewRow(item: show)
                                            .frame(height: 120)
                                        }
                                    }
                                }
                                if searchModel.searchCategory == .Movies {
                                    ForEach(movieResults) { movie in
                                        NavigationLink(destination: MovieDetailsView(movieId: movie.id)) {
                                            SearchViewRow(item: movie)
                                            .frame(height: 120)
                                        }
                                    }
                                }
                                if searchModel.searchCategory == .People {
                                    ForEach(peopleResults) { person in
                                        NavigationLink(destination: PersonDetailsView(personId: person.id, personName: person.name!)) {
                                            PeopleSearchRow(item: person)
                                            .frame(height: 120)
                                        }
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

#if DEBUG
struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView().environmentObject(sampleStore)
    }
}
#endif
