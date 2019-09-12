//
//  MovieActions.swift
//  WatchThis_SwiftUI
//
//  Created by Damonique Thomas on 9/11/19.
//  Copyright © 2019 Damonique Thomas. All rights reserved.
//

import Foundation

struct MovieActions {
    struct FetchTraktMovieList<T: Codable>: AsyncAction {
        let endpoint: TraktApiClient.Endpoint
        let movieList: MovieList
        func execute(state: FluxState?, dispatch: @escaping DispatchFunction) {
            TraktApiClient.sharedInstance().GetList(endpoint: endpoint, params: [:])
            {
                (result: Result<T, APIError>) in
                switch result {
                case let .success(response):
                    if T.self == [TraktList].self {
                        dispatch(FetchTMDBMoviesFromTrakt(list: response as! [TraktList], movieList: self.movieList))
                    } else if T.self == [TraktMovieListResults].self {
                        let list = (response as! [TraktMovieListResults]).compactMap {$0.movie}
                        dispatch(FetchTMDBMoviesFromTrakt(list: list, movieList: self.movieList))
                    }
                case let .failure(error):
                    print(error)
                    break
                }
            }
        }
    }
    
    struct FetchTMDBMoviesFromTrakt: AsyncAction {
        let list: [TraktList]
        let movieList: MovieList
        func execute(state: FluxState?, dispatch: @escaping DispatchFunction) {
            var ids = [Int]()
            for trakt in list {
                if let tmdbId = trakt.ids?.tmdb {
                    ids.append(tmdbId)
                    dispatch(FetchMovieDetails(id: tmdbId))
                }
            }
            dispatch(SetMovieList(list: self.movieList, ids: ids))
        }
    }
    
    struct FetchMovieDetails: AsyncAction {
        let id: Int
        func execute(state: FluxState?, dispatch: @escaping DispatchFunction) {
            TMDB_Parameters[TMDBClient.ParameterKeys.Append_Resource] = TMDBClient.ParameterValues.AppendVideoCreditsSimilar
            TMDBClient.sharedInstance().GET(endpoint: TMDBClient.Endpoint.Movie_Details(id: id), params: TMDB_Parameters)
            {
                (result: Result<MovieDetails, APIError>) in
                switch result {
                case let .success(response):
                    dispatch(SetMovieDetail(id: self.id, movieDetails: response))
                case let .failure(error):
                    print(error)
                    break
                }
            }
        }
    }
    
    struct SetMovieList: Action {
        let list: MovieList
        let ids: [Int]
    }
    
    struct SetMovieDetail: Action {
        let id: Int
        let movieDetails: MovieDetails
    }
    
    struct AddMovieToFavorites: Action {
        let movieId: Int
    }
    
    struct RemoveMovieFromFavorites: Action {
        let movieId: Int
    }
}
