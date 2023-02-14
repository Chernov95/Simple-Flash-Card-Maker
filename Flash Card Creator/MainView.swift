//
//  MainView.swift
//  Flash Card Creator
//
//  Created by Filip Cernov on 12/02/2023.
//  Copyright © 2023 Filip Cernov. All rights reserved.
//

import SwiftUI

//"English", "Japanese", "Latin", "Anatomy", "Grammar", "Art", "Literature", "Law", "Programming"
struct MainView: View {
    
    @State private var decks = ["English", "Japanese", "Latin", "Anatomy", "Grammar", "Art", "Literature", "Law", "Programming"]
    
    @State private var searchDeck = ""
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                    Button(action: {
                        createDeckButtonPressed()
                    }, label: {
                        Image("CreateDeckEnglish")
                    })
                    .frame(width: 300, height: 130)
                    List {
                        Section {
                            ForEach(decks, id: \.self) {
                                DeckCell(deckName: $0)
                            }
                            .onDelete { indexSet in
                                decks.remove(atOffsets: indexSet)
                            }
                            .onMove { source, destination in
                                decks.move(fromOffsets: source, toOffset: destination)
                            }
                        } header: {
                            HStack() {
                                Image(systemName: "star.fill")
                                    .foregroundColor(.yellow)
                                    .padding(.leading)
                                Text("My Decks :")
                                    .foregroundColor(.gray)
                            }
                            .offset(x: -18)
                        }
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                    .offset(x: 0, y: 100)
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
            
            // Adds searcbar
                .searchable(text: $searchDeck)
                .onChange(of: searchDeck) { searchText in
                    if !searchText.isEmpty {
                        decks = decks.filter { $0.contains(searchText) }
                    } else {
                        decks = decks 
                    }
                }
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
