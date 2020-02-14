//
//  ImageLoader.swift
//  WatchThis_SwiftUI
//
//  Created by Damonique Thomas on 9/1/19.
//  Copyright © 2019 Damonique Thomas. All rights reserved.
//

import SwiftUI
import UIKit
import Combine

class ImageLoaderCache {
    static var sharedInstance = ImageLoaderCache()
    
    private init() {}
    
    var loaders: NSCache<NSString, ImageLoader> = NSCache()
            
    func loaderFor(path: String?, size: TMDbImageSize) -> ImageLoader {
        let key = NSString(string: "\(path ?? "missing")#\(size.rawValue)")
        if let loader = loaders.object(forKey: key) {
            return loader
        } else {
            let url = size.path(urlPath: path ?? "")
            let loader = ImageLoader(url: url)
            return loader
        }
    }
}

class ImageLoader: ObservableObject {
    var didChange = PassthroughSubject<Data, Never>()
    var data = Data() {
        didSet {
            didChange.send(data)
        }
    }

    init(url:URL?) {
        guard let url = url else { return }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            DispatchQueue.main.async {
                self.data = data
            }
        }
        task.resume()
    }
}

enum TMDbImageSize: String, Codable {
    case small = "https://image.tmdb.org/t/p/w154"
    case medium = "https://image.tmdb.org/t/p/w500"
    case cast = "https://image.tmdb.org/t/p/w185"
    case original = "https://image.tmdb.org/t/p/original"
    
    func path(urlPath: String) -> URL? {
        return URL(string: rawValue)?.appendingPathComponent(urlPath)
    }
}
