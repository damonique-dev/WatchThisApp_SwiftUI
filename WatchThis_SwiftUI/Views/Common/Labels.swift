//
//  Labels.swift
//  WatchThis_SwiftUI
//
//  Created by Damonique Thomas on 9/1/19.
//  Copyright © 2019 Damonique Thomas. All rights reserved.
//

import SwiftUI

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
            Spacer()
        }
    }
}
