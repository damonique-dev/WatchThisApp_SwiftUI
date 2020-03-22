//
//  TraktActions.swift
//  WatchThis_SwiftUI
//
//  Created by Damonique Blake on 3/12/20.
//  Copyright © 2020 Damonique Thomas. All rights reserved.
//

import Foundation
import SwiftUIFlux

struct TraktActions {
    struct FetchTraktShowList<T: Codable>: AsyncAction {
        let endpoint: TraktApiClient.Endpoint
        let showList: TVShowList
        func execute(state: FluxState?, dispatch: @escaping DispatchFunction) {
            TraktApiClient.sharedInstance().GET(endpoint: endpoint, params: Trakt_Parameters) { (result: Result<T, APIError>) in
                switch result {
                case let .success(response):
                    var shows = [TraktShow]()
                    var ids = [Ids]()
                    if T.self == [TraktShow].self {
                        shows = response as! [TraktShow]
                        ids = shows.compactMap({ $0.ids })
                    } else if T.self == [TraktShowListResults].self {
                        shows = (response as! [TraktShowListResults]).compactMap {$0.show}
                        ids = shows.compactMap({ $0.ids })
                    }
                    
                    dispatch(SetTVShowList(list: self.showList, shows: shows))
                    dispatch(FetchImagesFromTMDB(ids: ids, itemType: .TVShow))
                    shows.forEach({ dispatch(SetShow(slug: $0.slug, show: $0)) })
                case let .failure(error):
                    #if DEBUG
                    print(error)
                    #endif
                    break
                }
            }
        }
    }
    
    struct FetchTraktMovieList<T: Codable>: AsyncAction {
        let endpoint: TraktApiClient.Endpoint
        let movieList: MovieList
        func execute(state: FluxState?, dispatch: @escaping DispatchFunction) {
            TraktApiClient.sharedInstance().GET(endpoint: endpoint, params: Trakt_Parameters)
            {
                (result: Result<T, APIError>) in
                switch result {
                case let .success(response):
                    var movies = [TraktMovie]()
                    var ids = [Ids]()
                    if T.self == [TraktMovie].self {
                        movies = response as! [TraktMovie]
                        ids = movies.compactMap({ $0.ids })
                    } else if T.self == [TraktMovieListResults].self {
                        movies = (response as! [TraktMovieListResults]).compactMap {$0.movie}
                        ids = movies.compactMap({ $0.ids })
                    }
                    
                    dispatch(SetMovieList(list: self.movieList, movies: movies))
                    dispatch(FetchImagesFromTMDB(ids: ids, itemType: .Movie))
                    movies.forEach({ dispatch(SetMovie(slug: $0.slug, movie: $0)) })
                case let .failure(error):
                    print(error)
                    break
                }
            }
        }
    }
    
