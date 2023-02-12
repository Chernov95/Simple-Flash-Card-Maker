//
//  CollectionViewCell.swift
//  Flash Card Creator
//
//  Created by Filip Cernov on 16/04/2019.
//  Copyright © 2019 Filip Cernov. All rights reserved.
//

import UIKit




class CardsCollectionViewCell: UICollectionViewCell {
    
    
    
    var dorsalText : String?
    var textToCell : String! {
          didSet {
              self.textOnCell.text = textToCell
              self.setNeedsLayout()
              }
      }
      var nameOfFrontalImage : String?{
          didSet{
              if nameOfFrontalImage != nil{
                  
                  getImage(imageName: nameOfFrontalImage!)
                  
              }
          }
      }
    
  
    @IBOutlet weak var buttonToTrash: UIButton!
    @IBOutlet weak var imageOnCell: UIImageView!
    @IBOutlet weak var textOnCell: UITextView!
    
    
    
    

    
  
    

    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageOnCell.image = nil
        buttonToTrash.setImage(nil, for: .normal)
    }
    

    


    
}

extension CardsCollectionViewCell{
    func getImage(imageName: String )  {
        
        DispatchQueue.global(qos: .default).async(execute: {
            if imageName != "" {
                let fileManager = FileManager.default
                let imagePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(imageName)
                if fileManager.fileExists(atPath: imagePath){
                    let image = UIImage(contentsOfFile: imagePath)
                    
                    image?.jpegData(compressionQuality: 1)
                    DispatchQueue.main.async(execute: { 
                        
                        self.imageOnCell.image = image
                    })
                    
                    
                }
            }
            
            
        })
       

        
    }
    
    
}



