//
//  ReusableFunctions.swift
//  Flash Card Creator
//
//  Created by Filip Cernov on 10/12/2019.
//  Copyright © 2019 Filip Cernov. All rights reserved.
//

import Foundation





class Helper {
    
    static func removePhoto(imageName : String) {
        if imageName != "" {
            let fileManager = FileManager.default
            let imagePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(imageName)
            try! fileManager.removeItem(atPath: imagePath)
        }
    }
}
