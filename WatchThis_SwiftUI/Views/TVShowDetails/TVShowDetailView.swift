//
//  ContentView.swift
//  WatchThis_SwiftUI
//
//  Created by Damonique Thomas on 8/7/19.
//  Copyright © 2019 Damonique Thomas. All rights reserved.
//

import SwiftUI

struct TVShowDetailView: View {
    @EnvironmentObject var store: Store<AppState>
    @State private var isFavorite = false
    @State private var selectedTab = 0
    
    let showDetail: TVShowDetails
    let fetchDetails: Bool
    init(showDetail: TVShowDetails, fetchDetails: Bool = false) {
        self.showDetail = showDetail
        self.fetchDetails = fetchDetails

        if let path = showDetail.posterPath {
            imagePath = path
        }
        if let backgroundPath = showDetail.backdropPath {
            backgroundImagePath = backgroundPath
        }
    }
    
    private var cast: [Cast] {
        return store.state.tvShowState.tvShowDetail[showDetail.id]?.credits?.cast ?? []
    }
    private var similarShows: [TVShowDetails] {
        return store.state.tvShowState.tvShowDetail[showDetail.id]?.similar?.results ?? []
    }
    private var seasons: [Season] {
        return store.state.tvShowState.tvShowDetail[showDetail.id]?.seasons ?? []
    }
    
    private var imagePath = ""
    private var backgroundImagePath = ""
    
    private func fetchShowDetails() {
        isFavorite = store.state.tvShowState.favoriteShows.contains(showDetail.id)
        if fetchDetails {
            store.dispatch(action: TVShowActions.FetchTVShowDetails(id: showDetail.id))
        }
    }
        
    var body: some View {
        ZStack {
            BlurredBackground(image: nil, imagePath: imagePath)
            
            VStack {
                TVDetailHeader(showDetail: showDetail, isFavorite: $isFavorite)
                ScrollView(.vertical) {
                    VStack {
                        ShowOverviewDetailView(showDetail: showDetail)
                        if cast.count > 0 {
                            VStack(alignment: .leading) {
                                Text("Cast")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.leading)
                                ScrollView(.horizontal) {
                                    HStack {
                                        ForEach(cast) { cast in
                                            CastCellView(person: cast)
                                        }
                                    }
                                }
                            }.padding(.top, 8)
                        }
                        if seasons.count > 0 {
                            VStack(alignment: .leading) {
                                Text("Seasons")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.leading)
                                ScrollView(.horizontal) {
                                    HStack {
                                        ForEach(seasons) { season in
                                            SeasonCell(season: season)
                                        }
                                    }
                                }.padding(8)
                            }.padding(.top, 8)
                        }
                        if similarShows.count > 0 {
                            VStack(alignment: .leading) {
                                Text("Similar Shows")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.leading)
                                ScrollView(.horizontal) {
                                    HStack(spacing: 16.0) {
                                        ForEach(similarShows) { show in
                                            NavigationLink(destination: TVShowDetailView(showDetail: show, fetchDetails: true)) {
                                                RoundedImageCell(item: show, height: CGFloat(125))
                                            }
                                        }
                                    }
                                }
                            }.padding(.top, 8)
                        }
                    }
                }.padding(8)
            }
            VStack(alignment: .leading) {
                HStack {
                    FavoriteButton(isFavorite: $isFavorite, action: {
                        self.isFavorite.toggle()
                        if self.isFavorite {
                            self.store.dispatch(action: TVShowActions.AddShowToFavorites(showId: self.showDetail.id))
                        } else {
                            self.store.dispatch(action: TVShowActions.RemoveShowFromFavorites(showId: self.showDetail.id))
                        }
                    })
                    Spacer()
                }.padding(.leading, UIScreen.main.bounds.width / 2 - UIScreen.main.bounds.width/6 - 40)
                Spacer()
            }.padding(.top, 310)
            VStack(alignment: .leading) {
                HStack {
                    WatchThisButton(text: "Watch Trailer")
                    Spacer()
                }.padding(.leading, UIScreen.main.bounds.width / 2 + UIScreen.main.bounds.width/6 + 10)
                Spacer()
            }.padding(.top, 310)
        }
        .padding(.vertical, 44)
        .navigationBarTitle(Text("\(showDetail.name)"))
        .onAppear() {
            self.fetchShowDetails()
        }
    }
}

