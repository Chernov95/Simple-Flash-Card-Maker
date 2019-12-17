//
//  arrayOfDictionaries.swift
//  Flash Card Creator
//
//  Created by Filip Cernov on 16/04/2019.
//  Copyright © 2019 Filip Cernov. All rights reserved.
//

import Foundation
import RealmSwift


class Array : Object {
    
    @objc dynamic var frontalText = ""
    @objc dynamic var dorsalText = ""
    
   
    
    @objc dynamic var nameOfFrontalImage = ""
    @objc dynamic var nameOfDorsalImage = ""
    
    
    //Tick for deleting
    @objc dynamic var tickedToDelete = false
    
    
    //For rearanging cells
    @objc dynamic var order = 0
    
    //For cards
    var parentDeck = LinkingObjects(fromType: Deck.self, property: "cards")
    
    
}