    struct FetchFromTraktApi<U: Codable>: AsyncAction {
        let ids: Ids
        let endpoint: TraktApiClient.Endpoint
        var extendedInfo = true
        var params = [String : String]()
        func execute(state: FluxState?, dispatch: @escaping DispatchFunction) {
            guard let slug = ids.slug else {
                return
            }
            var mutatedParams = params
            if extendedInfo {
                mutatedParams.merge(Trakt_Parameters) { (_, second) in second }
            }
            TraktApiClient.sharedInstance().GET(endpoint: endpoint, params: mutatedParams) { (result: Result<U, APIError>) in
                switch result {
                case let .success(response):
                    if self.endpoint == TraktApiClient.Endpoint.TV_Seasons(slug: slug) {
                        let seasons = response as! [TraktSeason]
                        dispatch(FetchSeasonImagesFromTMDB(showIds: self.ids, seasons: seasons))
                        dispatch(SetSeasons(showSlug: slug, seasons: seasons))
                    } else if self.endpoint == TraktApiClient.Endpoint.TV_Cast(slug: slug) || self.endpoint == TraktApiClient.Endpoint.Movie_Cast(slug: slug) {
                        let cast = (response as! TraktPeopleResults).cast
                        let people = cast.map({ $0.person })
                        let ids = people.compactMap({ $0.ids })
                        dispatch(FetchImagesFromTMDB(ids: ids, itemType: .Person))
                        dispatch(SetCast(showSlug: slug, cast: cast))
                        people.forEach({ dispatch(SetPerson(slug: $0.slug, person: $0)) })
                    } else if self.endpoint == TraktApiClient.Endpoint.TV_Related(slug: slug) {
                        let shows = response as! [TraktShow]
                        let ids = shows.compactMap({ $0.ids })
                        dispatch(FetchImagesFromTMDB(ids: ids, itemType: .TVShow))
                        dispatch(SetRelatedShows(showSlug: slug, shows: shows))
                        shows.forEach({ dispatch(SetShow(slug: $0.slug, show: $0)) })
                    } else if self.endpoint == TraktApiClient.Endpoint.TV_Details(slug: slug) {
                        let show = response as! TraktShow
                        dispatch(FetchImagesFromTMDB(ids: [show.ids], itemType: .TVShow))
                        dispatch(SetShow(slug: show.slug, show: show))
                    } else if self.endpoint == TraktApiClient.Endpoint.Person_TVCredits(slug: slug) {
                        let castlist = (response as! TraktCreditsResults).cast
                        dispatch(SetPersonShowCredits(slug: slug, credit: castlist))
                        
                        let shows = castlist.compactMap({$0.show})
                        let ids = shows.compactMap({ $0.ids })
                        dispatch(FetchImagesFromTMDB(ids: ids, itemType: .TVShow))
                        shows.forEach({ dispatch(SetShow(slug: $0.slug, show: $0)) })
                    } else if self.endpoint == TraktApiClient.Endpoint.Person_MovieCredits(slug: slug) {
                        let castlist = (response as! TraktCreditsResults).cast
                        dispatch(SetPersonMovieCredits(slug: slug, credit: castlist))
                        
                        let movies = castlist.compactMap({$0.movie})
                        let ids = movies.compactMap({ $0.ids })
                        dispatch(FetchImagesFromTMDB(ids: ids, itemType: .Movie))
                        movies.forEach({ dispatch(SetMovie(slug: $0.slug, movie: $0)) })
                    } else if self.endpoint == TraktApiClient.Endpoint.Movie_Details(slug: slug) {
                        let movie = response as! TraktMovie
                        dispatch(FetchImagesFromTMDB(ids: [movie.ids], itemType: .Movie))
                        dispatch(SetMovie(slug: movie.slug, movie: movie))
                    } else if self.endpoint == TraktApiClient.Endpoint.Movie_Related(slug: slug) {
                        let movies = response as! [TraktMovie]
                        let ids = movies.compactMap({ $0.ids })
                        dispatch(FetchImagesFromTMDB(ids: ids, itemType: .Movie))
                        dispatch(SetRelatedMovies(movieSlug: slug, movies: movies))
                        movies.forEach({ dispatch(SetMovie(slug: $0.slug, movie: $0)) })
                    } else if self.endpoint == TraktApiClient.Endpoint.TraktIds(id: self.ids.tmdb!) {
                        let searchResults = (response as! [TraktSearchResult]).first
                        if let show = searchResults?.show {
                            dispatch(FetchImagesFromTMDB(ids: [show.ids], itemType: .TVShow))
                            dispatch(SetTmdbIdToSlug(id: self.ids.tmdb!, slug: show.slug))
                            dispatch(SetShow(slug: show.slug, show: show))
                        }
                        if let movie = searchResults?.movie {
                            dispatch(FetchImagesFromTMDB(ids: [movie.ids], itemType: .Movie))
                            dispatch(SetTmdbIdToSlug(id: self.ids.tmdb!, slug: movie.slug))
                            dispatch(SetMovie(slug: movie.slug, movie: movie))
                        }
                        if let person = searchResults?.person {
                            dispatch(FetchImagesFromTMDB(ids: [person.ids], itemType: .Person))
                            dispatch(SetTmdbIdToSlug(id: self.ids.tmdb!, slug: person.slug))
                            dispatch(SetPerson(slug: person.slug, person: person))
                        }
                    } else {
                        print("Endpoint \"\(self.endpoint.path())\" action not defined.")
                    }
                case let .failure(error):
                    #if DEBUG
                    print(error)
                    #endif
                    break
                }
            }
        }
    }
    
