//
//  TextFieldAlert.swift
//  WatchThis_SwiftUI
//
//  Created by Damonique Thomas on 9/16/19.
//  Copyright © 2019 Damonique Thomas. All rights reserved.
//

import SwiftUI

struct TextFieldAlert<Presenting>: View where Presenting: View {
    @Binding var isShowing: Bool
    @State var text = ""
    let presenting: Presenting
    let title: Text
    let doneAction: (_ text: String) -> Void
    
    private let width = UIScreen.main.bounds.width * 0.7

    var body: some View {
        ZStack {
            presenting
                .disabled(isShowing)
            VStack {
                title.padding(.bottom, 8)
                TextField("Custom List Name", text: $text)
                Divider()
                HStack {
                    Spacer()
                    Button(action: {
                        withAnimation {
                            self.isShowing.toggle()
                        }
                    }) {
                        Text("Dismiss")
                    }
                    Spacer()
                    Divider().foregroundColor(.white)
                    Spacer()
                    Button(action: {
                        withAnimation {
                            self.isShowing.toggle()
                            self.doneAction(self.text)
                        }
                    }) {
                        Text("Create")
                    }.disabled(text.isEmpty)
                    Spacer()
                }
            }
            .padding()
            .frame(width: width, height: width * 5/11)
            .background(Color(.black))
            .shadow(radius: 1)
            .cornerRadius(5)
            .opacity(isShowing ? 1 : 0)
        }
    }

}

extension View {
    func textFieldAlert(isShowing: Binding<Bool>,
                        title: Text,
                        doneAction: @escaping (_ text: String) -> Void) -> some View {
        TextFieldAlert(isShowing: isShowing,
                       presenting: self,
                       title: title,
            doneAction: doneAction)
    }

}
