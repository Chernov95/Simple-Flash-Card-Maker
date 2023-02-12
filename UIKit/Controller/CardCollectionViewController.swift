//
//  CardCollectionViewController.swift
//  Flash Card Creator
//
//  Created by Filip Cernov on 11/06/2019.
//  Copyright © 2019 Filip Cernov. All rights reserved.
//

import UIKit
import RealmSwift
import AnimatedCollectionViewLayout
import TransitionButton

private let reuseIdentifier = "Cell"

protocol BackToCardsInDeck : class {
    func backtoCardInDeck (lastIndex : Int)
}



class CardCollectionViewController: UICollectionViewController {

    
    lazy var realm : Realm = {
           return try! Realm()
    }()
    var language : Language?
    var mode :  Mode?
    var indexInArray : Int?
    var indexForMode : Int?
    var currentIndexOfCardDependingOnRealm : Int?
    var numberOfFinishedScrollments = 0 //On third scroll I want to ask user to rate the app
    var cards : Results<Array>?
    var selectedDeck : Deck! {
        didSet{
            cards = selectedDeck?.cards.sorted(byKeyPath: "order", ascending: true)
        }
    }
    var animator : (LayoutAttributesAnimator, Bool, Int, Int)?
    var direction: UICollectionView.ScrollDirection = .horizontal
    var wordForProgressLabel : String?
    var numberOfCardOnLabel : Int?
    weak var backToCards : BackToCardsInDeck?
    let defaults = UserDefaults.standard
    let reviewService = ReviewService.shared
    
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var swapActionToSetImage: TransitionButton!
    @IBOutlet weak var editCardButtonForUI: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        setUIDependingOnChosenLanguage()
    }
    
      override func viewDidLoad() {
          super.viewDidLoad()
          
          loadFromRealm()
          setUIDependingOnChosenLanguage()
          setupOfFrameworkForAnimation()
          if indexInArray != 0 {
              
              self.collectionView.scrollToItem(at:IndexPath(item: indexInArray!, section: 0), at: .right, animated: false)
              
          }
          indexInArray = indexInArray! + 1
          progressLabel.text = "\(indexInArray!) \(wordForProgressLabel!) \(cards!.count)"
          numberOfCardOnLabel = indexInArray
          setUIDependingOnMode()
          
         
       
    
      }
    
    @IBAction func editCardButton(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CreateCardViewController") as! CreateCardViewController
        if let numberOfCard = numberOfCardOnLabel {
            vc.indexForSavingInRealm = numberOfCard - 1
        }
        vc.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        vc.selectedDeck = selectedDeck
        
        vc.frontalTextFiev.text = cards![numberOfCardOnLabel! - 1].frontalText
        vc.dorsalTextView.text = cards![numberOfCardOnLabel! - 1].dorsalText
        
        vc.isItEditing = true
        if cards![numberOfCardOnLabel! - 1].nameOfFrontalImage != "" {
            setImage(imageName: cards![numberOfCardOnLabel! - 1].nameOfFrontalImage, imageView: vc.frontalImage)
            vc.DeleteButtonFromSelectedOneToHide.isHidden = false
        }
        if cards![numberOfCardOnLabel! - 1].nameOfDorsalImage != "" {
            setImage(imageName: cards![numberOfCardOnLabel! - 1].nameOfDorsalImage, imageView: vc.dorsalImage)
            vc.DeleteButtonFromSelectedTwoToHide.isHidden = false
        }
        
        vc.updateCardAfterEditing = self
        vc.createCardForUI.setTitle(language?.nameOfButtonForEditing, for: .normal)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        self.addChild(vc)
        self.view.addSubview(vc.view)
        print("Index is \(vc.indexForSavingInRealm)")
        
    }
    
    

    @IBAction func swapAction(_ sender: Any) {
        swapActionToSetImage.startAnimation()
       
        if currentIndexOfCardDependingOnRealm == nil {
            currentIndexOfCardDependingOnRealm = indexInArray! - 1
            print("Done nil \(indexInArray! - 1)")
        }
        
        let pastCell = collectionView.cellForItem(at: IndexPath(item: currentIndexOfCardDependingOnRealm!, section: 0)) as? CardCollectionViewCell
        if pastCell!.flippedCard == true  {
            pastCell!.turnCard()
            print("Done")
        }
        
        for index in 0...selectedDeck.cards.count - 1{
            
            do {
                try realm.write {
                    swap(&cards![index].frontalText, &cards![index].dorsalText)
                    swap(&cards![index].nameOfFrontalImage, &cards![index].nameOfDorsalImage)
                }
            } catch let error as NSError {
                print(error)
            }
        }
        
        
        
        
        swapActionToSetImage.stopAnimation(animationStyle: .normal) {
            self.collectionView.reloadData()
        }
    }
    

    
    func loadFromRealm() {

        cards = selectedDeck?.cards.sorted(byKeyPath: "order", ascending: true)

    }
    
    
    

    
    func setupOfFrameworkForAnimation () {
        animator = (LinearCardAttributesAnimator(), false, 1, 1)
        collectionView?.isPagingEnabled = true
        if let layout = collectionView?.collectionViewLayout as? AnimatedCollectionViewLayout {
            layout.scrollDirection = direction
            layout.animator = animator?.0
        }
        
       

    }
    
    func setImage(imageName: String , imageView : UIButton){
        if imageName != "" {
            let fileManager = FileManager.default
            let imagePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(imageName)
            if fileManager.fileExists(atPath: imagePath){
                imageView.setImage(UIImage(contentsOfFile: imagePath), for: .normal)
            }else{
                print("Panic! No Image!")
            }
        }
        
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


extension CardCollectionViewController : UpdateCardAfterEditing {
    
    func backToCard(editingFinished : Bool) {
        if editingFinished {
               self.collectionView.reloadData()
        }
        
        navigationController?.setNavigationBarHidden(false, animated: false)

    }
    
}

extension CardCollectionViewController {
    
     override func numberOfSections(in collectionView: UICollectionView) -> Int {
        
         return 1
     }


     override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      
         return cards!.count
     }
     

     override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         
         
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CardCollectionViewCell
         cell.frontalText.text = cards![indexPath.item].frontalText
         cell.dorsalText.text = cards![indexPath.item].dorsalText
         cell.frontalView.backgroundColor = UIColor(hexString: (mode?.backgroundInCardCollectionViewController)!)
         cell.dorsalView.backgroundColor = UIColor(hexString: (mode?.backgroundInCardCollectionViewController)!)
         if cards![indexPath.item].nameOfFrontalImage != "" {
             cell.nameOfFrontalImage = cards![indexPath.item].nameOfFrontalImage
         }
         if cards![indexPath.item].nameOfDorsalImage != ""{
             cell.nameOfDorsalImage = cards![indexPath.item].nameOfDorsalImage
         }
         cell.clipsToBounds = false
         cell.frontalText.textColor = UIColor(hexString: (mode?.textColorOnCards)!)
         cell.dorsalText.textColor = UIColor(hexString: (mode?.textColorOnCards)!)

         return cell
         
         
     }
     
     
}