    struct SearchTraktApi: AsyncAction {
        let query: String
        let endpoint: TraktApiClient.Endpoint
        func execute(state: FluxState?, dispatch: @escaping DispatchFunction) {
            var params = Trakt_Parameters
            params["query"] = query.lowercased()
            TraktApiClient.sharedInstance().GET(endpoint: endpoint, params: params) { (result: Result<[TraktSearchResult], APIError>) in
                switch result {
                case let .success(response):
                    if self.endpoint == TraktApiClient.Endpoint.Search_TV {
                        let shows = response.compactMap { $0.show }
                        let ids = shows.compactMap({ $0.ids })
                        dispatch(FetchImagesFromTMDB(ids: ids, itemType: .TVShow))
                        dispatch(SetTVShowSearch(query: self.query, shows: shows))
                    } else if self.endpoint == TraktApiClient.Endpoint.Search_People {
                        let people = response.compactMap { $0.person }
                        let ids = people.compactMap({ $0.ids })
                        dispatch(FetchImagesFromTMDB(ids: ids, itemType: .Person))
                        dispatch(SetPeopleSearch(query: self.query, people: people))
                    } else if self.endpoint == TraktApiClient.Endpoint.Search_Movie {
                        let movies = response.compactMap { $0.movie }
                        let ids = movies.compactMap({ $0.ids })
                        dispatch(FetchImagesFromTMDB(ids: ids, itemType: .Movie))
                        dispatch(SetMovieSearch(query: self.query, movies: movies))
                    } else {
                        print("Endpoint \"\(self.endpoint.path())\" action not defined.")
                    }
                case let .failure(error):
                    #if DEBUG
                    print("Search error: \(error)")
                    #endif
                    break
                }
            }
        }
    }
    
    struct FetchSeasonEpisodes: AsyncAction {
        let showIds: Ids
        let seasonNumber: Int
        func execute(state: FluxState?, dispatch: @escaping DispatchFunction) {
            TraktApiClient.sharedInstance().GET(endpoint: .TV_TVSeasonEpisodes(slug: showIds.slug!, seasonNumber: seasonNumber), params: Trakt_Parameters) { (result: Result<[TraktEpisode], APIError>) in
                switch result {
                case let .success(response):
                    dispatch(SetEpisodes(showSlug: self.showIds.slug!, seasonNumber: self.seasonNumber, episodes: response))
                    dispatch(FetchEpisodeImagesFromTMDB(showTmdbId: self.showIds.tmdb!, seasonNumber: self.seasonNumber, episodes: response))
                case let .failure(error):
                    #if DEBUG
                    print(error)
                    #endif
                    break
                }
            }
        }
    }
    
    struct FetchImagesFromTMDB: AsyncAction {
        let ids: [Ids]
        let itemType: ItemType
        
        func execute(state: FluxState?, dispatch: @escaping DispatchFunction) {
            for id in ids {
                if let appState = state as? AppState, let tmdbId = id.tmdb, let slug = id.slug {
                    // Only fetch images if not already in state.
                    if appState.traktState.slugImages[slug] == nil {
                        var endpoint: TMDBClient.Endpoint
                        switch itemType {
                            case .TVShow:
                                endpoint = TMDBClient.Endpoint.TV_ShowDetails(id: tmdbId)
                            case .Movie:
                                endpoint = TMDBClient.Endpoint.Movie_Details(id: tmdbId)
                            case .Person:
                                endpoint = TMDBClient.Endpoint.Person_Details(id: tmdbId)
                        }
                        TMDBClient.sharedInstance.GET(endpoint: endpoint, params: TMDB_Parameters) { (result: Result<TMDbImagesResponse, APIError>) in
                            switch result {
                            case let .success(response):
                                var posterPath = response.posterPath
                                if self.itemType == .Person {
                                    posterPath = response.profilePath
                                }
                                dispatch(SetSlugImage(slug: slug, slugImage: .init(backgroundPath: response.backdropPath, posterPath: posterPath)))
                            case let .failure(error):
                                #if DEBUG
                                print("\(self.itemType) Images error: \(error)")
                                #endif
                                break
                            }
                        }
                    }
                }
            }
        }
    }
    
