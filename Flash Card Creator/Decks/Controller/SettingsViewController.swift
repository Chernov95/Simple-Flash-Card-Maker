//
//  SettingsViewController.swift
//  Flash Card Creator
//
//  Created by Filip Cernov on 03/06/2019.
//  Copyright © 2019 Filip Cernov. All rights reserved.
//

import UIKit

protocol ReloadDataInDeckCollectionViewController : class {
    func reloadDataInDeckCollectionViewController()
}

protocol ChangeLanguageInDecksCollectionViewControllerFromSecondProtocol : class {
    func changeLanguageInDecksCollectionViewController ()
}

protocol BlockingSettingsButtonSecondDelegate : class {
    func blockSettingsButtonFromSecondDelegate ()
}

protocol UpdateDecksCollectionViewControllerAfterChangingMode : class {
    func updateDecksAfterChangingModeDelegate ()
}


class SettingsViewController: UIViewController  {
    
    weak var blockingSettingsButtonSecondDelegate : BlockingSettingsButtonSecondDelegate?
    
    weak var reloadDecksCollectionViewControllerDelegate : ReloadDataInDeckCollectionViewController?
    
    weak var changeLanguageInDecksCollectionViewController : ChangeLanguageInDecksCollectionViewControllerFromSecondProtocol?
    
    weak var updateDecksCollectionViewControllerAfterChangingModeDelegate : UpdateDecksCollectionViewControllerAfterChangingMode?
    

    var userDefault = UserDefaults.standard
    

    var language : Language?
    var mode :  Mode?
    var indexOfChosenMode : Int?
    var indexOfChosenLanguage : Int?
    
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewOverTableView: UIView!
    @IBOutlet weak var closeButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        setUIDependingOnChosenLanguage()
        
        // Прочитаеться только один раз при первом заходе в приложение
        if userDefault.value(forKeyPath: "ChosenShake") == nil {
            userDefault.set(0, forKey: "shake by default")
        }
        setUIDependingOnMode()
        

    }

    @IBAction func closeButtonTapped(_ sender: Any) {
        
        self.removeFromParent()
        self.view.removeFromSuperview()
        reloadDecksCollectionViewControllerDelegate?.reloadDataInDeckCollectionViewController()
        
        
    }
   
    
    
    @IBAction func ActivateShake(_ sender: UISwitch) {
        if sender.isOn == true {
            userDefault.set(1, forKey: "ChosenShake")
        }else{
            userDefault.set(0, forKey: "ChosenShake")
            if userDefault.value(forKeyPath: "shake by default") != nil {
                userDefault.removeObject(forKey: "shake by default")
            }
        }
        
    }
    
    
    
    @IBAction func ActivateDarkMode(_ sender: UISwitch) {
        if sender.isOn == true {
            userDefault.set(1, forKey: "ChosenMode")
            
            if userDefault.value(forKeyPath: "Dark mode by default") != nil {
                userDefault.removeObject(forKey: "Dark mode by default")
            }
        }else{
            userDefault.set(0, forKey: "ChosenMode")
        }
        updateDecksCollectionViewControllerAfterChangingModeDelegate?.updateDecksAfterChangingModeDelegate()
        setUIDependingOnMode()
        tableView.reloadData()
    }
    

    
   
    
    
    
    



}

