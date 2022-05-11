//
//  LanguagesViewController.swift
//  Flash Card Creator
//
//  Created by Filip Cernov on 03/06/2019.
//  Copyright © 2019 Filip Cernov. All rights reserved.
//

import UIKit

protocol DeleteParentViewDelegate : class {
    func removeParentViewControllerDelegate ()
}

protocol ReloadDataInSettingViewController : class {
    func reloadDataInSettingsDelegate ()
}

protocol ProtocolThree : class {
    func threeDelegate ()
}

protocol ForBlockingSettingsButtonThree : class {
    func forBlockingSettingsButtonThreeDelegate ()
}



class LanguagesViewController: UIViewController {
    
    
    let arrayOfLanguages = ["English" , "Русский"]
    let nameOfPicturesForLanguage = ["English-Language-Flag-1-icon" ,"Russian-Federation-icon"]
    var userDefault = UserDefaults.standard
    var language : Language?
    var mode :  Mode?
    var indexOfChosenMode : Int?
    
    weak var delegate : DeleteParentViewDelegate?
    
    weak var backDelegate : ReloadDataInSettingViewController?
    
    weak var protocolThree : ProtocolThree?
    
    weak var delegateToBlockSettingButtonThreeDelegate : ForBlockingSettingsButtonThree?
    
    
    
    
    
    
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBAction func closeButtonTapped(_ sender: Any) {
        self.removeFromParent()
        self.view.removeFromSuperview()
        delegate?.removeParentViewControllerDelegate()
        delegateToBlockSettingButtonThreeDelegate?.forBlockingSettingsButtonThreeDelegate()
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.removeFromParent()
        self.view.removeFromSuperview()

    }

    @IBOutlet weak var viewOnTableView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        setUIDependingOnChosenLanguage()
        setUIDependingOnMode()
        
    }
    
    
  
    

}

extension LanguagesViewController : UITableViewDataSource , UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrayOfLanguages.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! LanguagesTableViewCell
        cell.languageImage.image = UIImage(named: nameOfPicturesForLanguage[indexPath.row])
//        cell.textLabel?.text = arrayOfLanguages[indexPath.row]
//        cell.textLabel?.textAlignment = .center
        cell.languagesLabel.text = arrayOfLanguages[indexPath.row]
        cell.languagesLabel.textColor = UIColor(hexString: (mode?.colorForTextColorInTableViewCells)!)
        if userDefault.value(forKeyPath: "Language by default") != nil {
            
            if indexPath.row == userDefault.value(forKeyPath: "Language by default") as! Int {
                
                cell.accessoryType = .checkmark
            }else {
                cell.accessoryType = .none
                
            }
            
        }else {
            if indexPath.row == userDefault.value(forKeyPath: "ChosenLanguage") as! Int {
                cell.accessoryType = .checkmark
            }else {
                cell.accessoryType = .none
            }
        }
        cell.tintColor = UIColor(hexString: (mode?.tickForLanguageColor)!)
        cell.contentView.superview!.backgroundColor = UIColor(hexString: (mode?.colorForBackgroundInTableView)!)
//        cell.textLabel?.textColor = UIColor(hexString: (mode?.colorForTextColorInTableViewCells)!)
        
        
        
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          
          tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
          userDefault.set(indexPath.row, forKey: "ChosenLanguage")
          userDefault.removeObject(forKey: "Language by default")
          setUIDependingOnChosenLanguage()
          self.tableView.reloadData()
          backDelegate?.reloadDataInSettingsDelegate()
          protocolThree?.threeDelegate()
    
      }
      

      
      func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
          
          tableView.cellForRow(at: indexPath)?.accessoryType = .none
      }
}


extension LanguagesViewController {
    
    func setUIDependingOnChosenLanguage () {
        
        if userDefault.value(forKeyPath: "ChosenLanguage") == nil {
            userDefault.setValue(0, forKey: "Language by default")
        }
         
         if UserDefaults.standard.value(forKeyPath: "ChosenLanguage") == nil {
             UserDefaults.standard.setValue(0, forKey: "Language by default")
         }
        let index = UserDefaults.standard.value(forKey: "ChosenLanguage") != nil ? UserDefaults.standard.value(forKey: "ChosenLanguage") as? Int : UserDefaults.standard.value(forKey:  "Language by default") as? Int
         language = Language.fetchLanguages()[index!]
         closeButton.setTitle(language?.closeButton, for: .normal)
         backButton.setTitle(language?.backButton, for: .normal)
         
     }

     
     func setUIDependingOnMode () {
         
         if UserDefaults.standard.value(forKeyPath: "ChosenMode") == nil {
             UserDefaults.standard.set(0, forKey: "Dark mode by default")
         }
         
        indexOfChosenMode = UserDefaults.standard.value(forKey: "ChosenMode") != nil ? UserDefaults.standard.value(forKeyPath: "ChosenMode" ) as? Int : UserDefaults.standard.value(forKey : "Dark mode by default" ) as? Int
        
         mode = Mode.fetchModes()[indexOfChosenMode!]
         tableView.backgroundColor = UIColor(hexString: (mode?.colorForBackgroundInTableView)!)
         viewOnTableView.backgroundColor = UIColor(hexString: (mode?.colorForBackgroundInTableView)!)
         backButton.setTitleColor(UIColor(hexString: (mode?.colorOfTextInButtons)!), for: .normal)
         closeButton.setTitleColor(UIColor(hexString: (mode?.colorOfTextInButtons)!), for: .normal)
         
     }
}
