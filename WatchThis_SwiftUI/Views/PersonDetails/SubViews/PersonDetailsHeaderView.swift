//
//  PersonDetailsHeaderView.swift
//  WatchThis_SwiftUI
//
//  Created by Damonique Thomas on 9/14/19.
//  Copyright © 2019 Damonique Thomas. All rights reserved.
//

import SwiftUI

struct PersonDetailsHeaderView: View {
    @EnvironmentObject var store: Store<AppState>
    
    let personDetails: PersonDetails
    
    private let screenWidth = UIScreen.main.bounds.width
    private let screenHeight = UIScreen.main.bounds.height
    private let backgroundImageHeight = UIScreen.main.bounds.height/3
    private let showImageWidth = UIScreen.main.bounds.width/3
    private let showImageHeight = (UIScreen.main.bounds.width/3) * 11/8
    private let showImageTop = (UIScreen.main.bounds.height/3) - (((UIScreen.main.bounds.width/3) * 11/8)/2)
    
    private func getFirstCreditBackdrop() -> String? {
        if !(personDetails.movieCredits?.cast?.isEmpty ?? false) {
            let firstCredit = personDetails.movieCredits?.cast![0]
            return firstCredit?.backdropPath
        }
        if !(personDetails.tvCredits?.cast?.isEmpty ?? false) {
            let firstCredit = personDetails.tvCredits?.cast![0]
            return firstCredit?.backdropPath
        }
        
        // TODO: Add placeholder if person has no tv or movie credits
        return nil
    }
    
    var body: some View {
        ZStack {
            VStack {
                ImageLoaderView(imageLoader: ImageLoaderCache.sharedInstance().loaderFor(path: getFirstCreditBackdrop(),
                                                                                         size: .original), contentMode: .fill)
                .frame(width: screenWidth, height: backgroundImageHeight, alignment: .center)
                Spacer()
            }
            VStack {
                HStack {
                    ImageLoaderView(imageLoader: ImageLoaderCache.sharedInstance().loaderFor(path: personDetails.profilePath,
                                                                                             size: .original), contentMode: .fill)
                    .frame(width: showImageWidth, height: showImageHeight, alignment: .center)
                }
                    
                HStack {
                    Text("\(personDetails.name ?? "")")
                        .font(Font.system(.title, design: .rounded))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
            }.padding(.top, showImageTop)
        }
    }
}
