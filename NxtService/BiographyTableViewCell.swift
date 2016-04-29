//
//  BiographyTableViewCell.swift
//  NxtService
//
//  Created by Emanuel  Guerrero on 4/26/16.
//  Copyright © 2016 Project Omicron. All rights reserved.
//

import UIKit

class BiographyTableViewCell: UITableViewCell {
    @IBOutlet weak var biographyTextView: UITextView!
    @IBOutlet weak var paymentLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

//    override func setSelected(selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//    }
    
    func configureCell(provider: Provider) {
        if provider.biography == "" {
            biographyTextView.text = "No biography avaliable"
        } else {
           biographyTextView.text = provider.biography 
        }
        
        if provider.paymentInfo == "" {
            paymentLabel.text = "No payment info avaliable"
        } else {
            paymentLabel.text = provider.paymentInfo
        }
    }
}
