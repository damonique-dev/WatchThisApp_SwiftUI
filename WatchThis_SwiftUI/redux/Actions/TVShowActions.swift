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
            TraktApiClient.sharedInstance().GetList(endpoint: endpoint, params: [:])
            {
                (result: Result<T, APIError>) in
                switch result {
                case let .success(response):
                    if T.self == [TraktList].self {
                        dispatch(FetchTMDBShowsFromTrakt(list: response as! [TraktList], showList: self.showList))
                    } else if T.self == [TraktShowListResults].self {
                        let list = (response as! [TraktShowListResults]).compactMap {$0.show}
                        dispatch(FetchTMDBShowsFromTrakt(list: list, showList: self.showList))
                    }
                case let .failure(error):
                    print(error)
                    break
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
            dispatch(SetTVShowList(list: self.showList, ids: ids))
        }
    }
    
    struct FetchTVShowDetails: AsyncAction {
        let id: Int
        func execute(state: FluxState?, dispatch: @escaping DispatchFunction) {
            TMDB_Parameters[TMDBClient.ParameterKeys.Append_Resource] = TMDBClient.ParameterValues.AppendVideoCreditsSimilar
            TMDBClient.sharedInstance().GET(endpoint: TMDBClient.Endpoint.TV_ShowDetails(id: id), params: TMDB_Parameters)
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
            TMDBClient.sharedInstance().GET(endpoint: TMDBClient.Endpoint.TV_Seasons_Details(id: id, seasonNum: seasonId), params: TMDB_Parameters)
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
            TMDBClient.sharedInstance().GET(endpoint: TMDBClient.Endpoint.Search_TV, params: TMDB_Parameters)
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
            TMDBClient.sharedInstance().GET(endpoint: TMDBClient.Endpoint.TV_Similar(id: id), params: TMDB_Parameters)
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
            TMDBClient.sharedInstance().GET(endpoint: TMDBClient.Endpoint.TV_ShowCredits(id: id), params: TMDB_Parameters)
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
            TraktApiClient.sharedInstance().GetList(endpoint: .TraktIds(id: showId), params: ["type":"show"])
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
        let ids: [Int]
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
}
