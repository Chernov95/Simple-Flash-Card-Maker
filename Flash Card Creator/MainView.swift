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
    @State private var shouldShowSettingsView: Bool = false
    
    @State private var searchDeck = ""
    
    var body: some View {
        ZStack {
            ZStack {
                NavigationStack {
                    VStack {
                        Button(action: {
                            createDeckButtonPressed()
                        }, label: {
                            Image("CreateDeckEnglish")
                        })
                        .frame(width: 300, height: 130)
                        .offset(y: 15)
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
                                .listRowSeparator(.hidden)
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
                                withAnimation {
                                    shouldShowSettingsView.toggle()
                                }
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
            }.opacity(self.shouldShowSettingsView ? 0.5 : 1)
            if self.shouldShowSettingsView {
                GeometryReader { _ in
                    VStack {
                        SettingsView()
                            .frame( maxWidth: .infinity, maxHeight: .infinity)
                        Button(action: {
                            withAnimation {
                                self.shouldShowSettingsView.toggle()
                            }
                        }) {
                            Image(systemName: "xmark")
                                .resizable()
                                .frame(width: 15, height: 15)
                                .foregroundColor(.black)
                                .padding(20)
                        }
                        .background(Color.white)
                        .clipShape(Circle())
                        .padding(.top, 25)
                    }
                }.background(Color.black.opacity(0.5).edgesIgnoringSafeArea(.all))
            }
        }
    }
    
    private func createDeckButtonPressed() {
        print("Create deck button pressed")
        withAnimation {
            decks.insert("SwiftUI\(UUID())", at: 0)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
