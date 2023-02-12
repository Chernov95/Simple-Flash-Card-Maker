//
//  CardCollectionViewCell.swift
//  Flash Card Creator
//
//  Created by Filip Cernov on 11/06/2019.
//  Copyright © 2019 Filip Cernov. All rights reserved.
//

import UIKit


class CardCollectionViewCell: UICollectionViewCell {
    
    var fromView : UIView?
    var toView : UIView?
    var flippedCard = false
    var nameOfFrontalImage : String?{
        didSet{
            if nameOfFrontalImage != nil {
                 getImage(imageName: nameOfFrontalImage!, imageView: frontalImage)
            }
           
        }
    }
    
    var nameOfDorsalImage : String?{
        didSet{
            if nameOfDorsalImage != nil{
                getImage(imageName: nameOfDorsalImage!, imageView: dorsalImage)
            }
            
        }
    }
    
    

    @IBOutlet weak var dorsalView: UIView!
    @IBOutlet weak var frontalView: UIView!
    @IBOutlet weak var frontalText: UILabel!
    @IBOutlet weak var dorsalText: UILabel!
    @IBOutlet weak var frontalImage: UIImageView!
    @IBOutlet weak var dorsalImage: UIImageView!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
      
     
        frontalText.font = optimisedfindAdaptiveFontWithName(fontName: "Avenir", label: frontalText, minSize: 1, maxSize: 32)
        frontalText.numberOfLines = 0
        dorsalText.font = optimisedfindAdaptiveFontWithName(fontName: "Avenir", label: dorsalText, minSize: 1, maxSize: 32)
        dorsalText.numberOfLines = 0
        
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
       
        frontalImage.image = nil
        dorsalImage.image = nil
        dorsalText.text = nil
        frontalText.text = nil

        
    }
    
    
    
    
    
    @IBAction func reverse(_ sender: Any) {
        
        if flippedCard == true {
            flippedCard = false
        } else {
            flippedCard = true
        }

        if flippedCard == true {
            fromView = dorsalView
            toView = frontalView
            UIView.transition(from: toView!, to: fromView!, duration: 0.5, options: [.transitionFlipFromRight , .showHideTransitionViews])
        } else {
            fromView = frontalView
            toView = dorsalView
            UIView.transition(from: toView!, to: fromView!, duration: 0.5, options: [.transitionFlipFromLeft , .showHideTransitionViews])
        }
        
        

        
        
    }
    
    
    func turnCard() {
           
           if flippedCard == true{
               UIView.transition(from: dorsalView, to: frontalView, duration: 0, options: [.transitionFlipFromLeft , .showHideTransitionViews])
               flippedCard = false
           }
           
           
       }
       
       
    
       
       
       func getImage(imageName: String , imageView : UIImageView){
           if imageName != "" {
               let fileManager = FileManager.default
               let imagePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(imageName)
               if fileManager.fileExists(atPath: imagePath){
                   imageView.image = UIImage(contentsOfFile: imagePath)
               }else{
                   print("Panic! No Image!")
               }
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
            if(difference > 0){
                tempMin = testedSize
            }else{
                tempMax = testedSize
            }
        }
        
        
        //returning the size -1 (to have enought space right and left)
        return UIFont(name: fontName, size: tempMin - 1)
    }
    

}













