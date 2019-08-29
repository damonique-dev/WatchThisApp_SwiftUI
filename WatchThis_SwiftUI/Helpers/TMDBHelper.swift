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
    
    struct Methods {
        static let TV_Popular = "/tv/popular"
        static let TV_ShowDetails = "/tv/{id}"
        static let TV_ShowCredits = "/tv/{id}/credits"
        static let Person_Details = "/person/{id}"
        static let Person_Images = "/person/{id}/images"
        static let Search_TV = "/search/tv"
        static let Similar_TV = "/tv/{id}/similar"
        static let Person_Combined_Credits = "/person/{id}/combined_credits"
        static let TV_Seasons_Details = "/tv/{tv_id}/season/{season_number}"
    }
    
    struct PosterSize {
        static let Original = "original"
        static let Thumbnail = "w92"
        static let Detail = "w500"
    }
    
    func subtituteKeyInMethod(method: String, key: String, value: String) -> String? {
        if method.range(of:"{\(key)}") != nil {
            return method.replacingOccurrences(of: "{\(key)}", with: value)
        } else {
            return nil
        }
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
    
    func getOriginalImageUrl(imagePath: String) -> String {
        return Constants.ImageURL + PosterSize.Original + imagePath
    }
}
