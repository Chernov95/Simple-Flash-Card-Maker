//
//  DecksCollectionViewController.swift
//  Flash Card Creator
//
//  Created by Filip Cernov on 15/05/2019.
//  Copyright © 2019 Filip Cernov. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit
import ViewAnimator


class DecksCollectionViewController: UICollectionViewController  {
    

    
    
    lazy var realm : Realm = {
        return try! Realm()
    }()
    var canIGoOnNextViewControllerOrToScroll = true
    var decks : Results<Deck>?
    var language : Language?
    var mode :  Mode?
    var indexOfChosenMode : Int?
    var indexOfChosenLanguage : Int?
    var searching = false
    private let animationAfterLoadingView = [AnimationType.from(direction: .bottom, offset: 30.0)]
    let createCreateDeckButton = UIButton(frame: CGRect(x: 34, y: 200, width: 307, height: 48))
    
    

    

    
    @IBOutlet weak var goToSettingToControlActivity: UIButton!
    
    

    override func viewWillAppear(_ animated: Bool) {
        loadItems()
        setUIDependingOnChosenLanguage()
        setUIDependingOnMode()
        if navigationItem.searchController?.searchBar.text != "" {
            decks = realm.objects(Deck.self).filter("name BEGINSWITH[c] %@", navigationItem.searchController?.searchBar.text)
        }else{
            navigationItem.searchController?.isActive = false
        }
        
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }

  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadItems()
        setUIDependingOnChosenLanguage()
        setUIDependingOnMode()
        animationAfterLoading()
        createSearchBar()
        checkShake()
        
    }
    
  
    
  
  

    

    
   
    
    // MARK: - Create Deck action code
    @objc func createDeck(sender: UIButton!) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CreatDeckViewController") as! CreatDeckViewController
        vc.reloadDecksCollectionViewControllerDelegate = self
        goToSettingToControlActivity.isEnabled = false
        navigationItem.searchController?.searchBar.isUserInteractionEnabled = false
        self.addChild(vc)
        self.view.addSubview(vc.view)
        let sourceViewController = self
        let containerView = sourceViewController.view.superview
        let originalCenter = sourceViewController.view.center
        vc.view.transform = CGAffineTransform(scaleX: 0, y: 1)
        vc.view.center = originalCenter
        containerView?.addSubview(vc.view)
        UIView.animate(withDuration: 0.01, delay: 0,options: .curveLinear, animations: {
            vc.view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
            vc.view.transform = CGAffineTransform.identity
        }, completion: nil)
        if   navigationItem.searchController?.isActive == true {
              navigationItem.searchController?.isActive = false
        }
        
    }
    

    // MARK: - Go to setting Button Action
    @IBAction func goToSettings(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
        vc.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        vc.reloadDecksCollectionViewControllerDelegate = self
        vc.changeLanguageInDecksCollectionViewController = self
        vc.blockingSettingsButtonSecondDelegate = self
        vc.updateDecksCollectionViewControllerAfterChangingModeDelegate = self
        self.addChild(vc)
        self.view.addSubview(vc.view)
       
        navigationItem.searchController?.searchBar.isUserInteractionEnabled = false
        if navigationItem.searchController?.isActive == true && navigationItem.searchController?.searchBar.text == "" {
            navigationItem.searchController?.isActive = false
        }
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    // MARK: - Prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToCards" {
            let destinationVC =  segue.destination as! CardsInDeckCollectionViewController
            if  let indexPath = collectionView.indexPathsForSelectedItems?.first {
                destinationVC.selectedDeck = decks?[indexPath.row]

                destinationVC.nameOfDeck = decks?[indexPath.row].name
            }
            
        }
     
    }
    
    
    

    
 

  
    // MARK: Number of items in section
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if decks?.count != 0 {
            return decks!.count 
        }else {
            return 0
        }
    }
    
    // MARK: - Header
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath)
        let button = header.viewWithTag(123) as! UIButton
        let myDecksImage = header.viewWithTag(32) as! UIImageView
        if indexOfChosenMode == 0 {
            if indexOfChosenLanguage == 0{
                button.setImage(UIImage(named: (mode?.buttonCreateDeckForDecksCollectionViewControllerEnglish)!), for: .normal)
                myDecksImage.image = UIImage(named: (mode?.imageMyDecksEnglish)!)
            }else{
                 button.setImage(UIImage(named: (mode?.buttonCreateDeckForDecksCollectionViewControllerRussian)!), for: .normal)
                myDecksImage.image = UIImage(named: (mode?.imageMeDecksRussian)!)
            }
            
        }else{
            if indexOfChosenLanguage == 0{
                button.setImage(UIImage(named: (mode?.buttonCreateDeckForDecksCollectionViewControllerEnglish)!), for: .normal)
                myDecksImage.image = UIImage(named: (mode?.imageMyDecksEnglish)!)
            }else{
                button.setImage(UIImage(named: (mode?.buttonCreateDeckForDecksCollectionViewControllerRussian)!), for: .normal)
                myDecksImage.image = UIImage(named: (mode?.imageMeDecksRussian)!)
            }
        }
        button.addTarget(self, action: #selector(createDeck), for: .touchUpInside)

        return header
    }
    
    


 
    // MARK: - Cell adjustment
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DeckCell", for: indexPath) as! SwipeCollectionViewCell
        let nameLabel = cell.viewWithTag(123) as! UITextField
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.minimumFontSize = 12
        let numberLabel = cell.viewWithTag(456) as! UILabel
        nameLabel.text = decks![indexPath.item].name
        numberLabel.text = "\(decks![indexPath.item].cards.count)"
        numberLabel.textColor = .black
        numberLabel.font = optimisedfindAdaptiveFontWithName(fontName: "Avenir Next Demi Bold", label: numberLabel, minSize: 1, maxSize: 17)
        numberLabel.numberOfLines = 0
        cell.delegate = self
        cell.backgroundColor = UIColor(hexString: (mode?.backGroundOfDeckCells)!)
        cell.layoutIfNeeded()
        cell.setNeedsLayout()
        
        return cell
    }
    
    // MARK: - did selected item at
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //If deck name of deck is editing false value wont let execute segue
        if canIGoOnNextViewControllerOrToScroll == true {
            performSegue(withIdentifier: "goToCards", sender: self)
        }
        
    }

    // MARK: - In order to prevent moving items while searching
    override func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        if searching == true {
            return  false
        }else{
            return true
        }
     
    }
    
    // MARK: - Moving Items
    override func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if searching == false {
            try! realm.write {
                let sourceObject = decks![sourceIndexPath.item]
                let destinationObject = decks![destinationIndexPath.item]
                let destinationObjectOrder = destinationObject.order
                if sourceIndexPath.item < destinationIndexPath.item {
                    for index in sourceIndexPath.item ... destinationIndexPath.item {
                        let object = decks![index]
                        object.order -= 1
                    }
                }else {
                    for index in (destinationIndexPath.item ..< sourceIndexPath.item).reversed(){
                        let object = decks![index]
                        object.order += 1
                    }
                }
                sourceObject.order = destinationObjectOrder
                decks = realm.objects(Deck.self).sorted(byKeyPath: "order", ascending: true)
            }
        }
    }
    
    

    
    // MARK: - Deleting by swipe
    func collectionView(_ collectionView: UICollectionView, editActionsForItemAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        if canIGoOnNextViewControllerOrToScroll == true {
            guard orientation == .right else { return nil }
            let deleteAction = SwipeAction(style: .destructive, title: language?.deleteForSwipe) { action, indexPath in
                // handle action by updating model with deletion
                self.deleteDeck(at: indexPath)
            }
            // customize the action appearance
            deleteAction.image = UIImage(named: "delete-icon")
            
            
            
            return [deleteAction]
        }else{
            return nil
        }
        
       
   
    }
    
    // MARK: Swipe customasing
    func collectionView(_ collectionView: UICollectionView, editActionsOptionsForItemAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        
        return options
        
    }
    
    
    // MARK: - Setting value for deck and sorting objects there by property(order)
    func loadItems() {
        decks = realm.objects(Deck.self).sorted(byKeyPath: "order", ascending: true)
        collectionView.reloadData()
    }
    
    // MARK: Deleting deck function
     func deleteDeck(at indexPath: IndexPath) {
        if let deckForDeletion = self.decks?[indexPath.item]{
            do {
                try self.realm.write {
                    if deckForDeletion.cards.count > 0 {
                        for index in 0...deckForDeletion.cards.count - 1 {
                            if deckForDeletion.cards[index].nameOfFrontalImage != "" {
                                Helper.removePhoto(imageName: deckForDeletion.cards[index].nameOfFrontalImage)
                            }
                            if deckForDeletion.cards[index].nameOfDorsalImage != "" {
                                Helper.removePhoto(imageName: deckForDeletion.cards[index].nameOfDorsalImage)
                            }
                        }
                        self.realm.delete(deckForDeletion.cards)
                    }
                    self.realm.delete(deckForDeletion)
                }
            }catch{
                print("Error deleting Category \(error)")
            }
        }
        recalculateOrderOfDecks()
    }
    

    func checkShake () {
        if UserDefaults.standard.value(forKeyPath: "ChosenShake") == nil {
            UserDefaults.standard.set(1, forKey: "shake by default")
        }
    }
    // MARK: Animation after loading collection view
    func animationAfterLoading() {
        collectionView?.reloadData()
        collectionView?.performBatchUpdates({
            UIView.animate(views: self.collectionView!.orderedVisibleCells,
                           animations: animationAfterLoadingView, completion: {
            })
        }, completion: nil)
    }

    // MARK: Creating search bar
    func createSearchBar() {

        
        if #available(iOS 11.0, *) {
            let sc = UISearchController(searchResultsController: nil)
            sc.delegate = self
            sc.searchBar.delegate = self
            self.definesPresentationContext = true
            let scb = sc.searchBar
            if #available(iOS 13.0, *) {
                scb.searchTextField.leftView?.tintColor = .white
            }
            scb.tintColor = UIColor.white

            if let textfield = scb.value(forKey: "searchField") as? UITextField {
                textfield.textColor = UIColor.blue
                if let backgroundview = textfield.subviews.first {
                    // Rounded corner
                    backgroundview.layer.cornerRadius = 10;
                    backgroundview.clipsToBounds = true;
                }
            }

            if let navigationbar = self.navigationController?.navigationBar {
                //C9C9C9
                navigationbar.barTintColor = UIColor(hexString: "54B5F2")
            
            
            }
            navigationItem.searchController = sc
            navigationItem.searchController?.dimsBackgroundDuringPresentation = false
            navigationItem.hidesSearchBarWhenScrolling = false
            navigationItem.searchController?.hidesNavigationBarDuringPresentation = true
        }
    }
   
    
    
    
  
    func optimisedfindAdaptiveFontWithName(fontName:String, label:UILabel!, minSize:CGFloat,maxSize:CGFloat) -> UIFont! {

        var tempFont:UIFont
        var tempMax:CGFloat = maxSize
        var tempMin:CGFloat = minSize
        while (ceil(tempMin) != ceil(tempMax)){
            let testedSize = (tempMax + tempMin) / 2
            tempFont = UIFont(name:fontName, size:testedSize)!
            let attributedString = NSAttributedString(string: label.text!, attributes: [NSAttributedString.Key.font : tempFont])
            let textFrame = attributedString.boundingRect(with: CGSize(width: label.bounds.size.width, height: CGFloat.greatestFiniteMagnitude), options: NSStringDrawingOptions.usesLineFragmentOrigin , context: nil)
            let difference = label.frame.height - textFrame.height
//            print("\(tempMin)-\(tempMax) - tested : \(testedSize) --> difference : \(difference)")
            if(difference > 0){
                tempMin = testedSize
            }else{
                tempMax = testedSize
            }
        }

        
        //returning the size -1 (to have enought space right and left)
        return UIFont(name: fontName, size: tempMin - 1)
    }
    
    func recalculateOrderOfDecks() {
        if decks?.count != 0 {
            for index in 0...decks!.count - 1 {
                let realm = try! Realm()
                let deckOrder = decks![index]
                    try! realm.write {
                        deckOrder.order = index
                    }
            }
        }
    }
    
    // MARK: - Is changing name in realm
    func getNumberAndNewNameOfTheDeck(numberOfDeck: Int, nameOfDeck: String) {
                do {
                    try realm.write {
                        //!!!!!!!Тут проверку на пустое название сделать нужно будет!
                        decks![numberOfDeck].name = nameOfDeck
                    }
                } catch let error as NSError {
                    print(error)
                }
        
        collectionView.isUserInteractionEnabled = true
    }
    



}



