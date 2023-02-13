//
//  MainView.swift
//  Flash Card Creator
//
//  Created by Filip Cernov on 12/02/2023.
//  Copyright © 2023 Filip Cernov. All rights reserved.
//

import SwiftUI

struct MainView: View {
    
    @State private var decks = ["English", "Japanese", "Latin", "Anatomy", "Grammar", "Art", "Literature", "Law", "Programming"]
    
    var body: some View {
        NavigationStack {
            VStack {
                Button(action: {
                    createDeckButtonPressed()
                }, label: {
                    Image("CreateDeckEnglish")
                })
                .frame(width: 300, height: 150)
                HStack {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                        .padding(.leading)
                    Text("My Decks :")
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                Divider()
                List {
                    ForEach(decks, id: \.self) {
                        DeckCell(deckName: $0)
                    }
                    .onDelete { indexSet in
                        decks.remove(atOffsets: indexSet)
                    }
                    .onMove { source, destination in
                        decks.move(fromOffsets: source, toOffset: destination)
                    }
                }
                .scrollContentBackground(.hidden)
                .listStyle(.plain)
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
        withAnimation {
            decks.insert("SwiftUI\(UUID())", at: 0)
        }
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
