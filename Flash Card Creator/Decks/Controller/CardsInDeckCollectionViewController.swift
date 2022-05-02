//
//  CollectionViewController.swift
//  Flash Card Creator
//
//  Created by Filip Cernov on 16/04/2019.
//  Copyright © 2019 Filip Cernov. All rights reserved.
//

import UIKit
import RealmSwift
import ViewAnimator
import TransitionButton
import AnimatableReload



class CardsInDeckCollectionViewController: UICollectionViewController,UISearchControllerDelegate {
 
    
    lazy var realm : Realm = {
            return try! Realm()
    }()
    var cards : Results<Array>?

    var language : Language?
    var mode :  Mode?
    var indexOfChosenMode : Int?
    
    var nameOfDeckLabel : UILabel?
    var nameOfDeck : String?
    
    var searching  = false
    
    lazy var trashButtonIsActive = false
    fileprivate var longPressGesture : UILongPressGestureRecognizer!
    var indexSelected : Int?
    private let animationAfterLoadingView = [AnimationType.from(direction: .top, offset: 30.0)]
    let reviewService = ReviewService.shared
    var selectedDeck : Deck! {
        didSet {
            
            loadCards()
            
        }
    }

    @IBOutlet weak var collectionOfViews: UICollectionView!
    @IBOutlet weak var removeAllButtonToHide: UIButton!
    @IBAction func removeAllButton(_ sender: UIButton) {
        
        for number in 0 ... cards!.count - 1 {
            
            Helper.removePhoto(imageName: cards![number].nameOfDorsalImage)
            Helper.removePhoto(imageName: cards![number].nameOfFrontalImage)
            
        }
       try! realm.write {
            
            realm.delete(cards!)
            
        }
        
        removeAllButtonToHide.isHidden = true
        deleteButtonToHide.isHidden = true
        trashButtonToHide.isHidden = true
        trashButtonToHide.setImage(UIImage(named: "Black Trash"), for: .normal)
        trashButtonIsActive = false
        swipeActionImage.isHidden = true
        self.collectionView.reloadData()
        
    }
    
    
 
    
    @IBOutlet weak var deleteButtonToHide: UIButton!
    @IBAction func deleteButton(_ sender: UIButton) {
        

            let objectsToDelete = selectedDeck.cards.filter("tickedToDelete = true")
    
        
            for number in 0...objectsToDelete.count - 1 {
                Helper.removePhoto(imageName: objectsToDelete[number].nameOfFrontalImage)
                Helper.removePhoto(imageName: objectsToDelete[number].nameOfDorsalImage)
            }
            
            do {
                try realm.write {
                    
                    realm.delete(objectsToDelete)
                    
                }
                
            }catch{
                print("Error deleting from realm")
            }
            
            deleteButtonToHide.isHidden = true
            removeAllButtonToHide.isHidden = true
            trashButtonToHide.setImage(UIImage(named: "Black Trash"), for: .normal)
            trashButtonIsActive = false
            
            if cards?.count == 0 {
                trashButtonToHide.isHidden = true
                swipeActionImage.isHidden = true
            }else {
                trashButtonToHide.isHidden = false
                swipeActionImage.isHidden = false
            }
           recalculateCardsOrderProperty()
           self.collectionView.reloadData()
        
    }
    
    @IBOutlet weak var trashButtonToHide: UIButton!
    @IBAction func trashButton(_ sender: UIButton) {
        
        trashButtonApperance()
        
        if trashButtonToHide.imageView?.image == UIImage(named: "Red Trash")  {
            trashButtonToHide.setImage(UIImage(named: "Black Trash"), for: .normal)
        } else {
            trashButtonToHide.setImage(UIImage(named: "Red Trash"), for: .normal)
        }
        
        if trashButtonIsActive == false {
         
            trashButtonIsActive = true
            deleteButtonToHide.isHidden = false
            removeAllButtonToHide.isHidden = false
            trashButtonToHide.setImage(UIImage(named: "Red Trash"), for: .normal)
            self.collectionView.reloadData()
            
        }else {
            
            trashButtonIsActive = false
            deleteButtonToHide.isHidden = true
            removeAllButtonToHide.isHidden = true
            trashButtonToHide.setImage(UIImage(named: "Black Trash"), for: .normal)
            untickAllCellsWhichHaveBeenSelected()
            self.collectionView.reloadData()

        }
        
    }
    

  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
       
