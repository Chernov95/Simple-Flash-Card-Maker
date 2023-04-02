//
//  CreateDeckView.swift
//  Flash Card Creator
//
//  Created by Filip Cernov on 06/03/2023.
//  Copyright © 2023 Filip Cernov. All rights reserved.
//

import SwiftUI

struct CreateDeckView: View {
    @State private var deckName = ""
    var body: some View {
        VStack {
            Spacer()
           CustomTextField()
            VStack {
                Button("Create") {
                    createDeck()
                }
                .frame(width: 270, height: 50)
                .border(Color.blue)
                .ignoresSafeArea(.keyboard)
                Button("Cancel", role: .destructive) {
                    cancelDeckCreation()
                }
                .frame(width: 270, height: 50)
                .border(Color.red)
            }
            Spacer()
            Spacer()
            Spacer()
            Spacer()
        }
    }
    
    func createDeck() {
        
    }
    func cancelDeckCreation() {
        
    }
}

struct CreateDeckView_Previews: PreviewProvider {
    static var previews: some View {
        CreateDeckView()
    }
}
