//
//  TraktApiConstants.swift
//  WatchThis
//
//  Created by Damonique Thomas on 3/25/18.
//  Copyright © 2018 Damonique Thomas. All rights reserved.
//

import Foundation

extension TraktApiClient {

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
    
    struct Methods {
        static let TV_Popular = "/shows/popular"
        static let TV_Trending = "/shows/trending"
    }
    
    func URLFromParameters(withPathExtension: String?, parameters: [String:AnyObject]) -> String {
        let components = NSURLComponents()
        
        components.scheme = Constants.ApiScheme
        components.host = Constants.ApiHost
        components.path = (withPathExtension ?? "")
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return components.url!.absoluteString
    }
}
