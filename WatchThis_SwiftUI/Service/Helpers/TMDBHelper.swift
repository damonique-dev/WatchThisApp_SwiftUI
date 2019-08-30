//
//  TMDBConstants.swift
//  WatchThis
//
//  Created by Damonique Thomas on 3/25/18.
//  Copyright © 2018 Damonique Thomas. All rights reserved.
//

import Foundation

extension TMDBClient {
    struct Constants {
        static let ApiScheme = "https"
        static let ApiHost = "api.themoviedb.org"
        static let ApiPath = "/3"
        static let ImageURL = "https://image.tmdb.org/t/p/"
    }
    
    struct ParameterKeys {
        static let APIKey = "api_key"
        static let SearchQuery = "query"
        static let Append_Resource = "append_to_response"
    }
    
    struct ParameterValues {
        static let APIKey = "5cec1beafce0de2a66b1fb1392b0cdf3"
        static let Video = "videos"
    }
    
    enum Endpoint {
        case TV_Popular
        case TV_ShowDetails(id: Int)
        case TV_ShowCredits(id: Int)
        case Person_Details(id: Int)
        case Person_Images(id: Int)
        case Search_TV
        case Similar_TV(id: Int)
        case Person_Combined_Credits(id: Int)
        case TV_Seasons_Details(id: Int, seasonNum: Int)
        
        func path() -> String {
            switch self {
                case .TV_Popular:
                        return "/tv/popular"
                case let .TV_ShowDetails(id):
                        return "/tv/\(String(id))"
                case let .TV_ShowCredits(id):
                    return "/tv/\(String(id))/credits"
                case let .Person_Details(id):
                    return "/person/\(String(id))"
                case let .Person_Images(id):
                    return "/person/\(String(id))/images"
                case .Search_TV:
                    return "/search/tv"
                case let .Similar_TV(id):
                    return "/tv/\(String(id))/similar"
                case let .Person_Combined_Credits(id):
                    return "/person/\(String(id))/combined_credits"
                case let .TV_Seasons_Details(id, seasonNum):
                    return "/tv/\(String(id))/season/\(String(seasonNum))"
            }
        }
    }
    
    func subtituteKeyInMethod(method: String, key: String, value: String) -> String? {
        if method.range(of:"{\(key)}") != nil {
            return method.replacingOccurrences(of: "{\(key)}", with: value)
        } else {
            return nil
        }
    }
    
    func URLFromParameters(endpoint: Endpoint, parameters: [String:AnyObject]?) -> String {
        let params = parameters ?? [:]
        let components = NSURLComponents()
        components.scheme = Constants.ApiScheme
        components.host = Constants.ApiHost
        components.path = Constants.ApiPath + endpoint.path()
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in params {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return components.url!.absoluteString
    }
}
