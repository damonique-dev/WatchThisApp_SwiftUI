//
//  TvShowActions.swift
//  WatchThis_SwiftUI
//
//  Created by Damonique Thomas on 8/28/19.
//  Copyright © 2019 Damonique Thomas. All rights reserved.
//

import Foundation

var parameters = [TMDBClient.ParameterKeys.APIKey : TMDBClient.ParameterValues.APIKey]

struct TVShowActions {
    struct FetchPopularTVShows: AsyncAction {
        let id: Int
        func execute(state: FluxState?, dispatch: @escaping DispatchFunction) {
            TMDBClient.sharedInstance().GET(endpoint: TMDBClient.Endpoint.TV_Popular, params: parameters)
            {
                (result: Result<[TVShow], APIError>) in
                switch result {
                case let .success(response):
                    dispatch(SetTVShows(tvShows: response))
                case let .failure(error):
                    print(error)
                    break
                }
            }
        }
    }
    
    struct FetchTVShowDetails: AsyncAction {
        let id: Int
        func execute(state: FluxState?, dispatch: @escaping DispatchFunction) {
            parameters[TMDBClient.ParameterKeys.Append_Resource] = TMDBClient.ParameterValues.Video
            TMDBClient.sharedInstance().GET(endpoint: TMDBClient.Endpoint.TV_ShowDetails(id: id), params: parameters)
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
            parameters[TMDBClient.ParameterKeys.Append_Resource] = TMDBClient.ParameterValues.Video
            TMDBClient.sharedInstance().GET(endpoint: TMDBClient.Endpoint.TV_Seasons_Details(id: id, seasonNum: seasonId), params: parameters)
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
    
    struct FetchTVShowCredits: AsyncAction {
        let id: Int
        func execute(state: FluxState?, dispatch: @escaping DispatchFunction) {
            TMDBClient.sharedInstance().GET(endpoint: TMDBClient.Endpoint.TV_ShowCredits(id: id), params: parameters)
            {
                (result: Result<[Person], APIError>) in
                switch result {
                case let .success(response):
                    dispatch(SetTVShowCast(id: self.id, cast: response))
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
            parameters[TMDBClient.ParameterKeys.SearchQuery] = query
            TMDBClient.sharedInstance().GET(endpoint: TMDBClient.Endpoint.Search_TV, params: parameters)
            {
                (result: Result<[TVShow], APIError>) in
                switch result {
                case let .success(response):
                    dispatch(SetTVShowSearch(query: self.query, tvShows: response))
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
            TMDBClient.sharedInstance().GET(endpoint: TMDBClient.Endpoint.Similar_TV(id: id), params: parameters)
            {
                (result: Result<[TVShow], APIError>) in
                switch result {
                case let .success(response):
                    dispatch(SetSimilarTVShows(id: self.id, tvShows: response))
                case let .failure(error):
                    print(error)
                    break
                }
            }
        }
    }
    
    struct SetTVShows: Action {
        let tvShows: [TVShow]
    }
    
    struct SetTVShowCast: Action {
        let id: Int
        let cast: [Person]
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
        let tvShows: [TVShow]
    }
    
    struct SetSimilarTVShows: Action {
        let id: Int
        let tvShows: [TVShow]
    }
}
