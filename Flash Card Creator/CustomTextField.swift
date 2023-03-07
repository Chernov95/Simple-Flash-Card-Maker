//
//  CustomTextField.swift
//  Flash Card Creator
//
//  Created by Filip Cernov on 06/03/2023.
//  Copyright © 2023 Filip Cernov. All rights reserved.
//

import SwiftUI

struct CustomTextField: View {
    @State private var deckName = ""
    @State private var startAnimation = false
    var body: some View {
        VStack {
            ZStack {
                Text("Deck Name")
                    .foregroundColor(.gray)
                    .offset(x: -80, y: startAnimation ? -30 : 0)
                    .animation(.default, value: startAnimation)
                TextField("", text: $deckName, onEditingChanged: { focused in
                    print(focused ? "focused" : "unfocused")
                        startAnimation.toggle()
                })
                    .frame(width: 250, height: 50)
            }
            Divider()
                .frame(width: 250, height: 2)
                .overlay(startAnimation ? .green : .secondary)
                .offset(y: -10)
                .animation(
                    .easeInOut(duration: 0.5)
                    .delay(0.025),
                           value: startAnimation)
        }
    }
}

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif

struct CustomTextField_Previews: PreviewProvider {
    static var previews: some View {
        CustomTextField()
    }
}
