//
//  TraktApiClient.swift
//  WatchThis_SwiftUI
//
//  Created by Damonique Thomas on 8/29/19.
//  Copyright © 2019 Damonique Thomas. All rights reserved.
//

import Foundation
import Alamofire

var Trakt_Parameters = [TraktApiClient.ParameterKeys.Extended : "full"]

class TraktApiClient {
    let decoder = JSONDecoder()
    
    let header: HTTPHeaders = [
        HeaderKeys.ApiKey:HeaderValues.ApiKey,
        HeaderKeys.ApiVersion: HeaderValues.ApiVersion,
        HeaderValues.ContentType: HeaderValues.ContentType
    ]
    
    class func sharedInstance() -> TraktApiClient {
        struct Singleton {
            static var sharedInstance = TraktApiClient()
        }
        return Singleton.sharedInstance
    }
    
    func GetList<T: Codable>(endpoint: Endpoint, params: [String: String]?, completionHandler: @escaping (Result<T, APIError>) -> Void) {
        let url = URLFromParameters(endpoint: endpoint, parameters: params as [String : AnyObject]?)
        AF.request(url, headers: header).responseJSON { response in
            switch response.result {
                case .success(let result):
                    do {
                        let data = try JSONSerialization.data(withJSONObject: result)
                        let object = try self.decoder.decode(T.self, from: data)
                        DispatchQueue.main.async {
                            completionHandler(.success(object))
                        }
                    } catch let error {
                        DispatchQueue.main.async {
                            #if DEBUG
                            print("GetShowList - JSON Decoding Error: \(error)")
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
