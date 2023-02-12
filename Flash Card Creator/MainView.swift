//
//  MainView.swift
//  Flash Card Creator
//
//  Created by Filip Cernov on 12/02/2023.
//  Copyright © 2023 Filip Cernov. All rights reserved.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Button(action: {
                    createDeckButtonPressed()
                }, label: {
                    Image("CreateDeckEnglish")
                })
                HStack {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                        .padding(.leading)
                    Text("My Decks :")
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                Divider()
            }
            // Navigation bar styling
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("Decks")
                            .foregroundColor(.white)
                            .fontWeight(.heavy)
                    }
                    ToolbarItem {
                        Button {
                            settingsButtonPressed()
                        } label: {
                            Image("SettingsLightMode")
                        }
                    }
                }
                .toolbarBackground(Color(hex: "54B4F2"), for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
        }
    }
    
    private func createDeckButtonPressed() {
        print("Create deck button pressed")
    }
    
    private func settingsButtonPressed() {
        print("Settings button pressed")
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
