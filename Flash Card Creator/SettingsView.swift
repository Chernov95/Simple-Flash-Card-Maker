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
        Form {
            Section {
                HStack {
                    Image("ModeIcon")
                        .resizable()
                        .frame(width: 35, height: 35)
                    Toggle(isOn: $darkModeIsOn) {
                        Text("Dark mode")
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
                HStack {
                    Image("LanguageIcon")
                        .resizable()
                        .frame(width: 35, height: 35)
                    ZStack {
                        Picker("", selection: $selectedLanguage) {
                            ForEach(languages, id: \.self) {
                                Text($0)
                            }
                        }
                        Text("Language")
                    }
                }
                .frame(maxHeight: 10)
                HStack {
                    Image("ShuffleIcon")
                        .resizable()
                        .frame(width: 35, height: 35)
                    Toggle(isOn: $shuffleDeckIsOn) {
                        Text("Shuffle deck")
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
            }
            Section {
                HStack {
                    Image("RateTheAppIcon")
                        .resizable()
                        .frame(width: 35, height: 35)
                    Spacer()
                    Text("Rate the app")
                    Spacer()
                }
                HStack {
                    Image("SendUsFeedbackIcon")
                        .resizable()
                        .frame(width: 35, height: 35)
                    Spacer()
                    Text("Send us feedback")
                    Spacer()

                }
            }
            
        }
        .background(Color.white)
        .frame(width: UIScreen.main.bounds.width - 30,
               height: UIScreen.main.bounds.height - 600)
        .cornerRadius(8)
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