        trashButtonApperance()
        reloadData()
        setUIDependingOnChosenLanguage()
        if trashButtonIsActive == true {
            deleteButtonToHide.isHidden = false
            removeAllButtonToHide.isHidden = false
            trashButtonToHide.setImage(UIImage(named: "Red Trash"), for: .normal)
        }else {
            deleteButtonToHide.isHidden = true
            removeAllButtonToHide.isHidden = true
            trashButtonToHide.setImage(UIImage(named: "Black Trash"), for: .normal)
        }
        setUIDependingOnMode()
        if navigationItem.searchController?.isActive == true {
            searching = true
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUIDependingOnMode()
        setUIDependingOnChosenLanguage()
        reloadData()
        trashButtonApperance()
        deleteButtonToHide.isHidden = true
        animationAfterLoading()
        createCreateCardButton ()
        if cards?.count != 0 {
            swipeActionImage.isHidden = false
        }else{
            swipeActionImage.isHidden = true
        }
        createSearchBar()
    }
    

    

    
    
    
    
    @IBOutlet weak var swipeActionImage: TransitionButton!
    @IBAction func swapAction(_ sender: Any) {
        
            swipeActionImage.startAnimation()

            for index in 0...self.selectedDeck.cards.count - 1{
                
                do {
                    try self.realm.write {
                        swap(&self.cards![index].frontalText, &self.cards![index].dorsalText)
                        swap(&self.cards![index].nameOfFrontalImage, &self.cards![index].nameOfDorsalImage)
                    }
                } catch let error as NSError {
                    print(error)
                }
            }
            
            
        
        swipeActionImage.stopAnimation(animationStyle: .normal) {
            
            self.collectionView.reloadData()
        }
    }
    

    
    @objc func createCardButtonTapped(sender: UIButton!) {

        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CreateCardViewController") as! CreateCardViewController
        vc.selectedDeck = selectedDeck

        vc.delegate = self
        vc.delegateTwo = self
        navigationController?.setNavigationBarHidden(true, animated: true)
        vc.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        navigationItem.searchController?.searchBar.isHidden = true
        vc.createCardForUI.setTitle(language?.create, for: .normal)
        self.addChild(vc)
        self.view.addSubview(vc.view)


    }

    
  
    
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if cards?.count != 0 {
            return cards!.count
        }else {
            return 0
        }
        
    }
    

    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Header", for: indexPath)
        nameOfDeckLabel = header.viewWithTag(789) as! UILabel
        nameOfDeckLabel?.adjustsFontSizeToFitWidth = true
        nameOfDeckLabel?.adjustsFontForContentSizeCategory = true
        nameOfDeckLabel?.text = nameOfDeck
        
        return header
    
    }
    
    
    
    
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        if trashButtonIsActive == true {
            if cards![indexPath.item].tickedToDelete == false {
                
                let  cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CardsCollectionViewCell
                cell.textToCell = cards![indexPath.item].frontalText
                cell.buttonToTrash.setImage(UIImage(named: "Rectangle Empty"), for: .normal)
                cell.dorsalText = cards![indexPath.item].dorsalText
                if cards![indexPath.item].nameOfFrontalImage != "" {
                    
                    cell.nameOfFrontalImage = cards![indexPath.item].nameOfFrontalImage
                }
                
                   cell.backgroundColor = UIColor(hexString: (mode?.cardsColor)!)
                cell.textOnCell.backgroundColor = UIColor(hexString: (mode?.cardsColor)!)
                cell.textOnCell.textColor = UIColor(hexString: (mode?.textColorOnCards)!)


                return cell
                
            }else if cards![indexPath.item].tickedToDelete == true {
                let  cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CardsCollectionViewCell
                cell.textToCell = cards![indexPath.item].frontalText
                cell.buttonToTrash.setImage(UIImage(named: "Rectangle Filled"), for: .normal)
                cell.dorsalText = cards![indexPath.item].dorsalText
                if cards![indexPath.item].nameOfFrontalImage != "" {
                    
                    cell.nameOfFrontalImage = cards![indexPath.item].nameOfFrontalImage
                    
                }
            cell.backgroundColor = UIColor(hexString: (mode?.cardsColor)!)
                cell.textOnCell.backgroundColor = UIColor(hexString: (mode?.cardsColor)!)
                cell.textOnCell.textColor = UIColor(hexString: (mode?.textColorOnCards)!)

                return cell
            }
            
        }else if trashButtonIsActive == false {
            
            
            
            
            let  cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CardsCollectionViewCell
            cell.textToCell = cards![indexPath.item].frontalText
            
            if cards![indexPath.item].nameOfFrontalImage != "" {


                cell.nameOfFrontalImage = cards![indexPath.item].nameOfFrontalImage
            }
            cell.dorsalText = cards![indexPath.item].dorsalText
      

            
            cell.backgroundColor = UIColor(hexString: (mode?.cardsColor)!)
            cell.textOnCell.backgroundColor = UIColor(hexString: (mode?.cardsColor)!)
            cell.textOnCell.textColor = UIColor(hexString: (mode?.textColorOnCards)!)
            cell.buttonToTrash.setImage(nil, for: .normal)
           
          
            
            return cell

        }

        
        let cellTwo = collectionView.dequeueReusableCell(withReuseIdentifier: "cell hello", for: indexPath)
        return cellTwo
        
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        indexSelected = cards![indexPath.item].order

        if trashButtonIsActive == true  &&  cards![indexPath.item].tickedToDelete == false{
            
            deleteButtonToHide.isHidden = false
            removeAllButtonToHide.isHidden = false
            trashButtonToHide.setImage(UIImage(named: "Red Trash"), for: .normal)
            



            let arrayTwo = cards![indexPath.item]
            try! realm.write {
                arrayTwo.tickedToDelete = true
            }

            
        }else if trashButtonIsActive == true &&  cards![indexPath.item].tickedToDelete == true {
            

            let arrayTwo = cards![indexPath.item]
            try! realm.write {
                arrayTwo.tickedToDelete = false
            }
            
        
        }else if trashButtonIsActive == false  {
            
       
            indexSelected = indexPath.item
           
            
            self.performSegue(withIdentifier: "cardView", sender: indexPath)
            
         }
        
        loadCards()
        trashButtonApperance()
        reloadData()

    }
    
 
    
    

    
    


    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "cardView" {
            if let cardViewController = segue.destination as? CardCollectionViewController {

                
                
                if searching == true {
                  
                  var indexToPass : Int? = nil
                  let cell = collectionView.cellForItem(at: IndexPath(item: indexSelected!, section: 0)) as! CardsCollectionViewCell
                    if indexToPass == nil {
                        for index in 0...cards!.count - 1 {
                            if cell.textOnCell.text == cards![index].frontalText && cell.dorsalText == cards![index].dorsalText  {
                                indexToPass = cards![index].order
                                cardViewController.indexInArray = indexToPass
                            }
                        }
                    }
                
                }else{
                    cardViewController.indexInArray = indexSelected
                    
                }
                
                cardViewController.selectedDeck = selectedDeck
                let backItem = UIBarButtonItem()
                backItem.title = language?.backForNavBar
                navigationItem.backBarButtonItem = backItem
                cardViewController.backToCards = self
                
      
       
                
                
            }
        }
    }
    

    
    func reloadData () {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    
    func untickAllCellsWhichHaveBeenSelected () {
        for index in cards!.count {
          
            let arrayTwo = cards![index]
            try! realm.write {
                arrayTwo.tickedToDelete = false
            }
            
        }
    }
    
    //Rearange
    
    
    
  
    
    func loadCards() {
        cards = selectedDeck?.cards.sorted(byKeyPath: "order", ascending: true)
    }

    func animationAfterLoading() {
        
        collectionView?.reloadData()
        collectionView?.performBatchUpdates({
            UIView.animate(views: self.collectionView!.orderedVisibleCells,
                           animations: animationAfterLoadingView, completion: {
                            
            })
        }, completion: nil)
        
    }
    

    
 
    func reloadDataDelegate() {
           
           if cards?.count != 0 {
               swipeActionImage.isHidden = false
           }else{
               swipeActionImage.isHidden = true
           }
           self.collectionView.reloadData()
           trashButtonApperance()
           
       }

    func recalculateCardsOrderProperty() {
        if cards?.count != 0 {
            let realm = try! Realm()
            for index in 0...cards!.count - 1 {
                
                let cardOrder = cards![index]
                try! realm.write {
                    cardOrder.order = index
                    
                }
                
            }
            
        }
        
        
    }
    
    func trashButtonApperance () {
        if cards?.count == 0 {
            trashButtonToHide.isHidden = true
        } else {
            trashButtonToHide.isHidden = false
            
            if selectedDeck.cards.filter("tickedToDelete = true").count == 0 {
                deleteButtonToHide.isEnabled = false
            }else  {
                deleteButtonToHide.isEnabled = true
            }
        }
        
    }
    

    
    
    



}

