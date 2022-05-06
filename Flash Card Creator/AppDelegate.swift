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
        
        //Realm Adress
        print(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last as! String)
        
        
//        UITextView.appearance().tintColor = .lightGray
        addingStyleToNavBar()
        UISearchBar.appearance().backgroundColor = .clear  // Add your color
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        
      
        
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = UIColor.white
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = .darkGray
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).leftView?.tintColor = .blue
        
        UITextView.appearance().tintColor = .darkGray

        
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
        
  

        
        
        do {
            _ = try Realm()
            
        }catch{
            print("Error with Realm \(error)")
        }
        
        return true
    }
    

    func addingStyleToNavBar() {
        if UserDefaults.standard.value(forKeyPath: "ChosenMode") == nil {
            UserDefaults.standard.set(0, forKey: "Dark mode by default")
        }
        
        let indexOfChosenMode = UserDefaults.standard.value(forKey: "ChosenMode") != nil ? UserDefaults.standard.value(forKeyPath: "ChosenMode" ) as? Int : UserDefaults.standard.value(forKey : "Dark mode by default" ) as? Int
        
        let mode = Mode.fetchModes()[indexOfChosenMode!]
        let navigationBarAppearace = UINavigationBar.appearance()
        navigationBarAppearace.tintColor = .white
        navigationBarAppearace.backgroundColor = UIColor(hexString: mode.navBarColor!)
    }




}

extension UISearchBar {
func setCenteredPlaceHolder(){
    let textFieldInsideSearchBar = self.value(forKey: "searchField") as? UITextField

    //get the sizes
    let searchBarWidth = self.frame.width
    let placeholderIconWidth = textFieldInsideSearchBar?.leftView?.frame.width
    let placeHolderWidth = textFieldInsideSearchBar?.attributedPlaceholder?.size().width
    let offsetIconToPlaceholder: CGFloat = 8
    let placeHolderWithIcon = placeholderIconWidth! + offsetIconToPlaceholder

    let offset = UIOffset(horizontal: ((searchBarWidth / 2) - (placeHolderWidth! / 2) - placeHolderWithIcon), vertical: 0)
    self.setPositionAdjustment(offset, for: .search)
}
}




extension String {

    static func random(length: Int = 20) -> String {
        let base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var randomString: String = ""

        for _ in 0..<length {
            let randomValue = arc4random_uniform(UInt32(base.count))
            randomString += "\(base[base.index(base.startIndex, offsetBy: Int(randomValue))])"
        }
        return randomString
    }
}
