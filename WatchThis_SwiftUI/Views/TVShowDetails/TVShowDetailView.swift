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

        if let path = showDetail.poster_path {
            imagePath = path
        }
        if let backgroundPath = showDetail.backdrop_path {
            backgroundImagePath = backgroundPath
        }
    }
    
    private var cast: [Cast] {
        return store.state.tvShowState.tvShowCast[showDetail.id] ?? []
    }
    private var similarShows: [TVShowDetails] {
        return store.state.tvShowState.similarShows[showDetail.id] ?? []
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
        store.dispatch(action: TVShowActions.FetchShowCast(id: showDetail.id))
        store.dispatch(action: TVShowActions.FetchSimilarTVShows(id: showDetail.id))
    }
        
    var body: some View {
        ZStack {
            BlurredBackground(image: nil, imagePath: imagePath)
            
            VStack {
                TVDetailHeader(showDetail: showDetail, isFavorite: $isFavorite)
                HStack {
                    DetailTabButton(selectedTab: $selectedTab, text: "Overview", buttonIndex: 0)
                    DetailTabButton(selectedTab: $selectedTab, text: "Cast", buttonIndex: 1)
                    DetailTabButton(selectedTab: $selectedTab, text: "Seasons", buttonIndex: 2)
                    DetailTabButton(selectedTab: $selectedTab, text: "Similar", buttonIndex: 3)
                }.padding(.top, CGFloat(16))
                ZStack {
                    if selectedTab == 0 {
                        ShowOverviewDetailView(showDetail: showDetail)
                    }
                    if selectedTab == 1 {
                        GridView(cast, columns: 3) { CastCellView(person: $0) }
                    }
                    if selectedTab == 2 {
                        GridView(seasons, columns: 2) { SeasonCellView(season: $0) }
                    }
                    if selectedTab == 3 {
                        GridView(similarShows, columns: 3) { show in
                            NavigationLink(destination: TVShowDetailView(showDetail: show, fetchDetails: true)) {
                                ShowCell(tvShow: show, height: CGFloat(125))
                            }
                        }
                    }
                    
                }
                .frame(height: UIScreen.main.bounds.height - 550)
                Spacer()
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
                ImageLoaderView(imageLoader: ImageLoaderCache.sharedInstance().loaderFor(path: showDetail.backdrop_path,
                                                                                         size: .original), contentMode: .fill)
                .frame(width: screenWidth, height: backgroundImageHeight, alignment: .center)
                Spacer()
            }
            VStack {
                HStack {
                    ImageLoaderView(imageLoader: ImageLoaderCache.sharedInstance().loaderFor(path: showDetail.poster_path,
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
        if let runtime = updatedShowDetail.episode_run_time?.first {
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
        ScrollView(.vertical) {
            VStack(alignment: .leading, spacing: 4) {
                if updatedShowDetail.overview != nil {
                    Text(updatedShowDetail.overview!)
                        .font(.body)
                        .foregroundColor(.white)
                }
                DetailsLabel(title: "Airs:", detail: updatedShowDetail.last_air_date)
                DetailsLabel(title: "First Air Date:", detail: updatedShowDetail.first_air_date)
                DetailsLabel(title: "Runtime:", detail:  getRuntime())
                DetailsLabel(title: "Genres:", detail: getGenreList())
                Spacer()
            }
            .padding(8)
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