extension CardsInDeckCollectionViewController : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("Search bar is working")
        if searchText.count == 0 {
            loadCards()
            collectionView.reloadData() //
        }else{
            cards = selectedDeck.cards.filter("frontalText BEGINSWITH[c] %@", searchText)
        }

        searching = true
        collectionView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        loadCards()
        collectionView.reloadData()
        print("Canceled")

    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searching = false
        if searchBar.text!.count != 0 {
           cards = selectedDeck.cards.filter("frontalText BEGINSWITH[c] %@", searchBar.text)
        }else{
            loadCards()
            collectionView.reloadData()
        }

        print("DidEndEditing")
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        loadCards()
        searching = false
        collectionView.reloadData() //

    }
    
    
    
    
    
}

extension CardsInDeckCollectionViewController {
    
     func setUIDependingOnMode () {
            
            
            if UserDefaults.standard.value(forKeyPath: "ChosenMode") == nil {
                UserDefaults.standard.set(0, forKey: "Dark mode by default")
            }
            
            indexOfChosenMode = UserDefaults.standard.value(forKey: "ChosenMode") != nil ?  UserDefaults.standard.value(forKeyPath: "ChosenMode" ) as? Int : UserDefaults.standard.value(forKey : "Dark mode by default" ) as? Int
            
            mode = Mode.fetchModes()[indexOfChosenMode!]
            
            collectionOfViews.backgroundColor = UIColor(hexString: (mode?.backGroundForCards)!)
            swipeActionImage.setImage(UIImage(named: (mode?.imageSwapAction)!), for: .normal)
             navigationController?.navigationBar.barTintColor = UIColor(hexString: (mode?.navBarColor)!)
 
            
      
            
        }
        
