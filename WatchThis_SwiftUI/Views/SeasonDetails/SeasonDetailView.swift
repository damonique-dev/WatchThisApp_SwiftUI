//
//  SeasonDetailView.swift
//  WatchThis_SwiftUI
//
//  Created by Damonique Thomas on 9/15/19.
//  Copyright © 2019 Damonique Thomas. All rights reserved.
//

import SwiftUI
import SwiftUIFlux

struct SeasonDetailView: View {
    @EnvironmentObject var store: Store<AppState>
    @State var rowExpanstionState: [UUID:Bool] = [:]
    
    let showSlug: String
    let seasonDetails: TraktSeason
    
    private var imagePath: String? {
        if let tmdbId = seasonDetails.ids.tmdb {
            return store.state.traktState.traktImages[.Season]?[tmdbId]?.posterPath
        }
        return nil
    }
    
    private func fetchSeasonDetails() {
        if store.state.traktState.traktEpisodes[showSlug]?[seasonDetails.number] == nil {
            if let showIds = store.state.traktState.traktShows[showSlug]?.ids {
                store.dispatch(action: TraktActions.FetchSeasonEpisodes(showIds: showIds, seasonNumber: seasonDetails.number))
            }
        }
    }
    
    private func getHeaderText(episode: TraktEpisode) -> String {
        return "Episode \(episode.number): \(episode.title ?? "")"
    }
    
    private var episodes: [TraktEpisode] {
        return store.state.traktState.traktEpisodes[showSlug]?[seasonDetails.number] ?? []
    }
    
    private func isExpanded(_ section: UUID) -> Bool {
        rowExpanstionState[section] ?? false
    }
    
    var body: some View {
        ZStack {
            BlurredBackground(image: nil, imagePath: imagePath)
            ScrollView(.vertical) {
                VStack(alignment: .leading) {
                    SeasonDetailsHeader(seasonDetails: seasonDetails)
                    if episodes.count > 0 {
                        Text("Episodes:")
                            .font(.title)
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
                }
                .frame(width: UIScreen.main.bounds.width - 16)
                .padding(.vertical, 16)
            }
        }
        .padding(.vertical, 44)
        .navigationBarTitle(Text("\(seasonDetails.title ?? "")"))
        .onAppear() {
            self.fetchSeasonDetails()
        }
    }
}

struct SeasonDetailsHeader: View {
    @EnvironmentObject var store: Store<AppState>
    let seasonDetails: TraktSeason
    
    private let imageWidth = UIScreen.main.bounds.width/3
    private let imageHeight = (UIScreen.main.bounds.width/3) * 11/8
    
    private var cast: [TraktCast] {
        return []
    }
    
    private var posterPath: String? {
        if let tmdbId = seasonDetails.ids.tmdb {
            return store.state.traktState.traktImages[.Season]?[tmdbId]?.posterPath
        }
        return nil
    }
    
    var body: some View {
        HStack {
            Spacer()
            VStack {
                ImageLoaderView(imageLoader: ImageLoaderCache.sharedInstance.loaderFor(path: posterPath, size: .original))
                    .frame(width: imageWidth, height: imageHeight)
                ExpandableTextView(title: seasonDetails.title ?? "", text: "\(seasonDetails.overview ?? "")", imagePath: posterPath, font: .headline, color: .white)
                if cast.count > 0 {
                    DetailCategoryRow(categoryTitle: "Cast") {
                        ForEach(self.cast) { cast in
                            NavigationLink(destination: PersonDetailsView(personDetails: cast.person)) {
                                CastCellView(person: cast)
                            }
                        }
                    }
                }
            }.padding(.horizontal, 8)
            Spacer()
        }
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
    @EnvironmentObject var store: Store<AppState>
    let episode: TraktEpisode
    
    private let imageWidth = UIScreen.main.bounds.width - 32
    
    private var guestStars: [TraktCast] {
        return []
    }
    
    private var posterPath: String? {
        if let tmdbId = episode.ids.tmdb {
            return store.state.traktState.traktImages[.Episode]?[tmdbId]?.posterPath
        }
        return nil
    }
    
    private func getRuntime() -> String {
        if let runtime = episode.runtime {
            return "\(runtime) minutes"
        }
        return ""
    }
    
    private var details: [OverviewDetail] {
            return [
                .init(title: "First Air Date:", detail: episode.firstAired?.fromISOtoDateString(format: "EEEE, MMMM d yyyy")),
                .init(title: "Runtime:", detail: getRuntime()),
            ]
        }

    var body: some View {
        VStack {
            ImageLoaderView(imageLoader: ImageLoaderCache.sharedInstance.loaderFor(path: posterPath, size: .original))
                .frame(width: imageWidth, height: imageWidth * 8/11)
            ExpandableTextView(title: episode.title ?? "", text: "\(episode.overview ?? "")", imagePath: posterPath, font: .body, color: .white)
            ForEach(details, id: \.self) { detail in
                DetailsLabel(title: detail.title, detail: detail.detail)
            }
            if guestStars.count > 0 {
                DetailCategoryRow(categoryTitle: "Guest Stars") {
                    ForEach(self.guestStars) { cast in
                        NavigationLink(destination: PersonDetailsView(personDetails: cast.person)) {
                            CastCellView(person: cast)
                        }
                    }
                }
            }
        }.padding(.bottom, 8)
    }
}

//#if DEBUG
//struct SeasonDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        SeasonDetailView(showId: 1416, seasonId: 1).environmentObject(sampleStore)
//    }
//}
//#endif
