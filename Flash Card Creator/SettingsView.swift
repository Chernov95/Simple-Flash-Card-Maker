//
//  SettingsView.swift
//  Flash Card Creator
//
//  Created by Filip Cernov on 18/02/2023.
//  Copyright © 2023 Filip Cernov. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    
    @State private var darkModeIsOn = false
    @State private var shuffleDeckIsOn = false
    
    var body: some View {
        Form {
            Section {
                HStack {
                    Image("ModeIcon")
                        .resizable()
                        .frame(width: 40, height: 40)
                    Text("Dark Mode")
                        .modifier(SettingsTitle())
                    Toggle("", isOn: $darkModeIsOn)
                }
                HStack {
                    Image("LanguageIcon")
                        .resizable()
                        .frame(width: 40, height: 40)
                    Text("Language")
                        .modifier(SettingsTitle())
                    Spacer()
                    Text("English")
                    Image(systemName: "chevron.right")
                }
                HStack {
                    Image("ShuffleIcon")
                        .resizable()
                        .frame(width: 40, height: 40)
                    Text("Shuffle Deck")
                        .modifier(SettingsTitle())
                    Toggle("", isOn: $shuffleDeckIsOn)
                }
            }
            Section {
                HStack {
                    Image("RateTheAppIcon")
                        .resizable()
                        .frame(width: 40, height: 40)
                    Text("Rate the app")
                        .modifier(SettingsTitle())
                }
                HStack {
                    Image("SendUsFeedbackIcon")
                        .resizable()
                        .frame(width: 40, height: 40)
                    Text("Send us feedback")
                        .modifier(SettingsTitle())
                }
            }
            
        }.background(Color.white)
        .frame(width: UIScreen.main.bounds.width - 80,
               height: UIScreen.main.bounds.height - 250)
        .cornerRadius(8)
    }
}


struct SettingsTitle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(alignment: .center)
            .font(.subheadline)
            .offset(x: 30)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