extension SettingsViewController : UITableViewDataSource , UITableViewDelegate {
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 3
        }else{
            return 2
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
              if indexPath.section == 0 {
                  if indexPath.row == 0 {
                      let cell = tableView.dequeueReusableCell(withIdentifier: "mode", for: indexPath) as! DarkModeCell
                      cell.textLabel?.text = language?.darkMode
                      cell.textLabel?.textAlignment = .center
                      if userDefault.value(forKeyPath: "Dark mode by default") == nil {
                          if userDefault.value(forKeyPath: "ChosenMode") as? Int == 1 {
                              cell.darkModeSwitch.setOn(true, animated: false)
                          }else{
                              cell.darkModeSwitch.setOn(false, animated: false)
                          }
                          
                      }else{
                          cell.darkModeSwitch.setOn(false, animated: false)
                      }
                      cell.contentView.backgroundColor = UIColor(hexString: (mode?.colorForBackgroundInTableView)!)
                      cell.textLabel?.textColor = UIColor(hexString: (mode?.colorForTextColorInTableViewCells)!)
                      
                      
                      return cell
                      
                  }else if indexPath.row == 1 {
                      let cell = tableView.dequeueReusableCell(withIdentifier: "language", for: indexPath) as! ChosenLanguageCell
                      cell.textLabel?.text = language?.laguage
                      cell.textLabel?.textAlignment = .center
                      cell.chosenLanguageLabel.text = language?.selectedLanguage
                      cell.chosenLanguageLabel.textColor = UIColor(hexString: (mode?.chosenLanguageColor)!)
                      cell.textLabel?.textColor = UIColor(hexString: (mode?.colorForTextColorInTableViewCells)!)
                      cell.contentView.superview!.backgroundColor = UIColor(hexString: (mode?.colorForBackgroundInTableView)!)
                      return cell
                      
                  }else if indexPath.row == 2 {
                      let cell = tableView.dequeueReusableCell(withIdentifier: "shake", for: indexPath) as! ShakeCell
                      if userDefault.value(forKeyPath: "shake by default") == nil {
                          if userDefault.value(forKeyPath: "ChosenShake") as? Int == 1 {
                              cell.switchShake.setOn(true, animated: false)
                          }else{
                              cell.switchShake.setOn(false, animated: false)
                          }
                          
                      }else{
                          cell.switchShake.setOn(true, animated: false)
                      }
                      cell.contentView.backgroundColor = UIColor(hexString: (mode?.colorForBackgroundInTableView)!)
                      cell.textLabel?.textColor = UIColor(hexString: (mode?.colorForTextColorInTableViewCells)!)
                      cell.shakingName.text = language?.shakeYouPhone
                      cell.shakingName.adjustsFontSizeToFitWidth = true
                      cell.shakingName.textColor = UIColor(hexString: (mode?.colorForTextColorInTableViewCells)!)
                      //настроить размер текста
                      return cell
                  }
                  
              }else if indexPath.section == 1 {
                  if indexPath.row == 0 {
                      let cell = tableView.dequeueReusableCell(withIdentifier: "rateTheApp", for: indexPath)
                      cell.textLabel?.text = language?.ratetheApp
                      cell.textLabel?.textAlignment = .center
                      cell.contentView.backgroundColor = UIColor(hexString: (mode?.colorForBackgroundInTableView)!)
                      cell.textLabel?.textColor = UIColor(hexString: (mode?.colorForTextColorInTableViewCells)!)
                      return cell
                  }else if indexPath.row == 1 {
                      let cell = tableView.dequeueReusableCell(withIdentifier: "sendUsFeedback", for: indexPath)
                      cell.textLabel?.text = language?.sendUsFeedback
                      cell.textLabel?.textAlignment = .center
                      cell.contentView.backgroundColor = UIColor(hexString: (mode?.colorForBackgroundInTableView)!)
                      cell.textLabel?.textColor = UIColor(hexString: (mode?.colorForTextColorInTableViewCells)!)
                      return cell
                  }
              }
              
              return UITableViewCell()
              
              
             
          }
          
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           
           if indexPath.row == 1 && indexPath.section == 0 {
               let vc = self.storyboard?.instantiateViewController(withIdentifier: "LanguagesViewController") as! LanguagesViewController
               
               vc.view.backgroundColor = UIColor.black.withAlphaComponent(0)
               vc.delegate = self
               vc.backDelegate = self
               vc.protocolThree = self
               vc.delegateToBlockSettingButtonThreeDelegate = self
               
               self.addChild(vc)
               self.view.addSubview(vc.view)
               
               
           }
           
           
           if indexPath.row == 1 && indexPath.section == 1 {
               let email = "philipchernov95@gmail.com"
               if let url = URL(string: "mailto:\(email)") {
                   if #available(iOS 10.0, *) {
                       UIApplication.shared.open(url)
                   } else {
                       UIApplication.shared.openURL(url)
                   }
               }
               
             
           }
           
           if indexPath.row == 0 && indexPath.section == 1 {
               
               let urlStr = "itms-apps://itunes.apple.com/app/id\(1476419070)"
               if let url = URL(string: urlStr), UIApplication.shared.canOpenURL(url) {
                   if #available(iOS 10.0, *) {
                       UIApplication.shared.open(url, options: [:], completionHandler: nil)
                   } else {
                       UIApplication.shared.openURL(url)
                   }
               }
           }
           
           
       }
       
       
    

       
      
       
}


extension SettingsViewController : DeleteParentViewDelegate , ReloadDataInSettingViewController , ProtocolThree  , ForBlockingSettingsButtonThree {
    
    
    func forBlockingSettingsButtonThreeDelegate() {
        blockingSettingsButtonSecondDelegate?.blockSettingsButtonFromSecondDelegate()
    }
    
    
    func removeParentViewControllerDelegate() {
        reloadDecksCollectionViewControllerDelegate?.reloadDataInDeckCollectionViewController()
        self.removeFromParent()
        self.view.removeFromSuperview()
    }
    
    
    func threeDelegate() {
        changeLanguageInDecksCollectionViewController?.changeLanguageInDecksCollectionViewController()
    }
    
    func reloadDataInSettingsDelegate() {
           setUIDependingOnChosenLanguage()
           self.tableView.reloadData()
    }
    
}


extension SettingsViewController {
       func setUIDependingOnMode () {
        
           if userDefault.value(forKeyPath: "ChosenMode") == nil {
             userDefault.set(0, forKey: "Dark mode by default")
           }
           if UserDefaults.standard.value(forKeyPath: "ChosenMode") == nil {
               UserDefaults.standard.set(0, forKey: "Dark mode by default")
           }
           
           if UserDefaults.standard.value(forKey: "ChosenMode") != nil {
               indexOfChosenMode = UserDefaults.standard.value(forKeyPath: "ChosenMode" ) as? Int
           } else {
               indexOfChosenMode = UserDefaults.standard.value(forKey : "Dark mode by default" ) as? Int
           }
           mode = Mode.fetchModes()[indexOfChosenMode!]
           tableView.backgroundColor = UIColor(hexString: (mode?.colorForBackgroundInTableView)!)
           viewOverTableView.backgroundColor = UIColor(hexString: (mode?.colorForBackgroundInTableView)!)
           closeButton.setTitleColor(UIColor(hexString: (mode?.colorOfTextInButtons)!), for: .normal)
       }
       
    
       
       func setUIDependingOnChosenLanguage () {
           if UserDefaults.standard.value(forKey: "ChosenLanguage") != nil {
               indexOfChosenLanguage = UserDefaults.standard.value(forKey: "ChosenLanguage") as? Int
           }else {
               indexOfChosenLanguage = UserDefaults.standard.value(forKey:  "Language by default") as? Int
           }
           language = Language.fetchLanguages()[indexOfChosenLanguage!]
           closeButton.setTitle(language?.closeButton, for: .normal)
       }
       
      
}
