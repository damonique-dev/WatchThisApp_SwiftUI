//
//  PeopleActions.swift
//  WatchThis_SwiftUI
//
//  Created by Damonique Thomas on 8/28/19.
//  Copyright © 2019 Damonique Thomas. All rights reserved.
//

import Foundation
import SwiftUIFlux

struct PeopleActions {
    
    struct FetchPersonDetails: AsyncAction {
        let id: Int
        func execute(state: FluxState?, dispatch: @escaping DispatchFunction) {
            TMDB_Parameters[TMDBClient.ParameterKeys.Append_Resource] = TMDBClient.ParameterValues.AppendAllCredits
            TMDBClient.sharedInstance.GET(endpoint: TMDBClient.Endpoint.Person_Details(id: id), params: TMDB_Parameters)
            {
                (result: Result<PersonDetails, APIError>) in
                switch result {
                case let .success(response):
                    dispatch(SetPersonDetail(id: self.id, personDetail: response))
                case let .failure(error):
                    print(error)
                    break
                }
            }
        }
    }
    
    // TODO: Change to handle movies
    struct FetchPersonCombinedCredit: AsyncAction {
        let id: Int
        func execute(state: FluxState?, dispatch: @escaping DispatchFunction) {
            TMDBClient.sharedInstance.GET(endpoint: TMDBClient.Endpoint.Person_Combined_Credits(id: id), params: TMDB_Parameters)
            {
                (result: Result<[TVShow], APIError>) in
                switch result {
                case let .success(response):
                    dispatch(SetPersonCredits(id: self.id, tvShows: response))
                case let .failure(error):
                    print(error)
                    break
                }
            }
        }
    }
    
    struct SearchPeople: AsyncAction {
        let query: String
        func execute(state: FluxState?, dispatch: @escaping DispatchFunction) {
            TMDB_Parameters[TMDBClient.ParameterKeys.SearchQuery] = query
            TMDBClient.sharedInstance.GET(endpoint: TMDBClient.Endpoint.Search_People, params: TMDB_Parameters)
            {
                (result: Result<PeopleResults, APIError>) in
                switch result {
                case let .success(response):
                    dispatch(SetPersonSearch(query: self.query, people: response.results))
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
                    if self.endpoint == TraktApiClient.Endpoint.Person_TVCredits(slug: slug) {
                        let castlist = (response as! TraktShowCreditsResults).cast
                        dispatch(SetPersonShowCredits(slug: slug, credit: castlist))
                        dispatch(FetchImagesFromTMDB(credits: castlist))
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
        let credits: [TraktShowCredits]
        func execute(state: FluxState?, dispatch: @escaping DispatchFunction) {
            for credit in credits {
                if let appState = state as? AppState, let tmdbId = credit.show.ids?.tmdb, let slug = credit.show.ids?.slug {
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
                    dispatch(SetTraktShow(slug: slug, traktShow: credit.show))
                }
            }
        }
    }
    
    struct SetPersonShowCredits: Action {
        let slug: String
        let credit: [TraktShowCredits]
    }
    
    struct SetSlugImage: Action {
        let slug: String
        let slugImage: TraktImages
    }
    
    struct SetTraktShow: Action {
        let slug: String
        let traktShow: TraktShow
    }
    
    struct SetPersonDetail: Action {
        let id: Int
        let personDetail: PersonDetails
    }
    
    struct SetPersonCredits: Action {
        let id: Int
        let tvShows: [TVShow]
    }
    
    struct AddPersonToFavorites: Action {
        let personId: Int
    }
    
    struct RemovePersonFromFavorites: Action {
        let personId: Int
    }
    
    struct SetPersonSearch: Action {
        let query: String
        let people: [PersonDetails]
    }
}
