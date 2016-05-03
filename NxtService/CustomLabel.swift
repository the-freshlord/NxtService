//
//  CustomLabel.swift
//  NxtService
//
//  Created by Emanuel  Guerrero on 5/3/16.
//  Copyright © 2016 Project Omicron. All rights reserved.
//
//  This class is for using a custom font when using size classes

import UIKit

@IBDesignable class CustomLabel: UILabel {
    
    @IBInspectable var fontName: String = "Viafont" {
        didSet {
            font = UIFont(name: fontName, size: (font?.pointSize)!)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        font = UIFont(name: fontName, size: (font?.pointSize)!)
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
    }
}
