//
//  SearchResultsRows.swift
//  WatchThis_SwiftUI
//
//  Created by Damonique Thomas on 9/15/19.
//  Copyright © 2019 Damonique Thomas. All rights reserved.
//

import SwiftUI

struct SearchViewRow: View {
    let title: String
    let overview: String?
    let posterPath: String?
    let rectangleWidth = UIScreen.main.bounds.width - (100 * 8/11) - 50
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                ImageLoaderView(imageLoader: ImageLoaderCache.sharedInstance.loaderFor(path: posterPath, size: .original), contentMode: .fill, placeholder: .poster)
                    .frame(width: 100 * 8/11, height: 100)
                VStack(alignment: .leading) {
                    Text(title)
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    if overview != nil && !(overview?.isEmpty ?? true) {
                        Text(overview!)
                            .font(.body)
                            .foregroundColor(.white)
                            .lineLimit(3)
                    } else {
                        Rectangle()
                            .foregroundColor(Color.black.opacity(0))
                            .frame(width: rectangleWidth)
                    }
                    Spacer()
                }
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0)
                .padding(.leading, 4)
            }
            Divider().background(Color.white).padding(.vertical, 8)
        }.padding()
    }
}

struct PeopleSearchRow: View {
    let person: TraktPerson
    let posterPath: String?
    
    private let rectangleWidth = UIScreen.main.bounds.width - (100 * 8/11) - 50
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                ImageLoaderView(imageLoader: ImageLoaderCache.sharedInstance.loaderFor(path: posterPath,
                                                                                       size: .original), contentMode: .fill, placeholder: .person)
                    .frame(width: 100 * 8/11, height: 100)
                Text(person.name!)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            Divider().background(Color.white)
        }.padding()
    }
}

struct PreviousSearchRow: View {
    let query: String
    var body: some View {
        VStack {
            HStack(alignment: .center) {
                Text(query)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }.padding(.bottom)
            Divider().background(Color.white)
        }.padding(.bottom)
    }
}

