//
//  Deck.swift
//  Flash Card Creator
//
//  Created by Filip Cernov on 12/05/2019.
//  Copyright © 2019 Filip Cernov. All rights reserved.
//

import Foundation
import RealmSwift

class Deck : Object {
    
    @objc dynamic var name : String = ""
    @objc dynamic var order = 0
   
    
    var cards = List<Array>()
    
    
}