struct TVDetailHeader: View {
    @EnvironmentObject var store: Store<AppState>
    @Binding var isFavorite: Bool
    let showDetail: TVShowDetails
    
    init(showDetail: TVShowDetails, isFavorite: Binding<Bool>) {
        self.showDetail = showDetail
        self._isFavorite = isFavorite
    }
    
    private let screenWidth = UIScreen.main.bounds.width
    private let screenHeight = UIScreen.main.bounds.height
    private let backgroundImageHeight = UIScreen.main.bounds.height/3
    private let showImageWidth = UIScreen.main.bounds.width/3
    private let showImageHeight = (UIScreen.main.bounds.width/3) * 11/8
    private let showImageTop = (UIScreen.main.bounds.height/3) - (((UIScreen.main.bounds.width/3) * 11/8)/2)
    
    var body: some View {
        ZStack {
            VStack {
                ImageLoaderView(imageLoader: ImageLoaderCache.sharedInstance().loaderFor(path: showDetail.backdropPath,
                                                                                         size: .original), contentMode: .fill)
                .frame(width: screenWidth, height: backgroundImageHeight, alignment: .center)
                Spacer()
            }
            VStack {
                HStack {
                    ImageLoaderView(imageLoader: ImageLoaderCache.sharedInstance().loaderFor(path: showDetail.posterPath,
                                                                                             size: .original), contentMode: .fill)
                    .frame(width: showImageWidth, height: showImageHeight, alignment: .center)
                }
                    
                HStack {
                    Text("\(showDetail.name)")
                        .font(Font.system(.title, design: .rounded))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
            }.padding(.top, showImageTop)
        }
    }
}

struct ShowOverviewDetailView: View {
    @EnvironmentObject var store: Store<AppState>
    let showDetail: TVShowDetails
    
    private var updatedShowDetail: TVShowDetails {
        return store.state.tvShowState.tvShowDetail[showDetail.id] ?? showDetail
    }
    
    func getRuntime() -> String {
        if let runtime = updatedShowDetail.episodeRunTime?.first {
            return "\(runtime) minutes"
        }
        return ""
    }
    
    func getGenreList() -> String {
        if let genres = updatedShowDetail.genres {
            return genres.map({$0.name!}).joined(separator: ", ")
        }
        return ""
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            if updatedShowDetail.overview != nil {
                Text(updatedShowDetail.overview!)
                    .font(.body)
                    .foregroundColor(.white)
                    .fixedSize(horizontal: false, vertical: true)
            }
            DetailsLabel(title: "Airs:", detail: updatedShowDetail.lastAirDate)
            DetailsLabel(title: "First Air Date:", detail: updatedShowDetail.firstAirDate)
            DetailsLabel(title: "Runtime:", detail:  getRuntime())
            DetailsLabel(title: "Genres:", detail: getGenreList())
            Spacer()
        }
    }
}

#if DEBUG
struct TVShowDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TVShowDetailView(showDetail: testTVShowDetail).environmentObject(sampleStore)
    }
}
#endif

struct SeasonCell: View {
    let season: Season
    
    var body: some View {
        ZStack {
            Text("\(season.name ?? "")")
                .font(Font.system(.headline, design: .rounded))
                .fontWeight(.semibold)
                .frame(width: 125 * 8/11, height: 125)
                .foregroundColor(.white)
                .lineLimit(nil)
            VStack {
                ImageLoaderView(imageLoader: ImageLoaderCache.sharedInstance().loaderFor(path: season.posterPath,
                                                                                         size: .original))
                    .frame(width: 125 * 8/11, height: 125)
                    .cornerRadius(15)
                Text("\(season.name ?? "")")
                    .font(Font.system(.callout, design: .rounded))
                    .fontWeight(.bold)
                    .foregroundColor(.orange)
                    .lineLimit(2)
                Text("\(season.episodeCount ?? 0) Episodes")
                    .font(Font.system(.caption, design: .rounded))
                    .foregroundColor(.white)
                    .lineLimit(2)
            }
        }
    }
}
