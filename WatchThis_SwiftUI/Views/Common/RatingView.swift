//
//  RatingView.swift
//  WatchThis_SwiftUI
//
//  Created by Damonique Blake on 10/3/19.
//  Copyright © 2019 Damonique Thomas. All rights reserved.
//

import SwiftUI

struct RatingView: View {
    @State var ratingProgress: CGFloat = .init(0)
    let rating: Double?
    
    init(rating: Double?) {
        self.rating = rating
    }
    
    private var ratingPercentage: String {
        if let rating = rating {
            return "\(Int(rating*10))%"
        }
        return "NR"
    }
    
    private var progressColor: Color {
        if let rating = rating {
            if rating < 5 {
                return .red
            }
            if rating < 7 {
                return .yellow
            }
            return .green
        }
        return .gray
    }
    
    private var progressBackgroundColor: Color {
        if let rating = rating {
            if rating < 5 {
                return .red
            }
            if rating < 7 {
                return .yellow
            }
            return .green
        }
        return .gray
    }
    
    private let size: CGFloat = 50
    
    private func animate() {
        if let rating = rating {
            ratingProgress = .init(rating / 10.0)
        }
    }
        
    var body: some View {
        ZStack {
            Circle()
                .foregroundColor(.black)
            Circle()
                .stroke(progressBackgroundColor.opacity(0.3), style: StrokeStyle(lineWidth: 5, lineCap: CGLineCap.round))
                .padding(8)
            Circle()
                .trim(from: 0, to: ratingProgress)
                .stroke(progressColor, style: StrokeStyle(lineWidth: 5, lineCap: CGLineCap.round))
                .padding(8)
                .rotationEffect(.degrees(-90))
                .overlay(
                    Text(ratingPercentage).foregroundColor(.white).font(Font.system(.caption, design: .rounded)))
                .onAppear() {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                        self.animate()
                    })
                }
                .animation(Animation.linear(duration: 0.5))
        }.frame(width: size, height: size)
    }
}

struct RatingView_Previews: PreviewProvider {
    static var previews: some View {
        RatingView(rating: 7)
    }
}
