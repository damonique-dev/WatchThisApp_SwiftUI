//
//  SeasonDetailView.swift
//  WatchThis_SwiftUI
//
//  Created by Damonique Thomas on 9/15/19.
//  Copyright © 2019 Damonique Thomas. All rights reserved.
//

import SwiftUI

struct SeasonDetailView: View {
    @EnvironmentObject var store: Store<AppState>
    @State var rowExpanstionState: [Int:Bool] = [:]
    
    let showId: Int
    let seasonId: Int
    
    private var seasonDetails: Season {
        return store.state.tvShowState.tvShowSeasons[showId]?[seasonId] ?? Season()
    }
    
    private var imagePath: String? {
        return seasonDetails.posterPath
    }
    
    private func fetchSeasonDetails() {
        if store.state.tvShowState.tvShowSeasons[showId]?[seasonId] == nil {
            store.dispatch(action: TVShowActions.FetchTVShowSeasonDetails(id: showId, seasonId: seasonId))
        }
    }
    
    private func getHeaderText(episode: Episode) -> String {
        return "Episode \(episode.episodeNumber ?? 0): \(episode.name ?? "")"
    }
    
    private var episodes: [Episode] {
        return seasonDetails.episodes ?? []
    }
    
    private func isExpanded(_ section:Int) -> Bool {
        rowExpanstionState[section] ?? false
    }
    
    var body: some View {
        ZStack {
            BlurredBackground(image: nil, imagePath: imagePath)
            ScrollView(.vertical) {
                VStack(alignment: .leading) {
                    SeasonDetailsHeader(seasonDetails: seasonDetails)
                    Text("Episodes:")
                        .font(.headline)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.leading)
                        .padding(.leading, 8)
                    ForEach(episodes, id: \.id) { episode in
                        VStack {
                            EpisodeSectionHeader(headerText: self.getHeaderText(episode: episode), isExpanded: self.isExpanded(episode.id))
                                .font(.headline)
                                .onTapGesture {
                                    self.rowExpanstionState[episode.id] = !self.isExpanded(episode.id)
                            }
                            if self.isExpanded(episode.id) {
                                EpisodeRow(episode: episode)
                            }
                        }.padding(.top, -6)
                    }
                }
            }.padding(.bottom, 16)
        }
        .padding(.vertical, 44)
        .navigationBarTitle(Text("\(seasonDetails.name ?? "")"))
        .onAppear() {
            self.fetchSeasonDetails()
        }
    }
}

struct SeasonDetailsHeader: View {
    let seasonDetails: Season
    
    private let imageWidth = UIScreen.main.bounds.width/3
    private let imageHeight = (UIScreen.main.bounds.width/3) * 11/8
    
    private var cast: [Cast] {
        return seasonDetails.credits?.cast ?? []
    }
    
    var body: some View {
        VStack {
            ImageLoaderView(imageLoader: ImageLoaderCache.sharedInstance().loaderFor(path: seasonDetails.posterPath,
                                                                                 size: .original))
            .frame(width: imageWidth, height: imageHeight)
            Text("\(seasonDetails.overview ?? "")")
                .font(.body)
                .foregroundColor(.white)
                .fixedSize(horizontal: false, vertical: true)
            if cast.count > 0 {
                DetailCategoryRow(categoryTitle: "Cast") {
                    ForEach(self.cast) { cast in
                        NavigationLink(destination: PersonDetailsView(personId: cast.id, personName: cast.name)) {
                            CastCellView(person: cast)
                        }
                    }
                }
            }
        }.padding(.horizontal, 8)
    }
}

struct EpisodeSectionHeader: View {
    let headerText: String
    let isExpanded: Bool
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(Color(.white).opacity(0.1))
            HStack {
                Text(headerText)
                Spacer()
                Image(systemName: "chevron.down")
                    .rotationEffect(.degrees(isExpanded ? 0 : 180))
                    .animation(.spring())
                    .padding(.trailing, 4)

            }.padding(.horizontal, 8)
        }.frame(height: 35)
    }
}

struct EpisodeRow: View {
    let episode: Episode
    
    private let imageWidth = UIScreen.main.bounds.width - 32
    
    private var guestStars: [Cast] {
        return episode.guestStars ?? []
    }

    var body: some View {
        VStack {
            ImageLoaderView(imageLoader: ImageLoaderCache.sharedInstance().loaderFor(path: episode.stillPath,
                                                                                     size: .original))
                .frame(width: imageWidth, height: imageWidth * 8/11)
            Text("\(episode.overview ?? "")")
                .font(.body)
                .foregroundColor(.white)
                .fixedSize(horizontal: false, vertical: true)
            if guestStars.count > 0 {
                DetailCategoryRow(categoryTitle: "Guest Stars") {
                    ForEach(self.guestStars) { cast in
                        NavigationLink(destination: PersonDetailsView(personId: cast.id, personName: cast.name)) {
                            CastCellView(person: cast)
                        }
                    }
                }
            }
        }.padding(.bottom, 8)
    }
}
