//
//  TvShowActions.swift
//  WatchThis_SwiftUI
//
//  Created by Damonique Thomas on 8/28/19.
//  Copyright © 2019 Damonique Thomas. All rights reserved.
//

import Foundation

var TMDB_Parameters = [TMDBClient.ParameterKeys.APIKey : TMDBClient.ParameterValues.APIKey]
var Trakt_Parameters = [TraktApiClient.ParameterKeys.Extended : "full"]

struct TVShowActions {
    struct FetchTraktPopularShowList: AsyncAction {
        let endpoint: TraktApiClient.Endpoint
        let showList: TVShowList
        func execute(state: FluxState?, dispatch: @escaping DispatchFunction) {
            TraktApiClient.sharedInstance().GetShowList(endpoint: endpoint, params: [:])
            {
                (result: Result<[TraktList], APIError>) in
                switch result {
                case let .success(response):
                    dispatch(FetchTMDBShowsFromTrakt(list: response, showList: self.showList))
                case let .failure(error):
                    print(error)
                    break
                }
            }
        }
    }
    
    struct FetchTraktTrendingShowList: AsyncAction {
        let endpoint: TraktApiClient.Endpoint
        let showList: TVShowList
        func execute(state: FluxState?, dispatch: @escaping DispatchFunction) {
            TraktApiClient.sharedInstance().GetShowList(endpoint: endpoint, params: [:])
            {
                (result: Result<[TraktListResults], APIError>) in
                switch result {
                case let .success(response):
                    let list = response.compactMap {$0.show}
                    dispatch(FetchTMDBShowsFromTrakt(list: list, showList: self.showList))
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
                    dispatch(FetchTVShowDetails(id: tmdbId))
                }
            }
            dispatch(SetTVShowList(list: self.showList, ids: ids))
        }
    }
    
    struct FetchTVShowDetails: AsyncAction {
        let id: Int
        func execute(state: FluxState?, dispatch: @escaping DispatchFunction) {
            TMDB_Parameters[TMDBClient.ParameterKeys.Append_Resource] = TMDBClient.ParameterValues.Video
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
            TMDB_Parameters[TMDBClient.ParameterKeys.Append_Resource] = TMDBClient.ParameterValues.Video
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
            TMDBClient.sharedInstance().GET(endpoint: TMDBClient.Endpoint.Similar_TV(id: id), params: TMDB_Parameters)
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
                    dispatch(SetShowCast(id: self.id, cast: response.cast, crew: response.crew))
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
}