        func setUIDependingOnChosenLanguage () {
            
            var index : Int?
            
            
            
            
            if UserDefaults.standard.value(forKey: "ChosenLanguage") != nil {
                index = UserDefaults.standard.value(forKey: "ChosenLanguage") as? Int
            }else {
                index = UserDefaults.standard.value(forKey:  "Language by default") as? Int
            }
            
            print("Index is \(index!)")
            
            language = Language.fetchLanguages()[index!]
            
            deleteButtonToHide.setTitle(language?.buttonDelete, for: .normal)
            removeAllButtonToHide.setTitle(language?.buttonRemoveAll, for: .normal)
           
            
        }
}

extension CardsInDeckCollectionViewController {
    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
          
          var canIshake : Bool?
          if UserDefaults.standard.value(forKeyPath: "ChosenShake") == nil {
              canIshake = true
          }
          if UserDefaults.standard.value(forKey: "ChosenShake") != nil {
              var someIndex : Int?
              someIndex = UserDefaults.standard.value(forKeyPath: "ChosenShake" ) as? Int
              if someIndex == 0 {
                  canIshake = false
              }else if someIndex == 1 {
                  canIshake = true
              }
          }
          if selectedDeck.cards.count >= 2 && canIshake == true {
              if event?.subtype == UIEvent.EventSubtype.motionShake {
                  var arrayForShufling = [Int]()
                  for number in 0...selectedDeck.cards.count - 1 {
                      arrayForShufling.append(number)
                  }
                  arrayForShufling.shuffle()
                  for index in 0...selectedDeck.cards.count - 1 {
                      
                      do {
                          try realm.write {
                              selectedDeck.cards[index].order = arrayForShufling[index]
                          }
                      }catch let error as NSError{
                          print(error)
                      }
                  }
                  loadCards()
                  self.collectionView.reloadData()
                  let arrayOfDifferentAnimations = ["up" , "down" , "right" , "left"]
                  AnimatableReload.reload(collectionView: self.collectionOfViews, animationDirection: arrayOfDifferentAnimations[Int.random(in: 0...3)])
                  
              }
          }
      }
}

