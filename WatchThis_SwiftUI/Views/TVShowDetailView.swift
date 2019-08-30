//
//  ContentView.swift
//  WatchThis_SwiftUI
//
//  Created by Damonique Thomas on 8/7/19.
//  Copyright © 2019 Damonique Thomas. All rights reserved.
//

import SwiftUI

struct TVShowDetailView: View {
    let showDetail: TVShowDetails
    init(showDetail: TVShowDetails) {
        self.showDetail = showDetail
        
        if let showCast = showDetail.cast {
            cast = showCast
        }
        if let showSeasons = showDetail.seasons {
            seasons = showSeasons
        }
        if let backgroundPath = showDetail.backdrop_path {
            backgroundImagePath = backgroundPath
        }
    }
    
    private var cast = testPeople
    private var seasons = testSeasons
    private var backgroundImagePath = "testTvShowImage"
    
    @State private var isFavorite = true
    @State private var selectedTab = 0
        
    var body: some View {
        ZStack {
            BlurredBackground(imagePath: backgroundImagePath)
            
            VStack {
                TVDetailHeader(showDetail: showDetail, isFavorite: $isFavorite)
                HStack {
                    DetailTabButton(selectedTab: $selectedTab, text: "Overview", buttonIndex: 0)
                    DetailTabButton(selectedTab: $selectedTab, text: "Cast", buttonIndex: 1)
                    DetailTabButton(selectedTab: $selectedTab, text: "Seasons", buttonIndex: 2)
                    DetailTabButton(selectedTab: $selectedTab, text: "Similar", buttonIndex: 3)
                }.padding(.top, 16)
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
                    
                }.frame(height: UIScreen.main.bounds.height - 500)
                Spacer()
            }
            VStack(alignment: .leading) {
                HStack {
                    FavoriteButton(isFavorite: $isFavorite)
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
    }
}

struct TVDetailHeader: View {
    let showDetail: TVShowDetails
    @Binding var isFavorite: Bool
    
    private let screenWidth = UIScreen.main.bounds.width
    private let screenHeight = UIScreen.main.bounds.height
    private let backgroundImageHeight = UIScreen.main.bounds.height/3
    private let showImageWidth = UIScreen.main.bounds.width/3
    private let showImageHeight = (UIScreen.main.bounds.width/3) * 11/8
    private let showImageTop = (UIScreen.main.bounds.height/3) - (((UIScreen.main.bounds.width/3) * 11/8)/2)
    
    var body: some View {
        ZStack {
            VStack {
                Image("testTvShowBackdrop")
                    .resizable()
                    .frame(width: screenWidth, height: backgroundImageHeight, alignment: .center)
                    .aspectRatio(contentMode: .fill)
                Spacer()
            }
            VStack {
                HStack {
                    Image("testTvShowImage")
                        .resizable()
                        .frame(width: showImageWidth, height: showImageHeight, alignment: .center)
                        .aspectRatio(contentMode: .fill)
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

struct DetailTabButton: View {
    @Binding var selectedTab: Int
    var text = "Button Text"
    var buttonIndex = 0
    
    let buttonWidth = (UIScreen.main.bounds.width - 60)/4
    
    var body: some View {
        Button(action: {self.selectedTab = self.buttonIndex}) {
            Text(text)
                .font(Font.system(.body, design: .rounded))
                .fontWeight(.bold)
                .frame(width: buttonWidth, height:30)
                .foregroundColor(Color.white)
        }
        .background(RoundedRectangle(cornerRadius: 10).foregroundColor(selectedTab == buttonIndex ? .green : .orange))
        
    }
}

struct DetailsLabel: View {
    let title: String
    let detail: String?
    var body: some View {
        HStack {
            Text(title)
                .font(Font.system(.headline, design: .rounded))
                .fontWeight(.bold)
                .foregroundColor(.green)
                .multilineTextAlignment(.leading)
            Text("\(detail ?? "")")
                .font(Font.system(.subheadline, design: .rounded))
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .multilineTextAlignment(.leading)
        }
    }
}

struct ShowOverviewDetailView: View {
    let showDetail: TVShowDetails
    
    func getRuntime() -> String {
        if let runtime = showDetail.episode_run_time?.first {
            return "\(runtime) minutes"
        }
        return ""
    }
    
    func getGenreList() -> String {
        if let genres = showDetail.genres {
            return genres.map({$0.name!}).joined(separator: ", ")
        }
        return ""
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("\(showDetail.overview!)")
                .font(Font.system(.body, design: .rounded))
                .foregroundColor(.white)
                .lineLimit(nil)
            DetailsLabel(title: "Airs:", detail: showDetail.last_air_date)
            DetailsLabel(title: "First Air Date:", detail: showDetail.first_air_date)
            DetailsLabel(title: "Runtime:", detail:  getRuntime())
            DetailsLabel(title: "Genres:", detail: getGenreList())
            Spacer()
        }
        .padding(8)
    }
}

struct CastCellView: View {
    let person: Person
    
    init(person: Person) {
        self.person = person
        if let path = person.profile_path {
            imagePath = path
        }
        if let character = person.character {
           characterName = character
        }
        if let name = person.name {
           personName = name
        }
    }
    
    private var imagePath = "testTvShowImage"
    private var personName = ""
    private var characterName = ""
    
    var body: some View {
        ZStack {
            VStack {
                Image(imagePath)
                    .resizable()
                    .frame(width: 90, height: 90, alignment: .center)
                    .aspectRatio(contentMode: .fill)
                .clipShape(Circle())
                Text(personName)
                    .font(Font.system(.callout, design: .rounded))
                    .fontWeight(.bold)
                    .foregroundColor(.orange)
                Text(characterName)
                    .font(Font.system(.caption, design: .rounded))
                    .foregroundColor(.white)
            }
        }.frame(width: UIScreen.main.bounds.width/3 - 20, height: UIScreen.main.bounds.width/3 - 5)
            .cornerRadius(10)
    }
}

struct SeasonCellView: View {
    let season: Season
    init(season: Season) {
        self.season = season
        if let name = season.name {
            seasonName = name
        }
        if let path = season.poster_path {
            imagePath = path
        }
        if let count = season.episode_count {
            episodeCount = "\(count) Episodes"
        }
    }
    
    private var imagePath = "testTvShowImage"
    private var seasonName = ""
    private var episodeCount = ""
    
    var body: some View {
        ZStack {
            Color("LightGrey")
            HStack {
                Image(imagePath)
                    .resizable()
                    .frame(width: 60 * 8/11, height: 60, alignment: .center)
                    .aspectRatio(contentMode: .fill)
                VStack(alignment: .leading) {
                    Text(seasonName)
                        .font(Font.system(.callout, design: .rounded))
                        .fontWeight(.bold)
                        .foregroundColor(.orange)
                    Text(episodeCount)
                    .font(Font.system(.caption, design: .rounded))
                    .foregroundColor(.white)
                }.frame(width: UIScreen.main.bounds.width/2 - 120)
                Spacer()
            }.padding(.leading, 8)
        }.frame(width: UIScreen.main.bounds.width/2 - 20, height: UIScreen.main.bounds.width/5)
            .cornerRadius(10)
    }
}

struct FavoriteButton: View {
    @Binding var isFavorite: Bool
    
    var body: some View {
        Button(action: { self.isFavorite.toggle() } ) {
            ZStack {
                Circle().foregroundColor(.orange)
                Image(systemName: isFavorite ? "star.fill" : "star")
                    .imageScale(.large)
                    .foregroundColor(.white)
            }
        }.frame(width: 30, height: 30)
    }
}

#if DEBUG
struct TVShowDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TVShowDetailView(showDetail: testTVShowDetail)
    }
}
#endif
