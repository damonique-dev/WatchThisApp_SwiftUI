//
//  TraktApiHelper.swift
//  WatchThis_SwiftUI
//
//  Created by Damonique Thomas on 8/29/19.
//  Copyright © 2019 Damonique Thomas. All rights reserved.
//

import Foundation

extension TraktApiClient {
    static let whereToWatchUrl = ""
    
    struct Constants {
        static let ApiScheme = "https"
        static let ApiHost = "api.trakt.tv"
    }
    
    struct HeaderKeys {
        static let ContentType = "Content-type"
        static let ApiKey = "trakt-api-key"
        static let ApiVersion = "trakt-api-version"
        static let Authorization = "Authorization"
        static let CurrentPage = "X-Pagination-Page"
        static let ItemsPerPage = "X-Pagination-Limit"
        static let TotalPageCount = "X-Pagination-Page-Count"
        static let TotalItemCount = "X-Pagination-Item-Count"
    }
    
    struct HeaderValues {
        static let ContentType = "application/json"
        static let ApiKey = "fc948ebe57e67356d97a1fba156d79b195fd22c6e953c3e4d4cb977dd536eb6d"
        static let ApiVersion = "2"
    }
    
    struct ParameterKeys {
        static let Page = "page"
        static let Limit = "limit"
        static let Extended = "extended"
    }
    
    
    enum Endpoint {
        // TV Enpoints
        case TV_Popular
        case TV_Trending
        case TV_MostWatchedWeekly
        case TV_Anticipated
        
        // Movie Endpoints
        case Movie_Trending
        case Movie_Popular
        case Movie_TopGrossing // In US Box office from past weekend
        case Movie_Anticipated
        case Movie_MostWatchedWeekly
        
         case TraktIds(id: Int)
        
        func path() -> String {
            switch self {
                case .TV_Popular:
                    return "/shows/popular"
                case .TV_Trending:
                    return "/shows/trending"
                case .TV_MostWatchedWeekly:
                    return "/shows/watched/weekly"
                case .TV_Anticipated:
                    return "/shows/anticipated"
                case .Movie_Trending:
                        return "/movies/trending"
                case .Movie_Popular:
                    return "/movies/popular"
                case .Movie_TopGrossing:
                    return "/movies/boxoffice"
                case .Movie_Anticipated:
                    return "/movies/anticipated"
                case .Movie_MostWatchedWeekly:
                    return "/movies/watched/weekly"
                case let .TraktIds(id):
                    return "/search/tmdb/\(id)"
            }
        }
    }
    
    func URLFromParameters(endpoint: Endpoint, parameters: [String:AnyObject]?) -> String {
        let params = parameters ?? [:]
        let components = NSURLComponents()
        components.scheme = Constants.ApiScheme
        components.host = Constants.ApiHost
        components.path = endpoint.path()
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in params {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return components.url!.absoluteString
    }
}