    struct FetchSeasonImagesFromTMDB: AsyncAction {
        let showIds: Ids
        let seasons: [TraktSeason]
        func execute(state: FluxState?, dispatch: @escaping DispatchFunction) {
            for season in seasons {
                if let appState = state as? AppState, let tmdbId = season.ids.tmdb, let showTmdbId = showIds.tmdb {
                    // Only fetch images if not already in state.
                    if appState.traktState.traktImages[.Season]?[tmdbId] == nil {
                        TMDBClient.sharedInstance.GET(endpoint: TMDBClient.Endpoint.TV_Seasons_Details(id: showTmdbId, seasonNum: season.number), params: TMDB_Parameters)
                        {
                            (result: Result<TMDbImagesResponse, APIError>) in
                            switch result {
                            case let .success(response):
                                dispatch(SetEntityImages(entity: .Season, tmdbId: tmdbId, slugImage: .init(backgroundPath: nil, posterPath: response.posterPath)))
                            case let .failure(error):
                                #if DEBUG
                                print(error)
                                #endif
                                break
                            }
                        }
                    }
                }
            }
        }
    }
    
    struct FetchEpisodeImagesFromTMDB: AsyncAction {
        let showTmdbId: Int
        let seasonNumber: Int
        let episodes: [TraktEpisode]
        func execute(state: FluxState?, dispatch: @escaping DispatchFunction) {
            for episode in episodes {
                if let appState = state as? AppState, let tmdbId = episode.ids.tmdb {
                    // Only fetch images if not already in state.
                    if appState.traktState.traktImages[.Season]?[tmdbId] == nil {
                        TMDBClient.sharedInstance.GET(endpoint: TMDBClient.Endpoint.TV_Episode_Details(id: showTmdbId, seasonNum: seasonNumber, episodeNum: episode.number), params: TMDB_Parameters)
                        {
                            (result: Result<TMDbImagesResponse, APIError>) in
                            switch result {
                            case let .success(response):
                                dispatch(SetEntityImages(entity: .Episode, tmdbId: tmdbId, slugImage: .init(backgroundPath: nil, posterPath: response.stillPath)))
                            case let .failure(error):
                                #if DEBUG
                                print(error)
                                #endif
                                break
                            }
                        }
                    }
                }
            }
        }
    }
    
    struct SetTVShowList: Action {
        let list: TVShowList
        let shows: [TraktShow]
    }
    
    struct SetMovieList: Action {
        let list: MovieList
        let movies: [TraktMovie]
    }
    
    struct SetShowSlug: Action {
        let showId: Int
        let slug: String
    }
    
    struct SetSlugImage: Action {
        let slug: String
        let slugImage: TraktImages
    }
    
    struct SetShow: Action {
        let slug: String
        let show: TraktShow
    }
    
    struct SetMovie: Action {
        let slug: String
        let movie: TraktMovie
    }
    
    struct SetPerson: Action {
        let slug: String
        let person: TraktPerson
    }
    
    struct SetSeasons: Action {
        let showSlug: String
        let seasons: [TraktSeason]
    }
    
    struct SetEpisodes: Action {
        let showSlug: String
        let seasonNumber: Int
        let episodes: [TraktEpisode]
    }
    
    struct SetCast: Action {
        let showSlug: String
        let cast: [TraktCast]
    }
    
    struct SetRelatedShows: Action {
        let showSlug: String
        let shows: [TraktShow]
    }
    
    struct SetRelatedMovies: Action {
        let movieSlug: String
        let movies: [TraktMovie]
    }
    
    struct SetEntityImages: Action {
        let entity: TraktEntity
        let tmdbId: Int
        let slugImage: TraktImages
    }
    
    struct SetPersonShowCredits: Action {
        let slug: String
        let credit: [TraktCredits]
    }
    
    struct SetPersonMovieCredits: Action {
        let slug: String
        let credit: [TraktCredits]
    }
    
    struct SetTVShowSearch: Action {
        let query: String
        let shows: [TraktShow]
    }
    
    struct SetPeopleSearch: Action {
        let query: String
        let people: [TraktPerson]
    }
    
    struct SetMovieSearch: Action {
        let query: String
        let movies: [TraktMovie]
    }
    
    struct SetTmdbIdToSlug: Action {
        let id: Int
        let slug: String
    }
}
