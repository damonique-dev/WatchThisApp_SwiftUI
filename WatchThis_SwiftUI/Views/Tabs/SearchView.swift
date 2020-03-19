//
//  SearchView.swift
//  WatchThis_SwiftUI
//
//  Created by Damonique Thomas on 9/1/19.
//  Copyright © 2019 Damonique Thomas. All rights reserved.
//

import SwiftUI
import SwiftUIFlux

enum SearchCategories {
    case TVshows
    case Movies
    case People
}

struct SearchView: View {
    @EnvironmentObject var store: Store<AppState>
    @State var searchModel = SearchModel()
    @State var isActiveBar = false
    @State var isSearching = false
    
    private var tvResults: [TraktShow]? {
        return store.state.traktState.tvShowSearch[searchModel.searchQuery]
    }
    
    private var movieResults: [TraktMovie]? {
        return store.state.traktState.movieSearch[searchModel.searchQuery]
    }
    
    private var peopleResults: [TraktPerson]? {
        return store.state.traktState.peopleSearch[searchModel.searchQuery]
    }
    
    private var searchResultsLoaded: Bool {
        if searchModel.searchCategory == .TVshows {
            return tvResults != nil
        }
        
        if searchModel.searchCategory == .Movies {
            return movieResults != nil
        }
        
        if searchModel.searchCategory == .People {
            return peopleResults != nil
        }
        
        return false
    }
    
    var body: some View {
        ZStack {
            BlurredBackground(image: UIImage(named: "appBackground"), imagePath: nil)
            VStack {
                SearchHeaderView(searchModel: searchModel, isSearching: $isSearching)
                if isSearching && !searchResultsLoaded {
                    ActivitySpinner()
                } else {
                    SearchResultsScrollView(searchModel: searchModel, tvResults: tvResults, movieResults: movieResults, peopleResults: peopleResults)
                }
            }.padding(.vertical, 75)
        }
        .navigationBarTitle(Text("Search"), displayMode: .inline)
    }
}

struct SearchResultsScrollView: View {
    @EnvironmentObject var store: Store<AppState>
    @ObservedObject var searchModel: SearchModel
    let tvResults: [TraktShow]?
    let movieResults: [TraktMovie]?
    let peopleResults: [TraktPerson]?
    
    private var previousSearches: [String] {
        migrateSearchQueries()
        let traktState = store.state.traktState
        switch searchModel.searchCategory {
            case .TVshows:
                return traktState.tvSearchQueries
            case .Movies:
                return traktState.movieSearchQueries
            case .People:
                return traktState.peopleSearchQueries
        }
    }
    
    private func migrateSearchQueries() {
        if store.state.tvShowState.tvSearchQueries.count > store.state.traktState.tvSearchQueries.count {
            store.state.traktState.tvSearchQueries = store.state.tvShowState.tvSearchQueries
        }
        if store.state.movieState.movieSearchQueries.count > store.state.traktState.movieSearchQueries.count {
            store.state.traktState.movieSearchQueries = store.state.movieState.movieSearchQueries
        }
        if store.state.peopleState.peopleSearchQueries.count > store.state.traktState.peopleSearchQueries.count {
            store.state.traktState.peopleSearchQueries = store.state.peopleState.peopleSearchQueries
        }
    }
    
    var body: some View {
        VStack {
            if !searchModel.searchQuery.isEmpty {
                if searchModel.searchCategory == .TVshows {
                    TVSearchResults(tvResults: tvResults ?? [])
                }
                if searchModel.searchCategory == .Movies {
                    MovieSearchResults(movieResults: movieResults ?? [])
                }
                if searchModel.searchCategory == .People {
                    PeopleSearchResults(peopleResults: peopleResults ?? [])
                }
            } else {
                ForEach(previousSearches, id: \.self) { query in
                    Button(action: {self.searchModel.searchQuery = query}) {
                        PreviousSearchRow(query: query)
                    }
                }.padding(.top)
            }
            Spacer()
        }
    }
}

struct TVSearchResults: View {
    @EnvironmentObject var store: Store<AppState>
    let tvResults: [TraktShow]
    
    private func getPosterPath(for show: TraktShow) -> String? {
        return store.state.traktState.slugImages[show.slug]?.posterPath
    }
    
    var body: some View {
        ScrollView(.vertical) {
            VStack {
                ForEach(tvResults) { show in
                    NavigationLink(destination: TVShowDetailView(slug: show.slug, showIds: show.ids)) {
                        SearchViewRow(title: show.title ?? "", overview: show.overview, posterPath: self.getPosterPath(for: show))
                            .frame(height: 120)
                    }
                }
            }
        }
    }
}

struct MovieSearchResults: View {
    @EnvironmentObject var store: Store<AppState>
    let movieResults: [TraktMovie]
    
    private func getPosterPath(for movie: TraktMovie) -> String? {
           return store.state.traktState.slugImages[movie.slug]?.posterPath
       }
    
    var body: some View {
        ScrollView(.vertical) {
            VStack {
                ForEach(movieResults) { movie in
                    NavigationLink(destination: MovieDetailsView(slug: movie.slug, movieIds: movie.ids)) {
                        SearchViewRow(title: movie.title ?? "", overview: movie.overview, posterPath: self.getPosterPath(for: movie))
                            .frame(height: 120)
                    }
                }
            }
        }
    }
}

struct PeopleSearchResults: View {
    @EnvironmentObject var store: Store<AppState>
    let peopleResults: [TraktPerson]
    
    private func getPosterPath(for person: TraktPerson) -> String? {
        if let tmdbId = person.ids.tmdb {
            return store.state.traktState.traktImages[.Person]?[tmdbId]?.posterPath
        }
        return nil
    }
    
    var body: some View {
        ScrollView(.vertical) {
            VStack {
                ForEach(peopleResults) { person in
                    NavigationLink(destination: PersonDetailsView(personDetails: person)) {
                        PeopleSearchRow(person: person, posterPath: self.getPosterPath(for: person))
                            .frame(height: 120)
                    }
                }
            }
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
