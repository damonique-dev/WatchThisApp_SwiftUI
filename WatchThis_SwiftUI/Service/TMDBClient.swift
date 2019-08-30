//
//  TMDBClient.swift
//  WatchThis
//
//  Created by Damonique Thomas on 3/25/18.
//  Copyright © 2018 Damonique Thomas. All rights reserved.
//

import Foundation
import Alamofire

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
        let endpoint = URLFromParameters(endpoint: endpoint, parameters: params as [String : AnyObject]?)
        AF.request(endpoint).responseJSON { response in
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
                            print("JSON Decoding Error: \(error)")
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
    
    func getShowsFromIdList(ids: [Int], completionHandler: @escaping (Result<[TVShowDetails], APIError>) -> Void) {
        var shows = [TVShowDetails?](repeating: nil, count: ids.count)
        let dispatchGroup = DispatchGroup()
        for id in ids {
            dispatchGroup.enter()
//            getShowDetails(id: id) { result in
//                switch result {
//                case .success(let showDetails):
//                    let index = ids.firstIndex(of: showDetails.id!)
//                    if index != nil {
//                        shows[index!] = showDetails
//                    }
//                    dispatchGroup.leave()
//                    return
//                case .failure(let error):
//                    completionHandler(.failure(error))
//                    dispatchGroup.leave()
//                    return
//                }
//            }
        }
        dispatchGroup.notify(queue: .main) {
            if let returnedShows = shows.filter({$0 != nil}) as? [TVShowDetails] {
                completionHandler(.success(returnedShows))
            }
        }
    }
}
