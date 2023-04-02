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
    @State private var selectedLanguage = "🇺🇸English"
    let languages = ["🇺🇸English", "🇨🇳Chinese", "🇫🇷French", "🇺🇦Ukrainian"]
    
    var body: some View {
        GeometryReader { geometry in
            Form {
                Section {
                    HStack {
                        Image("ModeIcon")
                            .settingsIconModifier()
                        ZStack {
                            Toggle(isOn: $darkModeIsOn) {
                               
                            }
                            Text("Dark mode")
                                .offset(x: -8)
                        }
                    }
                    HStack {
                        Image("LanguageIcon")
                            .settingsIconModifier()
                        ZStack {
                            Picker("", selection: $selectedLanguage) {
                                ForEach(languages, id: \.self) {
                                    Text($0)
                                }
                                
                            }
                            .offset(x: 15)
                            Text("Language")
                                .offset(x: -8)
                        }
                    }
                    .frame(maxHeight: 10)
                    HStack {
                        Image("ShuffleIcon")
                            .settingsIconModifier()
                        ZStack {
                            Toggle(isOn: $shuffleDeckIsOn) {
                                
                            }
                            Text("Shuffle deck")
                                .offset(x: -8)
                        }
                    }
                }
                Section {
                    HStack {
                        Image("RateTheAppIcon")
                            .settingsIconModifier()
                        Spacer()
                        Text("Rate the app")
                        Spacer()
                    }
                    HStack {
                        Image("SendUsFeedbackIcon")
                            .settingsIconModifier()
                        Spacer()
                        Text("Send us feedback")
                        Spacer()

                    }
                }
                
            }
            .background(Color.white)
            .frame(height: geometry.size.height * 0.6)
            .cornerRadius(8)
        }
        .padding(.horizontal, 10)
    }
}

extension Image {
    func settingsIconModifier() -> some View {
        self
            .resizable()
            .frame(width: 35, height: 35)
   }
}

struct SettingsTitle: ViewModifier {
    func body(content: Content) -> some View {
        content
//            .frame(alignment: .center)
//            .font(.subheadline)
//            .offset(x: 30)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
