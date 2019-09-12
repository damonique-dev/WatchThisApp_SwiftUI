//
//  TMDBClient.swift
//  WatchThis
//
//  Created by Damonique Thomas on 3/25/18.
//  Copyright © 2018 Damonique Thomas. All rights reserved.
//

import Foundation
import Alamofire

var TMDB_Parameters = [TMDBClient.ParameterKeys.APIKey : TMDBClient.ParameterValues.APIKey]

class TMDBClient {
    var parameters = [ParameterKeys.APIKey : ParameterValues.APIKey]
    let decoder = JSONDecoder()
    
    class func sharedInstance() -> TMDBClient {
        struct Singleton {
            static var sharedInstance = TMDBClient()
        }
        return Singleton.sharedInstance
    }
    
    func GET<T: Codable>(endpoint: Endpoint, params: [String: String]?, completionHandler: @escaping (Result<T, APIError>) -> Void) {
        let url = URLFromParameters(endpoint: endpoint, parameters: params as [String : AnyObject]?)
        AF.request(url).responseJSON { response in
            switch response.result {
                case .success(let result):
                    do {
                        let data = try JSONSerialization.data(withJSONObject: result as? [String: AnyObject] ?? [:])
                        self.decoder.keyDecodingStrategy = .convertFromSnakeCase
                        let object = try self.decoder.decode(T.self, from: data)
                        DispatchQueue.main.async {
                            completionHandler(.success(object))
                        }
                    } catch let error {
                        DispatchQueue.main.async {
                            #if DEBUG
                            print("TMDB - JSON Decoding Error: \(error)")
                            #endif
                            completionHandler(.failure(.jsonDecodingError(error: error)))
                        }
                    }
                    return
                case .failure(let error):
                    #if DEBUG
                    print("Error: \(error)")
                    #endif
                    DispatchQueue.main.async {
                        completionHandler(.failure(.networkError(error: error)))
                    }
                    return
            }
        }
    }
}
