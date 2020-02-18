//
//  ExpandableTextView.swift
//  WatchThis_SwiftUI
//
//  Created by Damonique Blake on 2/14/20.
//  Copyright © 2020 Damonique Thomas. All rights reserved.
//

import SwiftUI

struct ExpandableTextView: View {
    @State private var isExpanded = false
    @State private var truncated: Bool = false
    
    let title: String
    let text: String
    var imagePath: String?
    var font: Font = .headline
    var color: Color = .white
    var lineLimit: Int = 5
    
    private var showExpandButton: Bool {
        return !text.isEmpty
    }
    
    private func determineTruncation(_ geometry: GeometryProxy, with font: Font) {
        let total = self.text.boundingRect(
            with: CGSize(
                width: geometry.size.width,
                height: .greatestFiniteMagnitude
            ),
            options: .usesLineFragmentOrigin,
            attributes: [.font: UIFont.systemFont(ofSize: 17)],
            context: nil
        )
        
        if total.size.height > geometry.size.height {
            self.truncated = true
        }
    }
    
    var body: some View {
        VStack {
                VStack {
                    Text(text)
                        .font(font)
                        .foregroundColor(color)
                        .multilineTextAlignment(.leading)
                        .lineLimit(lineLimit)
                        .background(GeometryReader { geometry in
                            Color.clear.onAppear {
                                self.determineTruncation(geometry, with: self.font)
                            }
                        })
                    HStack {
                        Spacer()
                        if truncated {
                            Button(action: {self.isExpanded.toggle()}) {
                                Text("Show More")
                            }
                        }
                    }
                    .padding(.top, 8)
                    .padding(.trailing, 16)
                }
        }.sheet(isPresented: $isExpanded) {
            ZStack {
                BlurredBackground(image: nil, imagePath: self.imagePath)
                VStack {
                    HStack {
                        Text(self.title)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.orange)
                            .lineLimit(1)
                        Spacer()
                        Button(action: {self.isExpanded.toggle()}) {
                            Image(systemName: "xmark")
                                .font(.title)
                                .foregroundColor(self.color)
                        }
                    }.padding(.horizontal)
                        .padding(.top)
                    ScrollView(.vertical) {
                        Text(self.text)
                            .font(self.font)
                            .foregroundColor(self.color)
                            .multilineTextAlignment(.leading)
                            .padding()
                    }
                }.padding(.vertical, 44)
            }.background(Color.black)
            .edgesIgnoringSafeArea(.all)
        }
    }
}

struct ExpandableTextView_Previews: PreviewProvider {
    static let longText = "The first season of the American television medical drama Grey's Anatomy, began airing in the United States on the American Broadcasting Company on March 27, 2005 and concluded on May 22, 2005. The first season introduces the main character, Meredith Grey, as she enrolls in Seattle Grace Hospital's internship program and faces unexpected challenges and surprises. Season one had nine series regulars, six of whom have been part of the main cast ever since. The season initially served as a mid-season replacement for the legal drama Boston Legal, airing in the Sunday night time slot at 10:00, after Desperate Housewives. Although no clip shows have been produced for this season, the events that occur are recapped in \"Straight to Heart\", a clip-show which aired one week before the winter holiday hiatus of the second season ended. The season was officially released on DVD as two-disc Region 1 box set under the title of Grey's Anatomy: Season One on February 14, 2006 by Buena Vista Home Entertainment.\n\nThe season's reviews and critiques were generally positive, and the series received several awards and nominations for the cast and crew. The first five episodes of the second season were conceived, written and shot to air as the final five episodes of the first season, but aired during the 2005-2006 season due to the high number of viewers that watched \"Who's Zoomin' Who?\", the season's highest-rated episode with 22.22 million viewers tuning in."
    static let shortText = "The first season of the American television medical drama Grey's Anatomy, began airing in the United States on the American Broadcasting Company on March 27, 2005 and concluded on May 22, 2005."
    
    static var previews: some View {
        ExpandableTextView(title: "Grey's Anatomy", text: longText, color: .white).background(Color.black)
    }
}
