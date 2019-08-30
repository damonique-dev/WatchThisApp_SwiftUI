//
//  AppActions.swift
//  WatchThis_SwiftUI
//
//  Created by Damonique Thomas on 8/29/19.
//  Copyright © 2019 Damonique Thomas. All rights reserved.
//

import Foundation

struct AppActions {
    
    struct FetchImage: AsyncAction {
        let urlPath: String
        let size: ImageService.Size
        
        func execute(state: FluxState?, dispatch: @escaping DispatchFunction) {
            ImageService.sharedInstance().fetchImage(urlPath: urlPath, size: size) {
                (result: Result<Data, ImageService.ImageError>) in
                switch result {
                case let .success(response):
                    dispatch(SetImage(urlPath: self.urlPath, size: self.size, imageData: response))
                case let .failure(error):
                    print(error)
                    break
                }
            }
        }
    }
    
    struct SetImage: Action {
        let urlPath: String
        let size: ImageService.Size
        let imageData: Data
    }
}
