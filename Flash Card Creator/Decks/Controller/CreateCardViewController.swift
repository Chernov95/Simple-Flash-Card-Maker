//
//  MiniViewController.swift
//  Flash Card Creator
//
//  Created by Filip Cernov on 09/05/2019.
//  Copyright © 2019 Filip Cernov. All rights reserved.
//

import UIKit
import RealmSwift
import MobileCoreServices
import WXImageCompress
import TransitionButton
import KRProgressHUD

protocol ReloadDataDelegate : class {
    
    func reloadDataDelegate ()
    
}

protocol ReloadImageDelegate : class {
    
    func updateImageDelegate ()
    
}

protocol UpdateCardAfterEditing : class {
    func backToCard (editingFinished : Bool)
}

private let nameOfDefaultImage = "default"

class CreateCardViewController: UIViewController ,UITextViewDelegate  {
    
    
    lazy var realm : Realm = {
          return try! Realm()
    }()
    var language : Language?
    var mode :  Mode?
    var indexForMode : Int?
    var isItEditing : Bool?
    var indexForSavingInRealm = Int()
    
    
    
    var selectedDeck : Deck! {
        didSet {

            cards = selectedDeck?.cards.sorted(byKeyPath: "order", ascending: true)
            
        }
    }
    var cards : Results<Array>?
    
    
    var newPicture : Bool?
    
  

    var numberOfPressedButton : Int?
    var wordAddedInDifferentLanguage = ""
    
    weak var updateCardAfterEditing : UpdateCardAfterEditing?
    weak var delegate : ReloadDataDelegate?
    weak var delegateTwo : ReloadImageDelegate?
    
    
    @IBOutlet weak var popup: UIVisualEffectView!
    @IBOutlet weak var wrongButtonForUI: UILabel!
    @IBOutlet weak var provideInfoForUI: UILabel!
    @IBOutlet weak var createCardForUI: TransitionButton!
    @IBOutlet weak var gotItButtonForUI: UIButton!
    @IBOutlet weak var frontalSideForUI: UILabel!
    @IBOutlet weak var dorsalSideForUI: UILabel!
    @IBOutlet weak var frontalTextFiev: UITextView!
    @IBOutlet weak var dorsalTextView: UITextView!
    @IBOutlet weak var dorsalImage: UIButton!
    @IBOutlet weak var frontalImage: UIButton!
    @IBOutlet weak var miniView: UIView!
    
    
    
    
    @IBAction func gotIt(_ sender: UIButton) {
        
        popup.alpha = 0
        
        
    }
   
    

    
    
   
    @IBOutlet weak var DeleteButtonFromSelectedOneToHide: UIButton!
    @IBAction func DeleteButtonFromSelectedOne(_ sender: UIButton) {
        
        DeleteButtonFromSelectedOneToHide.isHidden = true
        frontalImage.setImage(UIImage(named: "default"), for: .normal)
        
    }
    
    @IBOutlet weak var DeleteButtonFromSelectedTwoToHide: UIButton!
    @IBAction func DeleteButtonFromSelectedTwo(_ sender: UIButton) {
        
        DeleteButtonFromSelectedTwoToHide.isHidden = true
        dorsalImage.setImage(UIImage(named: "default"), for: .normal)

    }
    
