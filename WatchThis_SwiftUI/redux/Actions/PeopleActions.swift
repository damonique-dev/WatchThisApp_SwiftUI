//
//  PeopleActions.swift
//  WatchThis_SwiftUI
//
//  Created by Damonique Thomas on 8/28/19.
//  Copyright © 2019 Damonique Thomas. All rights reserved.
//

import Foundation

struct PeopleActions {
    
    struct FetchPersonDetails: AsyncAction {
        let id: Int
        func execute(state: FluxState?, dispatch: @escaping DispatchFunction) {
            TMDB_Parameters[TMDBClient.ParameterKeys.Append_Resource] = TMDBClient.ParameterValues.AppendAllCredits
            TMDBClient.sharedInstance().GET(endpoint: TMDBClient.Endpoint.Person_Details(id: id), params: TMDB_Parameters)
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
            TMDBClient.sharedInstance().GET(endpoint: TMDBClient.Endpoint.Person_Combined_Credits(id: id), params: TMDB_Parameters)
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
            TMDBClient.sharedInstance().GET(endpoint: TMDBClient.Endpoint.Search_People, params: TMDB_Parameters)
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
    
    struct AddPersonToCustomList: Action {
        let customListUUID: UUID
        let personId: Int
    }
    
    struct RemovePersonFromCustomList: Action {
        let customListUUID: UUID
        let personId: Int
    }
}
