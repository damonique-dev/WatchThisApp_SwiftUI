//
//  TratkHelper.swift
//  WatchThis
//
//  Created by Damonique Thomas on 8/18/18.
//  Copyright © 2018 Damonique Thomas. All rights reserved.
//

import Foundation

extension TraktClient {
    struct Constants {
        static let ApiScheme = "https"
        static let ApiHost = "api.trakt.tv"
        static let ApiPath = ""
        static let ImageURL = "https://image.tmdb.org/t/p/"
    }
    
    struct ParameterKeys {
        static let APIKey = "trakt-api-key"
    }
    
    struct ParameterValues {
        static let APIKey = "fc948ebe57e67356d97a1fba156d79b195fd22c6e953c3e4d4cb977dd536eb6d"
    }
    
    struct Methods {
        static let TV_Trending = "/shows/trending"
    }
    
    func URLFromParameters(withPathExtension: String?, parameters: [String:AnyObject]) -> String {
        let components = NSURLComponents()
        components.scheme = Constants.ApiScheme
        components.host = Constants.ApiHost
        components.path = Constants.ApiPath + (withPathExtension ?? "")
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return components.url!.absoluteString
    }
}
