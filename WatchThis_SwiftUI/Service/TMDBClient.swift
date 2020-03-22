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
    private var parameters = [ParameterKeys.APIKey : ParameterValues.APIKey]
    private let decoder = JSONDecoder()
    
    private init() {
        self.decoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    static let sharedInstance = TMDBClient()
    
    func GET<T: Codable>(endpoint: Endpoint, params: [String: String]?, retryCount: Int = 0, completionHandler: @escaping (Result<T, APIError>) -> Void) {
        let url = URLFromParameters(endpoint: endpoint, parameters: params as [String : AnyObject]?)
        AF.request(url).validate(statusCode: 200..<300).responseJSON { response in
            switch response.result {
                case .success(let result):
                    do {
                        let data = try JSONSerialization.data(withJSONObject: result as? [String: AnyObject] ?? [:])
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
                    print("Error with endpoint \(endpoint.path()): \(error)")
                    #endif
                    DispatchQueue.main.async {
                        completionHandler(.failure(.networkError(error: error)))
                    }
                    return
            }
        }
    }
}
