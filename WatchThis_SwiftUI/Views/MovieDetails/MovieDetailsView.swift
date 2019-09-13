//
//  MovieDetailsView.swift
//  WatchThis_SwiftUI
//
//  Created by Damonique Thomas on 9/12/19.
//  Copyright © 2019 Damonique Thomas. All rights reserved.
//

import SwiftUI

struct MovieDetailsView: View {
    @EnvironmentObject var store: Store<AppState>
    @State private var isFavorite = false
    
    let movieDetails: MovieDetails
    let fetchDetails: Bool
    
    init(movieDetails: MovieDetails, fetchDetails: Bool = false) {
        self.movieDetails = movieDetails
        self.fetchDetails = fetchDetails
    }
    
    private func fetchMovieDetails() {
        isFavorite = store.state.movieState.favoriteMovies.contains(movieDetails.id)
        if fetchDetails {
            store.dispatch(action: MovieActions.FetchMovieDetails(id: movieDetails.id))
        }
    }
    
    private var movieRuntime: String {
        if let runtime = movieDetails.runtime {
            return "\(runtime)"
        }
        return ""
    }
    
    private var cast: [Cast] {
        return store.state.movieState.movieDetails[movieDetails.id]?.credits?.cast ?? [Cast]()
    }
    
    private var similarMovies: [MovieDetails] {
        return store.state.movieState.movieDetails[movieDetails.id]?.similar?.results ?? [MovieDetails]()
    }
    
    private var movieRevenue: String {
        if let revenue = movieDetails.revenue {
            return formatLargeCurrency(currency: revenue)
        }
        return ""
    }
    
    var body: some View {
        ZStack {
            BlurredBackground(image: nil, imagePath: movieDetails.posterPath)
            VStack {
                MovieDetailHeader(isFavorite: $isFavorite, movieDetail: movieDetails)
                ScrollView(.vertical) {
                    Text("\(movieDetails.overview ?? "")")
                        .font(.body)
                        .foregroundColor(.white)
                        .fixedSize(horizontal: false, vertical: true)
                    VStack(alignment: .leading) {
                        DetailsLabel(title: "Release Date:", detail: movieDetails.releaseDate)
                        DetailsLabel(title: "Runtime:", detail: movieRuntime)
                        DetailsLabel(title: "Revenue:", detail: movieRevenue)
                    }.padding(.top, 8)
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
                    if similarMovies.count > 0 {
                        VStack(alignment: .leading) {
                            Text("Similar Movies")
                                .font(.headline)
                                .foregroundColor(.white)
                                .multilineTextAlignment(.leading)
                            ScrollView(.horizontal) {
                                HStack(spacing: 16.0) {
                                    ForEach(similarMovies) { movie in
                                        NavigationLink(destination: MovieDetailsView(movieDetails: movie, fetchDetails: true)) {
                                            RoundedImageCell(item: movie, height: CGFloat(125))
                                        }
                                    }
                                }
                            }
                        }.padding(.top, 8)
                    }
                }.padding(8)
            }
            VStack(alignment: .leading) {
                HStack {
                    FavoriteButton(isFavorite: $isFavorite, action: {
                        self.isFavorite.toggle()
                        if self.isFavorite {
                            self.store.dispatch(action: MovieActions.AddMovieToFavorites(movieId: self.movieDetails.id))
                        } else {
                            self.store.dispatch(action: MovieActions.RemoveMovieFromFavorites(movieId: self.movieDetails.id))
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
        .navigationBarTitle(Text("\(movieDetails.title)"))
        .onAppear() {
            self.fetchMovieDetails()
        }
    }
}

struct MovieDetailHeader: View {
    @EnvironmentObject var store: Store<AppState>
    @Binding var isFavorite: Bool
    let movieDetail: MovieDetails
    
    private let screenWidth = UIScreen.main.bounds.width
    private let screenHeight = UIScreen.main.bounds.height
    private let backgroundImageHeight = UIScreen.main.bounds.height/3
    private let showImageWidth = UIScreen.main.bounds.width/3
    private let showImageHeight = (UIScreen.main.bounds.width/3) * 11/8
    private let showImageTop = (UIScreen.main.bounds.height/3) - (((UIScreen.main.bounds.width/3) * 11/8)/2)
    
    var body: some View {
        ZStack {
            VStack {
                ImageLoaderView(imageLoader: ImageLoaderCache.sharedInstance().loaderFor(path: movieDetail.backdropPath,
                                                                                         size: .original), contentMode: .fill)
                .frame(width: screenWidth, height: backgroundImageHeight, alignment: .center)
                Spacer()
            }
            VStack {
                HStack {
                    ImageLoaderView(imageLoader: ImageLoaderCache.sharedInstance().loaderFor(path: movieDetail.posterPath,
                                                                                             size: .original), contentMode: .fill)
                    .frame(width: showImageWidth, height: showImageHeight, alignment: .center)
                }
                    
                HStack {
                    Text("\(movieDetail.title)")
                        .font(Font.system(.title, design: .rounded))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
            }.padding(.top, showImageTop)
        }
    }
}

#if DEBUG
struct MovieDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        MovieDetailsView(movieDetails: testMovieDetails, fetchDetails: false).environmentObject(sampleStore)
    }
}
#endif
