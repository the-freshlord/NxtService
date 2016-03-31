//
//  LocationSearchViewBar.swift
//  NxtService
//
//  Created by Emanuel  Guerrero on 3/29/16.
//  Copyright © 2016 Project Omicron. All rights reserved.
//

import UIKit

class LocationSearchViewBar: UIView {
    override func awakeFromNib() {
        layer.cornerRadius = 2.0
        layer.borderWidth = 1.0
        layer.borderColor = UIColor(red: 220.0 / 255.0, green: 217.0 / 255.0, blue: 222.0 / 255/0, alpha: 1.0).CGColor
    }
}
