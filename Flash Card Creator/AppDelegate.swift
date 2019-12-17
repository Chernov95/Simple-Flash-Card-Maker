//
//  AppDelegate.swift
//  Flash Card Creator
//
//  Created by Filip Cernov on 16/04/2019.
//  Copyright © 2019 Filip Cernov. All rights reserved.
//

import UIKit
import RealmSwift
import IQKeyboardManagerSwift


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        print(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last as! String)
        //Адрес  реалма
        
        UITextView.appearance().tintColor = .lightGray
        
        var navigationBarAppearace = UINavigationBar.appearance()
        IQKeyboardManager.shared.enable = true
        
        
                let config = Realm.Configuration(
                  // Set the new schema version. This must be greater than the previously used
                  // version (if you've never set a schema version before, the version is 0).
                  schemaVersion: 1,
        
        
                  // Set the block which will be called automatically when opening a Realm with
                  // a schema version lower than the one set above
                  migrationBlock: { migration, oldSchemaVersion in
                    // We haven’t migrated anything yet, so oldSchemaVersion == 0
                    if (oldSchemaVersion < 1) {
                        
                        migration.renameProperty(onType: Array.className(), from: "frontal" , to: "frontalText")
                        migration.renameProperty(onType: Array.className(), from: "dorsal" , to: "dorsalText")
                        migration.renameProperty(onType: Array.className(), from: "keyForFrontalImage" , to: "nameOfFrontalImage")
                        migration.renameProperty(onType: Array.className(), from: "keyForDorsalImage" , to: "nameOfDorsalImage")
                        migration.renameProperty(onType: Array.className(), from: "rectangleHas" , to: "tickedToDelete")
                                                
                      // Nothing to do!
                      // Realm will automatically detect new properties and removed properties
                      // And will update the schema on disk automatically
                    }
                  })
        
                // Tell Realm to use this new configuration object for the default Realm
                Realm.Configuration.defaultConfiguration = config
        
                // Now that we've told Realm how to handle the schema change, opening the file
                // will automatically perform the migration
                let _ = try! Realm()
        
             
  


     
        
        
        do {
            _ = try Realm()
            
        }catch{
            print("Error with Realm \(error)")
        }
        
        return true
    }




}