    @IBAction func chooseFirstImage(_ sender: UIButton) {
        if frontalImage.imageView?.image == UIImage(named: "default") {
            choosePhoto()
            numberOfPressedButton = 1
        }

        
        
    }
    @IBAction func chooseSecondImage(_ sender: UIButton) {
        if dorsalImage.imageView?.image == UIImage(named: "default") {
            choosePhoto()
            numberOfPressedButton = 2
        }
        
    }
    
    
    
    
    
    
    
  
    @IBAction func closeButton(_ sender: UIButton) {
 
        self.removeFromParent()
        self.view.removeFromSuperview()
        updateCardAfterEditing?.backToCard(editingFinished: false)
        delegateTwo?.updateImageDelegate()
 
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        frontalTextFiev.delegate = self
        dorsalTextView.delegate = self
        loadFromRealm()
        setUIDependingOnChosenLanguage()
        setUIDependingOnMode()
        popup.alpha = 0
        setUIAfterOpeningCreateCardViewControllerOrAfterAddingNewCard()
        
       
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
   
    }
    
 
   
 
    @IBAction func createButton(_ sender: UIButton) {
        
        
        
        if frontalTextFiev.text == "" && frontalImage.imageView?.image == UIImage(named: nameOfDefaultImage)   || dorsalTextView.text == "" && dorsalImage.imageView?.image == UIImage(named: nameOfDefaultImage) {
            if frontalTextFiev.text == "" && frontalImage.imageView?.image == UIImage(named: nameOfDefaultImage) && dorsalTextView.text == "" && dorsalImage.imageView?.image == UIImage(named: nameOfDefaultImage) {
                 provideInfoForUI.text = language?.noInformationProvided
            }else{
                if frontalTextFiev.text == "" && frontalImage.imageView?.image == UIImage(named: nameOfDefaultImage) {
                    provideInfoForUI.text = language?.frontSideIsEmpty
                }else if dorsalTextView.text == "" && dorsalImage.imageView?.image == UIImage(named: nameOfDefaultImage) {
                    provideInfoForUI.text = language?.backSideIsEmtpy
                }
                 provideInfoForUI.adjustsFontSizeToFitWidth = true
            }
        
            popupShow()

   
        }else {

            if isItEditing != true {
         
                if let currentDeck = self.selectedDeck {
                    do{
                        try self.realm.write {
                            let newItem = Array()
                            newItem.frontalText = frontalTextFiev.text!
                            newItem.dorsalText = dorsalTextView.text!
                            newItem.order = selectedDeck.cards.count
                            
                            
                            if frontalImage.imageView?.image != UIImage(named: nameOfDefaultImage) && frontalImage.image(for: .normal) != UIImage(named: nameOfDefaultImage) {
                                let randomString = String.random()
                                newItem.nameOfFrontalImage = randomString
                                
                                saveImage(imageName: randomString, image: frontalImage.imageView!.image!)
                                
                            }
                            
                            if dorsalImage.imageView?.image != UIImage(named: nameOfDefaultImage) && dorsalImage.image(for: .normal) != UIImage(named: nameOfDefaultImage)  {
                                let randomString = String.random()
                                
                                newItem.nameOfDorsalImage = randomString
                                saveImage(imageName: randomString, image: dorsalImage.imageView!.image!)
                                
                            }
                            
                            currentDeck.cards.append(newItem)
                            
                            delegate?.reloadDataDelegate()
                        }
                        
                        
                    }catch{
                        print("Error saving new items , \(error)")
                    }
                    
                }
                
                frontalTextFiev.text = ""
                dorsalTextView.text = ""
                KRProgressHUD.showImage(UIImage(named : "progresshud-success")!, size: nil, message: wordAddedInDifferentLanguage)
                setUIAfterOpeningCreateCardViewControllerOrAfterAddingNewCard()
                
            }
            
            if isItEditing == true {
                
               createCardForUI.startAnimation()
                
          
                
                
                
               do  {
                    try realm.write {
                        //!!!!!!!Тут проверку на пустое название сделать нужно будет!
                        
                      
                        
                        cards![indexForSavingInRealm].frontalText = frontalTextFiev.text
                        cards![indexForSavingInRealm].dorsalText = dorsalTextView.text
                        if frontalImage.imageView?.image == UIImage(named: nameOfDefaultImage) &&  cards![indexForSavingInRealm].nameOfFrontalImage != "" {
                            Helper.removePhoto(imageName:  cards![indexForSavingInRealm].nameOfFrontalImage)
                            cards![indexForSavingInRealm].nameOfFrontalImage = ""
                        }
                        if frontalImage.imageView?.image != UIImage(named: nameOfDefaultImage)  {
                            
                           
                            Helper.removePhoto(imageName: cards![indexForSavingInRealm].nameOfFrontalImage)
                                let randomString = String.random()
                                saveImage(imageName: randomString, image: frontalImage.imageView!.image!)
                            cards![indexForSavingInRealm].nameOfFrontalImage = randomString
                               
                
                        }
                        
                        if dorsalImage.imageView?.image == UIImage(named: nameOfDefaultImage) && cards![indexForSavingInRealm].nameOfDorsalImage != "" {
                            Helper.removePhoto(imageName: cards![indexForSavingInRealm].nameOfDorsalImage)
                            cards![indexForSavingInRealm].nameOfDorsalImage = ""
                        }
                        if dorsalImage.imageView?.image != UIImage(named: nameOfDefaultImage)  {
                            
                          
                            Helper.removePhoto(imageName: cards![indexForSavingInRealm].nameOfDorsalImage)
                                let randomString = String.random()
                                saveImage(imageName: randomString, image: dorsalImage.imageView!.image!)
                            cards![indexForSavingInRealm].nameOfDorsalImage = randomString
                                
                            
                            
                            
                            
                            
                        }
                

              
                        
                        
                    }
                } catch let error as NSError {
                    print(error)
                }
                
                    print("I saved in index \(indexForSavingInRealm)")
                    createCardForUI.stopAnimation(animationStyle: .normal) {
                    self.updateCardAfterEditing?.backToCard(editingFinished: true)
                    self.removeFromParent()
                    self.view.removeFromSuperview()
                }
                
                
                
            }
            
            
      
      
            
            

            
            
            
        }
        
  
        
    }
    