extension CardsInDeckCollectionViewController : ReloadDataDelegate , ReloadImageDelegate , BackToCardsInDeck {
    func backtoCardInDeck(lastIndex: Int) {
         
         if navigationItem.searchController?.isActive == false{
             self.collectionView.scrollToItem(at:IndexPath(item: lastIndex, section: 0), at: .bottom, animated: false)
         }
         
     }
     
     func updateImageDelegate() {
         
         navigationItem.searchController?.searchBar.isHidden = false
         navigationController?.setNavigationBarHidden(false, animated: true)
         
     }
}


extension  CardsInDeckCollectionViewController {
    
    override func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
            
            try! realm.write {
                let sourceObject = cards![sourceIndexPath.item]
                let destinationObject = cards![destinationIndexPath.item]
                let destinationObjectOrder = destinationObject.order
                
                if sourceIndexPath.item < destinationIndexPath.item {
                    for index in sourceIndexPath.item ... destinationIndexPath.item {
                        let object = cards![index]
                        object.order -= 1
                    }
                }else {
                    for index in (destinationIndexPath.item ..< sourceIndexPath.item).reversed(){
                        let object = cards![index]
                        object.order += 1
                        
                       
                        
                        
                    }
                }
                
                sourceObject.order = destinationObjectOrder
                
                cards = selectedDeck?.cards.sorted(byKeyPath: "order", ascending: true)

            }

          
        }
        
        override func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
            if searching == true {
                return  false
            }else{
                return true
            }

        }
    
}


extension CardsInDeckCollectionViewController {
        func createSearchBar() {
            
            
            if #available(iOS 11.0, *) {
                let sc = UISearchController(searchResultsController: nil)
                sc.delegate = self
                sc.searchBar.delegate = self
                self.definesPresentationContext = true
                
                
                //
                let scb = sc.searchBar
                scb.tintColor = UIColor.white
                scb.barTintColor = UIColor.white
                
                if let textfield = scb.value(forKey: "searchField") as? UITextField {
                    textfield.textColor = UIColor.blue
                    if let backgroundview = textfield.subviews.first {
                        
                        // Background color
                        backgroundview.backgroundColor = UIColor.white
                        
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
    func createCreateCardButton () {

        let button = UIButton(frame: CGRect(x: 300, y: 590, width: 69, height: 69))


        button.setImage(UIImage(named: "add card button"), for: .normal)
        button.addTarget(self, action: #selector(createCardButtonTapped), for: .touchUpInside)
        button.setImage(UIImage(named: (mode?.addCardButton)!), for: .normal)
   
        
        self.view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -6),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -8),
            button.widthAnchor.constraint(equalToConstant: 69),
            button.heightAnchor.constraint(equalToConstant: 69)
            
            
            ])
    }

}

extension Int: Sequence {
    public func makeIterator() -> CountableRange<Int>.Iterator {
        return (0..<self).makeIterator()
    }
}







