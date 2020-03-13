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
                    if T.self == [TraktShow].self {
                        dispatch(SetTVShowList(list: self.showList, shows: response as! [TraktShow]))
                        dispatch(FetchImagesFromTMDB(shows: response as! [TraktShow]))
                    } else if T.self == [TraktShowListResults].self {
                        let list = (response as! [TraktShowListResults]).compactMap {$0.show}
                        dispatch(SetTVShowList(list: self.showList, shows: list))
                        dispatch(FetchImagesFromTMDB(shows: list))
                    }
                    
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
        func execute(state: FluxState?, dispatch: @escaping DispatchFunction) {
            guard let slug = ids.slug else {
                return
            }
            let params = extendedInfo ? Trakt_Parameters : [:]
            TraktApiClient.sharedInstance().GET(endpoint: endpoint, params: params) { (result: Result<U, APIError>) in
                switch result {
                case let .success(response):
                    if self.endpoint == TraktApiClient.Endpoint.TV_Seasons(slug: slug) {
                        let seasons = response as! [TraktSeason]
                        dispatch(FetchSeasonImagesFromTMDB(showIds: self.ids, seasons: seasons))
                        dispatch(SetSeasons(showSlug: slug, seasons: seasons))
                    } else if self.endpoint == TraktApiClient.Endpoint.TV_Cast(slug: slug) {
                        let cast = (response as! TraktPeopleResults).cast
                        dispatch(FetchPeopleImagesFromTMDB(showIds: self.ids, cast: cast))
                        dispatch(SetCast(showSlug: slug, cast: cast))
                    } else if self.endpoint == TraktApiClient.Endpoint.TV_Related(slug: slug) {
                        let shows = response as! [TraktShow]
                        dispatch(FetchImagesFromTMDB(shows: shows))
                        dispatch(SetRelatedShows(showSlug: slug, shows: shows))
                    } else if self.endpoint == TraktApiClient.Endpoint.TV_Details(slug: slug) {
                        let show = response as! TraktShow
                        dispatch(FetchImagesFromTMDB(shows: [show]))
                    } else {
                        print("Endpoint \"\(self.endpoint.path())\" action not defined.")
                    }
                case let .failure(error):
                    print(error)
                    break
                }
            }
        }
    }
    
    struct FetchImagesFromTMDB: AsyncAction {
        let shows: [TraktShow]
        func execute(state: FluxState?, dispatch: @escaping DispatchFunction) {
            for show in shows {
                if let appState = state as? AppState, let tmdbId = show.ids?.tmdb, let slug = show.ids?.slug {
                    // Only fetch images if not already in state.
                    if appState.tvShowState.slugImages[slug] == nil {
                        TMDBClient.sharedInstance.GET(endpoint: TMDBClient.Endpoint.TV_ShowDetails(id: tmdbId), params: TMDB_Parameters)
                        {
                            (result: Result<TVShowDetails, APIError>) in
                            switch result {
                            case let .success(response):
                                dispatch(SetSlugImage(slug: slug, slugImage: .init(backgroundPath: response.backdropPath, posterPath: response.posterPath)))
                            case let .failure(error):
                                print(error)
                                break
                            }
                        }
                    }
                    dispatch(SetShow(slug: slug, show: show))
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
                    if appState.tvShowState.traktImages[.Season]?[tmdbId] == nil {
                        TMDBClient.sharedInstance.GET(endpoint: TMDBClient.Endpoint.TV_Seasons_Details(id: showTmdbId, seasonNum: season.number), params: TMDB_Parameters)
                        {
                            (result: Result<Season, APIError>) in
                            switch result {
                            case let .success(response):
                                dispatch(SetEntityImages(entity: .Season, tmdbId: tmdbId, slugImage: .init(backgroundPath: nil, posterPath: response.posterPath)))
                            case let .failure(error):
                                print(error)
                                break
                            }
                        }
                    }
                }
            }
        }
    }
    
    struct FetchPeopleImagesFromTMDB: AsyncAction {
        let showIds: Ids
        let cast: [TraktCast]
        func execute(state: FluxState?, dispatch: @escaping DispatchFunction) {
            for person in cast {
                if let appState = state as? AppState, let tmdbId = person.person.ids.tmdb {
                    // Only fetch images if not already in state.
                    if appState.tvShowState.traktImages[.Person]?[tmdbId] == nil {
                        TMDBClient.sharedInstance.GET(endpoint: TMDBClient.Endpoint.Person_Details(id: tmdbId), params: TMDB_Parameters)
                        {
                            (result: Result<Person, APIError>) in
                            switch result {
                            case let .success(response):
                                dispatch(SetEntityImages(entity: .Person, tmdbId: tmdbId, slugImage: .init(backgroundPath: nil, posterPath: response.profilePath)))
                            case let .failure(error):
                                print(error)
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
    
    struct SetSeasons: Action {
        let showSlug: String
        let seasons: [TraktSeason]
    }
    
    struct SetCast: Action {
        let showSlug: String
        let cast: [TraktCast]
    }
    
    struct SetRelatedShows: Action {
        let showSlug: String
        let shows: [TraktShow]
    }
    
    struct SetEntityImages: Action {
        let entity: TraktEntity
        let tmdbId: Int
        let slugImage: TraktImages
    }
}
