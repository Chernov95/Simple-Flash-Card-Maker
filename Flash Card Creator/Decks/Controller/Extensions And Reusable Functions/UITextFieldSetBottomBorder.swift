//
//  UITextFieldSetBottomBorder.swift
//  Flash Card Creator
//
//  Created by Filip Cernov on 21/09/2019.
//  Copyright © 2019 Filip Cernov. All rights reserved.
//

import Foundation




extension UITextField {
    func setBottomBorder(color:String ) {
        
            self.borderStyle = UITextField.BorderStyle.none
            let border = CALayer()
            let width = CGFloat(1.0)
            border.borderColor = UIColor(hexString: color).cgColor
            border.frame = CGRect(x: 0, y: self.frame.size.height - width,   width:  self.frame.size.width, height: self.frame.size.height)
            border.borderWidth = width
            self.layer.addSublayer(border)
            self.layer.masksToBounds = true
    
    }
}