    func loadFromRealm() {
        cards = realm.objects(Array.self)
    }
    
    func save (item : Array) {
        do {
            try realm.write {
                realm.add(item)
                delegate?.reloadDataDelegate()
                
            }
        }catch {
            print("Error saving context\(error)")
        }
  
    }
    
  
    func setUIAfterOpeningCreateCardViewControllerOrAfterAddingNewCard () {
        DeleteButtonFromSelectedOneToHide.isHidden = true
        DeleteButtonFromSelectedTwoToHide.isHidden = true
        frontalImage.setImage(UIImage(named: nameOfDefaultImage), for: .normal)
        dorsalImage.setImage(UIImage(named: nameOfDefaultImage), for: .normal)
    }
    

    
    func popupShow() {
        popup.transform = CGAffineTransform(scaleX: 0.3, y: 2)
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0, options: .allowUserInteraction, animations: {
            self.popup.transform = .identity
        }) { (succes) in
            
        }
        
        popup.alpha = 1
       
    }
    


}

extension CreateCardViewController : UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    func choosePhoto () {
        
        //Alert
        let myAlert = UIAlertController(title: language?.selectImageFrom, message: " ", preferredStyle: .actionSheet)
        //Button in Allert and what it does(from camera)
        let cameraAction = UIAlertAction(title: language?.camera, style: .default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerController.SourceType.camera
                imagePicker.mediaTypes = [kUTTypeImage as String]
                imagePicker.allowsEditing = false
                self.present(imagePicker , animated: true , completion: nil)
                self.newPicture = true
                
            }
        }
        
        //Button in Allert and what it does (from album)
        let cameraRollAction = UIAlertAction(title: language?.cameraRoll, style: .default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
                imagePicker.mediaTypes = [kUTTypeImage as String]
                imagePicker.allowsEditing = false
                self.present(imagePicker , animated:  true , completion:  nil)
                self.newPicture = false
            }
        }
        
        // Cancel Button
        let cancelAction = UIAlertAction(title: language?.cancel, style: .cancel, handler: nil)
        cancelAction.setValue(UIColor.red, forKey: "titleTextColor")
        
        
        myAlert.addAction(cameraAction)
        myAlert.addAction(cameraRollAction)
        myAlert.addAction(cancelAction)
        self.present(myAlert , animated: true)
        
    }
}

