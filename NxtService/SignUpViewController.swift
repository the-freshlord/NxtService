//
//  SignUpViewController.swift
//  NxtService
//
//  Created by Emanuel  Guerrero on 3/28/16.
//  Copyright © 2016 Project Omicron. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    var account: Account!
    var provider: Provider!
    
    // MARK: - Navigation
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Events
    @IBAction func backButtonTapped(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
