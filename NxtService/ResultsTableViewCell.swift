//
//  ResultsTableViewCell.swift
//  NxtService
//
//  Created by Emanuel  Guerrero on 4/24/16.
//  Copyright © 2016 Project Omicron. All rights reserved.
//

import UIKit

class ResultsTableViewCell: UITableViewCell {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var mainServiceLabel: UILabel!
    @IBOutlet weak var specialityLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    var provider: Provider!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func drawRect(rect: CGRect) {
        profileImageView.layer.borderColor = UIColor(red: 220.0 / 255.0, green: 217.0 / 255.0, blue: 222.0 / 255.0, alpha: 1.0).CGColor
        profileImageView.layer.borderWidth = 1.5
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
        profileImageView.clipsToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(provider: Provider, image: UIImage?, distance: Int) {
        self.provider = provider
        
        nameLabel.text = provider.name
        mainServiceLabel.text = provider.mainService
        specialityLabel.text = provider.specialities
        distanceLabel.text = "\(distance) mi"
        
        if provider.profileImage == true {
            if image != nil {
                profileImageView.image = image
            } else {
                DataService.dataService.loadProfileImage(provider.providerID!, onCompletion: { (decodedImage) in
                    self.profileImageView.image = decodedImage
                    
                    // Add the image to the cache for faster performance
                    ResultsViewController.profileImageCache.setObject(decodedImage, forKey: self.provider.providerID!)
                })
            }
        } else {
            profileImageView.image = UIImage(named: "noimage")
            profileImageView.contentMode = .Center
        }
    }
}