extension CreateCardViewController {
    func setUIDependingOnMode () {
        
        
        if UserDefaults.standard.value(forKeyPath: "ChosenMode") == nil {
            UserDefaults.standard.set(0, forKey: "Dark mode by default")
        }
        
        if UserDefaults.standard.value(forKey: "ChosenMode") != nil {
            indexForMode = UserDefaults.standard.value(forKeyPath: "ChosenMode" ) as? Int
        } else {
            indexForMode = UserDefaults.standard.value(forKey : "Dark mode by default" ) as? Int
        }
        
        mode = Mode.fetchModes()[indexForMode!]
        miniView.backgroundColor = UIColor(hexString: (mode?.backgroundForMiniView)!)
        
    }
    
    func setUIDependingOnChosenLanguage () {
        
        var index : Int?
        
        
        
        
        if UserDefaults.standard.value(forKey: "ChosenLanguage") != nil {
            index = UserDefaults.standard.value(forKey: "ChosenLanguage") as? Int
        }else {
            index = UserDefaults.standard.value(forKey:  "Language by default") as? Int
        }
        

        
        language = Language.fetchLanguages()[index!]
        
        wrongButtonForUI.text = language?.wrong
        gotItButtonForUI.setTitle(language?.gotIt, for: .normal)
        frontalSideForUI.text = language?.front
        dorsalSideForUI.text = language?.back
        wordAddedInDifferentLanguage = language!.added

        createCardForUI.titleLabel?.font = UIFont(descriptor: UIFontDescriptor(name: "System Heavy", size: 28), size: 28)
     
       

        
        
    }
}

extension CreateCardViewController {
    
    func saveImage(imageName: String , image : UIImage) {
        if  image != UIImage(named: nameOfDefaultImage) {
            let fileManager = FileManager.default
            let imagePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(imageName)
            let newImage = image.wxCompress()
            let data = newImage.jpegData(compressionQuality: 1)
            fileManager.createFile(atPath: imagePath as String, contents: data, attributes: nil)
        }

    }
    
    func getImage(imageName: String ) -> UIImage {
        if imageName != "" {
            let fileManager = FileManager.default
            let imagePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(imageName)
            if fileManager.fileExists(atPath: imagePath){
                let image = UIImage(contentsOfFile: imagePath)
                image?.jpegData(compressionQuality: 1)
                return image!
            }
        }
        
        return UIImage()
    }
    

    
}


extension CreateCardViewController {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let mediaType = info[UIImagePickerController.InfoKey.mediaType] as! NSString
        if mediaType.isEqual(to: kUTTypeImage as String) {
            let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
            
            if numberOfPressedButton == 1 {
                
                frontalImage.setImage(image, for: .normal)
                frontalImage.isEnabled = true
                numberOfPressedButton = nil
                DeleteButtonFromSelectedOneToHide.isHidden = false
                

                
            }else if numberOfPressedButton == 2 {
                
                dorsalImage.setImage(image, for: .normal)
                dorsalImage.isEnabled = true
                numberOfPressedButton = nil
                DeleteButtonFromSelectedTwoToHide.isHidden = false

            }
            
            
            
            
            
            
            if newPicture == true {
                UIImageWriteToSavedPhotosAlbum(image, self, #selector(imageError), nil)
            }
            
            
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func imageError(image : UIImage , didFinishSavingWithError error : NSErrorPointer , contextInfo : UnsafeRawPointer ) {
        if error != nil {
            let alert = UIAlertController(title: language?.saveFailed, message: language?.failedToSaveImage, preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(cancelAction)
            self.present(alert , animated: true , completion: nil)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}







