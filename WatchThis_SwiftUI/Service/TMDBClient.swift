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
    
    enum APIError: Error {
        case noResponse
        case jsonDecodingError(error: Error)
        case networkError(error: Error)
    }
    
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
    
    func getPopularTVShows(completionHandler: @escaping (Result<[TVShow], APIError>) -> Void) {
        GET(endpoint: Endpoint.TV_Popular, params: parameters, completionHandler: { result in
            completionHandler(result)
        })
    }
    
    func getShowDetails(id: Int, completionHandler: @escaping (Result<TVShowDetails, APIError>) -> Void) {
        parameters[ParameterKeys.Append_Resource] = ParameterValues.Video
        GET(endpoint: Endpoint.TV_ShowDetails(id: id), params: parameters, completionHandler: { result in
            completionHandler(result)
        })
    }
    
    func getShowSeasonDetails(showId: Int, seasonNumber: Int, completionHandler: @escaping (Result<Season, APIError>) -> Void) {
        parameters[ParameterKeys.Append_Resource] = ParameterValues.Video
        GET(endpoint: Endpoint.TV_Seasons_Details(id: showId, seasonNum: seasonNumber), params: parameters, completionHandler: { result in
            completionHandler(result)
        })
    }
    
    func getPersonDetails(id: Int, completionHandler: @escaping (Result<Person, APIError>) -> Void) {
        GET(endpoint: Endpoint.Person_Details(id: id), params: parameters, completionHandler: { result in
            completionHandler(result)
        })
    }
    
    // TODO: Change to handle movies
    func getPersonCombinedCredits(id: Int, completionHandler: @escaping (Result<[TVShow], APIError>) -> Void) {
        GET(endpoint: Endpoint.Person_Combined_Credits(id: id), params: parameters, completionHandler: { result in
            completionHandler(result)
        })
    }
    
    func getShowCredits(id: Int, completionHandler: @escaping (Result<[Person], APIError>) -> Void) {
        GET(endpoint: Endpoint.TV_ShowCredits(id: id), params: parameters, completionHandler: { result in
            completionHandler(result)
        })
    }
    
    func searchTVShows(query: String, completionHandler: @escaping (_ query: String?, Result<[TVShow], APIError>) -> Void) {
        parameters[ParameterKeys.SearchQuery] = query
        GET(endpoint: Endpoint.Search_TV, params: parameters, completionHandler: { result in
            completionHandler(query, result)
        })
    }
    
    func getSimilarShows(id: Int, completionHandler: @escaping (Result<[TVShow], APIError>) -> Void) {
        GET(endpoint: Endpoint.Similar_TV(id: id), params: parameters, completionHandler: { result in
            completionHandler(result)
        })
    }
    
    func getShowsFromIdList(ids: [Int], completionHandler: @escaping (Result<[TVShowDetails], APIError>) -> Void) {
        var shows = [TVShowDetails?](repeating: nil, count: ids.count)
        let dispatchGroup = DispatchGroup()
        for id in ids {
            dispatchGroup.enter()
            getShowDetails(id: id) { result in
                switch result {
                case .success(let showDetails):
                    let index = ids.firstIndex(of: showDetails.id!)
                    if index != nil {
                        shows[index!] = showDetails
                    }
                    dispatchGroup.leave()
                    return
                case .failure(let error):
                    completionHandler(.failure(error))
                    dispatchGroup.leave()
                    return
                }
            }
        }
        dispatchGroup.notify(queue: .main) {
            if let returnedShows = shows.filter({$0 != nil}) as? [TVShowDetails] {
                completionHandler(.success(returnedShows))
            }
        }
    }
    
    func getImageData(urlString: String, targetSize: CGSize?=nil, completionHandler: @escaping (NSData?) -> Void) {
        guard let url = NSURL(string: urlString) else {
            completionHandler(nil)
            return
        }

        if let imageDataFromCache = imageCache.object(forKey: urlString as NSString) {
            completionHandler(imageDataFromCache)
            return
        }
        URLSession.shared.dataTask(with: url as URL, completionHandler: { (data, respones, error) in
            if error != nil {
                #if DEBUG
                print("Error: \(String(describing: error))")
                #endif
                completionHandler(nil)
                return
            }
            completionHandler(data as NSData?)
        }).resume()
    }
}
