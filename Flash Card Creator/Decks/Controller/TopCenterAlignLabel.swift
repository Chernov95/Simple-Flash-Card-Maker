//
//  TopCenterAlignLabel.swift
//  Flash Card Creator
//
//  Created by Filip Cernov on 25/06/2019.
//  Copyright © 2019 Filip Cernov. All rights reserved.
//

import UIKit



class TopCenterAlignLabel: UILabel {
    

    
    

    override func drawText(in rect:CGRect) {
        guard let labelText = text else {  return super.drawText(in: rect) }
        
        let attributedText = NSAttributedString(string: labelText, attributes: [NSAttributedString.Key.font: font])
        var newRect = rect
        newRect.size.height = attributedText.boundingRect(with: rect.size, options: .usesLineFragmentOrigin, context: nil).size.height
        
        if numberOfLines != 0 {
            newRect.size.height = min(newRect.size.height, CGFloat(numberOfLines) * font.lineHeight)
        }
        
        super.drawText(in: newRect)
    }
    
    
    
    
    
    
    
    
    

}

