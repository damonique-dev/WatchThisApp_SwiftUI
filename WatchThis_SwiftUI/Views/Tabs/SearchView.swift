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
    
    private var tvResults: [TVShowDetails]? {
        return store.state.tvShowState.tvShowSearch[searchModel.searchQuery]
    }
    
    private var movieResults: [MovieDetails]? {
        return store.state.movieState.movieSearch[searchModel.searchQuery]
    }
    
    private var peopleResults: [PersonDetails]? {
        return store.state.peopleState.peopleSearch[searchModel.searchQuery]
    }
    
    private var searchResultsLoaded: Bool {
        return tvResults != nil || movieResults != nil || peopleResults != nil
    }
    
    var body: some View {
        ZStack {
            BlurredBackground(image: UIImage(named: "appBackground"), imagePath: nil)
            VStack {
                SearchHeaderView(searchModel: searchModel, isSearching: $isSearching)
                SearchResultsScrollView(searchModel: searchModel, tvResults: tvResults, movieResults: movieResults, peopleResults: peopleResults)
            }.padding(.vertical, 75)
            if isSearching && !searchResultsLoaded {
                ActivitySpinner()
            }
        }
        .navigationBarTitle(Text("Search"), displayMode: .inline)
    }
}

struct SearchResultsScrollView: View {
    @EnvironmentObject var store: Store<AppState>
    @ObservedObject var searchModel: SearchModel
    
    let tvResults: [TVShowDetails]?
    let movieResults: [MovieDetails]?
    let peopleResults: [PersonDetails]?
    
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
        ScrollView(.vertical) {
            VStack {
                if !searchModel.searchQuery.isEmpty {
                    TVSearchResults(tvResults: tvResults, category: searchModel.searchCategory)
                    MovieSearchResults(movieResults: movieResults, category: searchModel.searchCategory)
                    PeopleSearchResults(peopleResults: peopleResults, category: searchModel.searchCategory)
                } else {
                    ForEach(previousSearches, id: \.self) { query in
                        Button(action: {self.searchModel.searchQuery = query}) {
                            PreviousSearchRow(query: query)
                        }
                    }.padding(.top)
                }
            }
        }
    }
}

struct TVSearchResults: View {
    let tvResults: [TVShowDetails]?
    let category: SearchCategories
    
    var body: some View {
        VStack {
            if category == .TVshows && tvResults != nil {
                ForEach(tvResults!) { show in
                    NavigationLink(destination: TVShowDetailView(showId: show.id)) {
                        SearchViewRow(item: show)
                            .frame(height: 120)
                    }
                }
            }
        }
    }
}

struct MovieSearchResults: View {
    let movieResults: [MovieDetails]?
    let category: SearchCategories
    
    var body: some View {
        VStack {
            if category == .Movies && movieResults != nil {
                ForEach(movieResults!) { movie in
                    NavigationLink(destination: MovieDetailsView(movieId: movie.id)) {
                        SearchViewRow(item: movie)
                            .frame(height: 120)
                    }
                }
            }
        }
    }
}

struct PeopleSearchResults: View {
    let peopleResults: [PersonDetails]?
    let category: SearchCategories
    
    var body: some View {
        VStack {
            if category == .People && peopleResults != nil {
                ForEach(peopleResults!) { person in
                    NavigationLink(destination: PersonDetailsView(personId: person.id, personName: person.name!)) {
                        PeopleSearchRow(item: person)
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
