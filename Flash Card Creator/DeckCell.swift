//
//  DeckCell.swift
//  Flash Card Creator
//
//  Created by Filip Cernov on 13/02/2023.
//  Copyright © 2023 Filip Cernov. All rights reserved.
//

import SwiftUI

struct DeckCell: View {
    @State var deckName: String
    var body: some View {
        ZStack {
            Color(hex: "54B4F2")
                .cornerRadius(8)
            HStack {
                    Text(deckName)
                        .padding(.leading)
                        .foregroundColor(.white)
                        .fontWeight(.heavy)
                    Spacer()
                    VStack {
                        Button {
                            editDeckNameButtonPressed()
                        } label: {
                            Image("Edit")
                                .padding(.trailing)
                                .padding(.top)
                        }
                        Spacer()
                    }
            }
        }
        .frame(alignment: .center)
        .listRowSeparator(.hidden)
        .lineLimit(2)
    }
    
    private func editDeckNameButtonPressed() {
        print("Edit button pressed")
    }
    
    private func deckHasBeenSelected() {
        print("Deck has been selected")
    }
}

struct DeckCell_Previews: PreviewProvider {
    static var previews: some View {
        DeckCell(deckName: "Japanese")
            .frame(width: 320, height: 60)
    }
}


//struct DeckCell: View {
//    @State var deckName: String
//    var body: some View {
//        ZStack {
//            Color(hex: "54B4F2")
//                .cornerRadius(8)
//            HStack {
//                Button {
//                    deckHasBeenSelected()
//                } label: {
//                    Text(deckName)
//                        .padding(.leading)
//                        .foregroundColor(.white)
//                        .fontWeight(.heavy)
//                    Spacer()
//                    VStack {
//                        Button {
//                            editDeckNameButtonPressed()
//                        } label: {
//                            Image("Edit")
//                                .padding(.trailing)
//                                .padding(.top)
//                        }
//                        Spacer()
//                    }
//                }
//            }
//        }
//        .frame(width: 320, height: 60)
//    }
//
//    private func editDeckNameButtonPressed() {
//        print("Edit button pressed")
//    }
//
//    private func deckHasBeenSelected() {
//        print("Deck has been selected")
//    }
//}
//
//struct DeckCell_Previews: PreviewProvider {
//    static var previews: some View {
//        DeckCell(deckName: "Japanese")
//    }
//}




//                List(decks, id: \.self) {
//                    DeckCell(deckName: $0)
//                        .listRowSeparator(.hidden)
//                }
//
//                .scrollContentBackground(.hidden)
