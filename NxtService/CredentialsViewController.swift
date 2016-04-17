//
//  CredentialsViewController.swift
//  NxtService
//
//  Created by Emanuel  Guerrero on 4/16/16.
//  Copyright © 2016 Project Omicron. All rights reserved.
//

import UIKit

class CredentialsViewController: UIViewController {
    var provider: Provider!
    var credentialsChanged = false

    // MARK: - Navigation
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func backButtonTapped(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
