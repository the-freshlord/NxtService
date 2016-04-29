//
//  MaterialIndicatorView.swift
//  NxtService
//
//  Created by Emanuel Guerrero
//             Shaquella Dunanson
//             Santago Facuno
//             Jevin Francis
//             Marcus Guerrer
//             Stephen Green
//             Ryan Fernandez on 4/13/16.
//  Copyright © 2016 Project Omicron. All rights reserved.
//

import UIKit

class MaterialIndicatorView: UIView {
    override func awakeFromNib() {
        layer.cornerRadius = 5.0
        layer.shadowColor = UIColor(red: MaterialDesign.SHADOW_COLOR, green: MaterialDesign.SHADOW_COLOR, blue: MaterialDesign.SHADOW_COLOR, alpha: 0.5).CGColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSizeMake(0.0, 2.0)
    }
}
