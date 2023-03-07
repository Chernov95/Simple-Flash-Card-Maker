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
           CustomTextField()
            Button("OK") {
                createDeck()
            }
            .padding()
            
            Button("Cancel", role: .destructive) {
                cancelDeckCreation()
            }
            .padding()
            
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
