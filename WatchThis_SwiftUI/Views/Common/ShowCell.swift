//
//  ShowCell.swift
//  WatchThis_SwiftUI
//
//  Created by Damonique Thomas on 8/25/19.
//  Copyright © 2019 Damonique Thomas. All rights reserved.
//

import SwiftUI

struct ShowCell: View {
    @EnvironmentObject var store: Store<AppState>
    let tvShow: TVShowDetails
    let height: CGFloat
    
    init(tvShow: TVShowDetails, height: CGFloat) {
        self.tvShow = tvShow
        self.height = height
        showName = tvShow.name
        if let path = tvShow.poster_path {
            imagePath = path
        }
        
    }
    
    private var showName: String
    private var imagePath = ""
    private var image: UIImage? {
        if let data = store.state.images[imagePath]?[.original] {
            return UIImage(data: data)!
        }
        return nil
    }
    
    private func fetchImages() {
        if store.state.images[imagePath]?[.original] == nil {
            store.dispatch(action: AppActions.FetchImage(urlPath: imagePath, size: .original))
        }
    }
    
    var body: some View {
        ZStack {
            Text(showName)
                .font(Font.system(.headline, design: .rounded))
                .fontWeight(.semibold)
                .frame(width: height * 8/11, height: height)
                .foregroundColor(.white)
                .lineLimit(nil)
            if image != nil {
                Image(uiImage: image!)
                    .resizable()
                    .renderingMode(.original)
                    .frame(width: height * 8/11, height: height)
                    .cornerRadius(15)
            } else {
                RoundedRectangle(cornerRadius: 15)
                    .frame(width: height * 8/11, height: height)
                    .foregroundColor(Color.black.opacity(0))
                    .border(Color.white)
            }
        }
    }
}

#if DEBUG
struct ShowCell_Previews: PreviewProvider {
    static var previews: some View {
        ShowCell(tvShow: testTVShowDetail, height: CGFloat(200)).environmentObject(sampleStore)
    }
}
#endif