extension DecksCollectionViewController : UISearchControllerDelegate, UISearchBarDelegate {
    // MARK: - text did change
       func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
           if searchText.count == 0 {
               loadItems()
           }else{
               decks = realm.objects(Deck.self).filter("name BEGINSWITH[c] %@", searchText)
           }
           searching = true
           collectionView.reloadData()
       }
       
       // MARK: - cancel button clicked
       func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
           searching = false
           loadItems()
           print("Canceled")
       }
       // MARK: - Search Bar text did end editing
       func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
           searching = false
           if searchBar.text!.count != 0 {
             decks = realm.objects(Deck.self).filter("name BEGINSWITH[c] %@", searchBar.text)
           }else{
             loadItems()
           }
       }
       // MARK: - Search bar button clicked
       func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
           loadItems()
           searching = false
       }
}

extension DecksCollectionViewController {
    // MARK: Set Language
    func setUIDependingOnChosenLanguage () {
        if UserDefaults.standard.value(forKeyPath: "ChosenLanguage") == nil {
            UserDefaults.standard.setValue(0, forKey: "Language by default")
        }
        
        indexOfChosenLanguage = UserDefaults.standard.value(forKey: "ChosenLanguage") != nil ?  UserDefaults.standard.value(forKey: "ChosenLanguage") as? Int :  UserDefaults.standard.value(forKey:  "Language by default") as? Int
        
        language = Language.fetchLanguages()[indexOfChosenLanguage!]
        title = language?.titleFirstCollectionViewController
        createCreateDeckButton.setImage(UIImage(named: language!.imageToCreateDeck), for: .normal)
        navigationItem.searchController?.searchBar.placeholder = language?.placeholderInSearchBar
        navigationItem.searchController?.searchBar.setValue(language?.cancel, forKey: "cancelButtonText")
    }
    // MARK: Set dark or light mode
    func setUIDependingOnMode () {
        if UserDefaults.standard.value(forKeyPath: "ChosenMode") == nil {
            UserDefaults.standard.set(0, forKey: "Dark mode by default")
        }
        
        indexOfChosenMode = UserDefaults.standard.value(forKey: "ChosenMode") != nil ? UserDefaults.standard.value(forKeyPath: "ChosenMode" ) as? Int : UserDefaults.standard.value(forKey : "Dark mode by default" ) as? Int
        
        mode = Mode.fetchModes()[indexOfChosenMode!]
        navigationController?.navigationBar.barTintColor = UIColor(hexString: (mode?.navBarColor)!)
        collectionView.backgroundColor = UIColor(hexString: (mode?.backroundOfDecksCollectionViewController)!)
        goToSettingToControlActivity.setImage(UIImage(named: (mode?.settingsButton)!), for: .normal)
        addingCustomStatusBar(color: UIColor(hexString: mode!.navBarColor!))
        
        let mode = Mode.fetchModes()[indexOfChosenMode!]
        let navigationBarAppearace = UINavigationBar.appearance()
        navigationBarAppearace.tintColor = .white
        navigationBarAppearace.backgroundColor = UIColor(hexString: mode.navBarColor!)
  
        
    }
    
