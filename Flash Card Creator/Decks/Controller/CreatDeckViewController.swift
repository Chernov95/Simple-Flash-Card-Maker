//
//  CreatDeckViewController.swift
//  Flash Card Creator
//
//  Created by Filip Cernov on 12/05/2019.
//  Copyright © 2019 Filip Cernov. All rights reserved.
//

import UIKit
import RealmSwift

protocol ReloadDecksCollectionViewControllerDelegate : class {
    func reloadDecksCollectionViewControllerAfterCreatingNewDeckOrClosingCreatDeckViewController ()
}

class CreatDeckViewController: UIViewController {
    
    
    lazy var realm : Realm = {
        return try! Realm()
    }()
    weak var reloadDecksCollectionViewControllerDelegate : ReloadDecksCollectionViewControllerDelegate?
    var decks : Results<Deck>?
    var language : Language?
  
    
    
    
    
    @IBOutlet weak var popup: UIVisualEffectView!
    @IBOutlet weak var wrongLabelOnPopUp: UILabel!
    @IBOutlet weak var writeNameADeckOnPopUp: UILabel!
    @IBOutlet weak var gotItButtonForUI: UIButton!
    @IBOutlet weak var nameOfDeck: UITextField!
    @IBOutlet weak var cancelButtonForUI: UIButton!
    
   
    
    override func viewWillAppear(_ animated: Bool) {
        
        nameOfDeck.setBottomBorder(color: "E3E4E5")
        setUIDependingOnChosenLanguage()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        decks = realm.objects(Deck.self)
        popup.alpha = 0
        
        setAppearanceOfTextFieldWhichTakesNameOfTheDeck()
        
  

        
    }
    
    
    
    @IBAction func gotIt(_ sender: Any) {
        
        nameOfDeck.placeholder = "Enter a deck name"
        nameOfDeck.placeholder = language?.enterADeckName
        nameOfDeck.isHidden = false
        popup.alpha = 0
        
    }
    
    
    
    @IBAction func createDeck(_ sender: Any) {
        
        if nameOfDeck.text != "" {
            let newDeck = Deck()
            newDeck.name = nameOfDeck.text!
            newDeck.order = decks!.count
            saveNewDeckInRealm(deck: newDeck)
            reloadDecksCollectionViewControllerDelegate?.reloadDecksCollectionViewControllerAfterCreatingNewDeckOrClosingCreatDeckViewController ()
           backToDecksCollectionViewController()
        }else {
            popupShow()
        }

    }
    
    
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        
        backToDecksCollectionViewController()
        reloadDecksCollectionViewControllerDelegate?.reloadDecksCollectionViewControllerAfterCreatingNewDeckOrClosingCreatDeckViewController ()
        
    }
    
    
    func saveNewDeckInRealm(deck : Deck) {
        
        do {
            try realm.write {
                realm.add(deck)
            }
        }catch {
            print("Error saving context\(error)")
        }
        
    }
    
    
    func backToDecksCollectionViewController() {
        
        self.removeFromParent()
        self.view.removeFromSuperview()
        
    }
    
    func popupShow() {
        
        nameOfDeck.isHidden = true
        popup.transform = CGAffineTransform(scaleX: 0.3, y: 2)
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0, options: .allowUserInteraction, animations: {
            self.popup.transform = .identity
        }) { (succes) in
        }
        popup.alpha = 1
        
    }
    
    func setAppearanceOfTextFieldWhichTakesNameOfTheDeck() {
        nameOfDeck.setBottomBorder(color: "E3E4E5" )
        nameOfDeck.textColor = .black
        
    }
    
}


extension CreatDeckViewController {
    func setUIDependingOnChosenLanguage () {
        let index = UserDefaults.standard.value(forKey: "ChosenLanguage") != nil ? UserDefaults.standard.value(forKey: "ChosenLanguage") as? Int : UserDefaults.standard.value(forKey:  "Language by default") as? Int
        language = Language.fetchLanguages()[index!]
        nameOfDeck.placeholder  = language?.enterADeckName
        wrongLabelOnPopUp.text = language?.wrong
        writeNameADeckOnPopUp.text = language?.writeNameADeck
        gotItButtonForUI.setTitle(language?.gotIt, for: .normal)
        cancelButtonForUI.setTitle(language?.cancel, for: .normal)
        
    }
}