extension CardCollectionViewController : UICollectionViewDelegateFlowLayout {
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let visibleIndex = Int(targetContentOffset.pointee.x / collectionView.frame.width)
        currentIndexOfCardDependingOnRealm = visibleIndex
        
        progressLabel.text = "\(visibleIndex + 1) \(wordForProgressLabel!) \(cards!.count)"
      
        numberOfCardOnLabel = visibleIndex + 1
        print("Number Of Card On Label is \(numberOfCardOnLabel!)")
        
        if visibleIndex != 0 {
            if let pastCell = collectionView.cellForItem(at: IndexPath(item: visibleIndex - 1, section: 0)) as? CardCollectionViewCell {
                if pastCell.flippedCard == true{
                    pastCell.turnCard()
                }
            }
            
        }
        
        if visibleIndex != cards!.count - 1 {
            if let nextCell = collectionView.cellForItem(at: IndexPath(item: visibleIndex + 1, section: 0)) as? CardCollectionViewCell {
                if nextCell.flippedCard == true{
                    nextCell.turnCard()
                }
            }
        }
        
        backToCards?.backtoCardInDeck(lastIndex: visibleIndex)
       
    
        if numberOfFinishedScrollments != 2 {
            numberOfFinishedScrollments = numberOfFinishedScrollments + 1
        }

        if numberOfFinishedScrollments == 2 {
            let deadline = DispatchTime.now() + .seconds(2)
            DispatchQueue.main.asyncAfter(deadline: deadline) {
                [weak self] in self?.reviewService.requestReview()
            }

        }

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let animator = animator else { return view.bounds.size }
        return CGSize(width: view.bounds.width / CGFloat(animator.2), height: view.bounds.height / CGFloat(animator.3))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

}


extension CardCollectionViewController {
    
    
    func setUIDependingOnMode () {
        
        
        if UserDefaults.standard.value(forKeyPath: "ChosenMode") == nil {
            UserDefaults.standard.set(0, forKey: "Dark mode by default")
        }
        
        indexForMode = UserDefaults.standard.value(forKey: "ChosenMode") != nil ? UserDefaults.standard.value(forKeyPath: "ChosenMode" ) as? Int : UserDefaults.standard.value(forKey : "Dark mode by default" ) as? Int
        
        mode = Mode.fetchModes()[indexForMode!]
        swapActionToSetImage.setImage(UIImage(named: (mode?.imageSwapAction)!), for: .normal)
        collectionView.backgroundView?.backgroundColor =  UIColor(hexString: (mode?.backgroundForCardsinCardViewController)!)
        addingCustomStatusBar(color: UIColor(hexString: (mode?.navBarColor)!))
        
        
        
    }
    
    
      func setUIDependingOnChosenLanguage () {
          
         
         let index = UserDefaults.standard.value(forKey: "ChosenLanguage") != nil ? UserDefaults.standard.value(forKey: "ChosenLanguage") as? Int : UserDefaults.standard.value(forKey:  "Language by default") as? Int
          
      
          
          language = Language.fetchLanguages()[index!]
          wordForProgressLabel = language?.counter
          
          

      }
}