    func addingCustomStatusBar (color: UIColor) {
        let statusBarView = UIView()
        view.addSubview(statusBarView)
        statusBarView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            statusBarView.topAnchor.constraint(equalTo: view.topAnchor),
            statusBarView.leftAnchor.constraint(equalTo: view.leftAnchor),
            statusBarView.rightAnchor.constraint(equalTo: view.rightAnchor),
            statusBarView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
        statusBarView.backgroundColor = color
    }
}


extension DecksCollectionViewController : ReloadDecksCollectionViewControllerDelegate , SwipeCollectionViewCellDelegate ,  ReloadDataInDeckCollectionViewController ,  ChangeLanguageInDecksCollectionViewControllerFromSecondProtocol , BlockingSettingsButtonSecondDelegate , UpdateDecksCollectionViewControllerAfterChangingMode{
    
    func reloadDecksCollectionViewControllerAfterCreatingNewDeckOrClosingCreatDeckViewController() {
           
           loadItems()
           setUIDependingOnChosenLanguage()
           self.collectionView.reloadData()
           goToSettingToControlActivity.isEnabled = true
           navigationItem.searchController?.searchBar.isUserInteractionEnabled = true

    }
    
    func checkIfICanGoToCardsCollectionViewControllerAndScroll(canIGoAndScroll: Bool) {
         canIGoOnNextViewControllerOrToScroll = canIGoAndScroll
         if canIGoOnNextViewControllerOrToScroll == true {
             collectionView.isScrollEnabled = true
         }else{
             collectionView.isScrollEnabled = false
         }
     }
     
    
     
     func updateCollectionViewAfterCancelingOfEditingCard() {
         self.collectionView.reloadData()
     }
     
     func updateDecksAfterChangingModeDelegate() {
         setUIDependingOnMode()
         self.collectionView.reloadData()
     }
     
     func blockSettingsButtonFromSecondDelegate() {
         navigationItem.searchController?.searchBar.isUserInteractionEnabled = true
     }
     
    
     
     func changeLanguageInDecksCollectionViewController() {
         setUIDependingOnChosenLanguage()
         self.collectionView.reloadData()
     }
     
     
     func reloadDataInDeckCollectionViewController() {
         
         setUIDependingOnChosenLanguage()

         navigationItem.searchController?.searchBar.isUserInteractionEnabled = true
         navigationController?.setNavigationBarHidden(false, animated: true)
         collectionView.reloadData()
         
     }
     
     
}











