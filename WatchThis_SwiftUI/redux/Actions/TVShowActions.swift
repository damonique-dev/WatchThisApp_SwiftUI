//
//  TvShowActions.swift
//  WatchThis_SwiftUI
//
//  Created by Damonique Thomas on 8/28/19.
//  Copyright © 2019 Damonique Thomas. All rights reserved.
//

import Foundation
import SwiftUIFlux

struct TVShowActions {
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
                        dispatch(SetTraktSeasons(showSlug: slug, seasons: seasons))
                    } else if self.endpoint == TraktApiClient.Endpoint.TV_Cast(slug: slug) {
                        let cast = (response as! TraktPeopleResults).cast
                        dispatch(FetchPeopleImagesFromTMDB(showIds: self.ids, cast: cast))
                        dispatch(SetTraktCast(showSlug: slug, cast: cast))
                    } else if self.endpoint == TraktApiClient.Endpoint.TV_Related(slug: slug) {
                        let shows = response as! [TraktShow]
                        dispatch(FetchImagesFromTMDB(shows: shows))
                        dispatch(SetTraktRelatedShows(showSlug: slug, shows: shows))
                    } else if self.endpoint == TraktApiClient.Endpoint.TV_Details(slug: slug) {
                        let show = response as! TraktShow
                        dispatch(FetchImagesFromTMDB(shows: [show]))
                        dispatch(SetTraktShow(slug: slug, traktShow: show))
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
                if let appState = state as? AppState, let tmdbId = show.ids.tmdb, let slug = show.ids.slug {
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
                    dispatch(SetTraktShow(slug: slug, traktShow: show))
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
                    let slug = person.person.slug
                    if appState.tvShowState.slugImages[slug] == nil {
                        TMDBClient.sharedInstance.GET(endpoint: TMDBClient.Endpoint.Person_Details(id: tmdbId), params: TMDB_Parameters)
                        {
                            (result: Result<Person, APIError>) in
                            switch result {
                            case let .success(response):
                                dispatch(SetSlugImage(slug: slug, slugImage: .init(backgroundPath: nil, posterPath: response.profilePath)))
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
    
    struct FetchTMDBShowsFromTrakt: AsyncAction {
        let list: [TraktList]
        let showList: TVShowList
        func execute(state: FluxState?, dispatch: @escaping DispatchFunction) {
            var ids = [Int]()
            for trakt in list {
                if let tmdbId = trakt.ids?.tmdb {
                    ids.append(tmdbId)
                    if let slug = trakt.ids?.slug {
                        dispatch(SetShowSlug(showId: tmdbId, slug: slug))
                    }
                    if let appState = state as? AppState {
                        if appState.tvShowState.tvShowDetail[tmdbId] == nil {
                            dispatch(FetchTVShowDetails(id: tmdbId))
                        }
                    }
                }
            }
//            dispatch(SetTVShowList(list: self.showList, ids: ids))
        }
    }
    
    struct FetchTVShowDetails: AsyncAction {
        let id: Int
        func execute(state: FluxState?, dispatch: @escaping DispatchFunction) {
            TMDB_Parameters[TMDBClient.ParameterKeys.Append_Resource] = TMDBClient.ParameterValues.AppendVideoCreditsSimilar
            TMDBClient.sharedInstance.GET(endpoint: TMDBClient.Endpoint.TV_ShowDetails(id: id), params: TMDB_Parameters)
            {
                (result: Result<TVShowDetails, APIError>) in
                switch result {
                case let .success(response):
                    dispatch(SetTVShowDetail(id: self.id, tvShowDetail: response))
                case let .failure(error):
                    print(error)
                    break
                }
            }
        }
    }
    
    struct FetchTVShowSeasonDetails: AsyncAction {
        let id: Int
        let seasonId: Int
        func execute(state: FluxState?, dispatch: @escaping DispatchFunction) {
            TMDB_Parameters[TMDBClient.ParameterKeys.Append_Resource] = TMDBClient.ParameterValues.AppendSeasonDetails
            TMDBClient.sharedInstance.GET(endpoint: TMDBClient.Endpoint.TV_Seasons_Details(id: id, seasonNum: seasonId), params: TMDB_Parameters)
            {
                (result: Result<Season, APIError>) in
                switch result {
                case let .success(response):
                    dispatch(SetTVShowSeason(id: self.id, seasonId: self.seasonId, season: response))
                case let .failure(error):
                    print(error)
                    break
                }
            }
        }
    }
    
    struct SearchTVShows: AsyncAction {
        let query: String
        func execute(state: FluxState?, dispatch: @escaping DispatchFunction) {
            TMDB_Parameters[TMDBClient.ParameterKeys.SearchQuery] = query
            TMDBClient.sharedInstance.GET(endpoint: TMDBClient.Endpoint.Search_TV, params: TMDB_Parameters)
            {
                (result: Result<TVShowResults, APIError>) in
                switch result {
                case let .success(response):
                    dispatch(SetTVShowSearch(query: self.query, tvShows: response.results))
                case let .failure(error):
                    print(error)
                    break
                }
            }
        }
    }
    
    struct FetchSimilarTVShows: AsyncAction {
        let id: Int
        func execute(state: FluxState?, dispatch: @escaping DispatchFunction) {
            TMDBClient.sharedInstance.GET(endpoint: TMDBClient.Endpoint.TV_Similar(id: id), params: TMDB_Parameters)
            {
                (result: Result<TVShowResults, APIError>) in
                switch result {
                case let .success(response):
                    dispatch(SetSimilarTVShows(id: self.id, tvShows: response.results))
                case let .failure(error):
                    print(error)
                    break
                }
            }
        }
    }
    
    struct FetchShowCast: AsyncAction {
        let id: Int
        func execute(state: FluxState?, dispatch: @escaping DispatchFunction) {
            TMDBClient.sharedInstance.GET(endpoint: TMDBClient.Endpoint.TV_ShowCredits(id: id), params: TMDB_Parameters)
            {
                (result: Result<Credits, APIError>) in
                switch result {
                case let .success(response):
                    dispatch(SetShowCast(id: self.id, cast: response.cast ?? [], crew: response.crew ?? []))
                case let .failure(error):
                    print(error)
                    break
                }
            }
        }
    }
    
    struct FetchShowDetailsFromIds: AsyncAction {
        let idList: Set<Int>
        func execute(state: FluxState?, dispatch: @escaping DispatchFunction) {
            for id in idList {
                dispatch(FetchTVShowDetails(id: id))
            }
        }
    }
    
    struct FetchTraktIds: AsyncAction {
        let showId: Int
        func execute(state: FluxState?, dispatch: @escaping DispatchFunction) {
            TraktApiClient.sharedInstance().GET(endpoint: .TraktIds(id: showId), params: ["type":"show"])
            {
                (result: Result<[IdSearchResult], APIError>) in
                switch result {
                case let .success(response):
                    let showIds = response.first { $0.show != nil }
                    if let slug = showIds?.show?.ids?.slug {
                        dispatch(SetShowSlug(showId: self.showId, slug: slug))
                    }
                case let .failure(error):
                    print(error)
                    break
                }
            }
        }
    }
    
    struct AddShowToFavorites: Action {
        let showId: Int
    }
    
    struct RemoveShowFromFavorites: Action {
        let showId: Int
    }
    
    struct SetTVShowList: Action {
        let list: TVShowList
        let shows: [TraktShow]
    }
    
    struct SetTVShowDetail: Action {
        let id: Int
        let tvShowDetail: TVShowDetails
    }
    
    struct SetTVShowSeason: Action {
        let id: Int
        let seasonId: Int
        let season: Season
    }
    
    struct SetTVShowSearch: Action {
        let query: String
        let tvShows: [TVShowDetails]
    }
    
    struct SetSimilarTVShows: Action {
        let id: Int
        let tvShows: [TVShowDetails]
    }
    
    struct SetShowCast: Action {
        let id: Int
        let cast: [Cast]
        let crew: [Crew]
    }
    
    struct SetShowSlug: Action {
        let showId: Int
        let slug: String
    }
    
    struct SetSlugImage: Action {
        let slug: String
        let slugImage: TraktImages
    }
    
    struct SetTraktShow: Action {
        let slug: String
        let traktShow: TraktShow
    }
    
    struct SetTraktSeasons: Action {
        let showSlug: String
        let seasons: [TraktSeason]
    }
    
    struct SetTraktCast: Action {
        let showSlug: String
        let cast: [TraktCast]
    }
    
    struct SetTraktRelatedShows: Action {
        let showSlug: String
        let shows: [TraktShow]
    }
    
    struct SetEntityImages: Action {
        let entity: TraktEntity
        let tmdbId: Int
        let slugImage: TraktImages
    }
}
