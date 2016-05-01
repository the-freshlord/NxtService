//
//  ProviderViewController.swift
//  NxtService
//
//  Created by Emanuel Guerrero
//             Shaquella Dunanson
//             Santago Facuno
//             Jevin Francis
//             Marcus Guerrer
//             Stephen Green
//             Ryan Fernandez on 4/26/16.
//  Copyright © 2016 Project Omicron. All rights reserved.
//

import UIKit

class ProviderViewController: UIViewController {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var callButton: UIButton!
    
    var provider: Provider!
    var profileImage: UIImage!
    var userLocation: String!
    var distance: Int!

    // MARK: - Navigation
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        nameLabel.text = provider.name
        
        if provider.phoneNumber == "" {
            callButton.enabled = false
            callButton.alpha = 0.8
        }
        
        tableView.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == SegueIdentifiers.MAP_VIEW {
            guard let mapViewController = segue.destinationViewController as? MapViewController else { return }
            guard let senderDictionary = sender as? Dictionary<String, AnyObject> else { return }
            guard let userLocation = senderDictionary["userLocation"] as? String else { return }
            guard let providerAddress = senderDictionary["providerAddress"] as? String else { return }
            
            mapViewController.userLocation = userLocation
            mapViewController.providerAddress = providerAddress
        }
    }
    
    // MARK: - Events
    @IBAction func backButtonTapped(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func callButtonTapped(sender: MaterialButton) {
        let alert = UIAlertController(title: "Call \(provider.phoneNumber!)", message: "Do you want to call \(provider.name)?", preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alert.addAction(cancelAction)
        
        let okAction = UIAlertAction(title: "Ok", style: .Default) { (action: UIAlertAction) in
            guard let phoneCallURL = NSURL(string: "tel://\(self.provider.phoneNumber!)") else { return }
            let application = UIApplication.sharedApplication()
            
            if application.canOpenURL(phoneCallURL) {
                application.openURL(phoneCallURL)
            } else {
                self.showErrorAlert("Can't call number", message: "\(self.provider.name) number can not be called")
            }
        }
        alert.addAction(okAction)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func checkMapButtonTapped(sender: MaterialButton) {
        let senderDictionary = ["userLocation": userLocation, "providerAddress": provider.address]
        performSegueWithIdentifier(SegueIdentifiers.MAP_VIEW, sender: senderDictionary)
    }
    
    // MARK: - Helper methods
    func callButtonTapped() {
        let alert = UIAlertController(title: "Call \(provider.phoneNumber!)", message: "Do you want to call \(provider.name)?", preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alert.addAction(cancelAction)
        
        let okAction = UIAlertAction(title: "Ok", style: .Default) { (action: UIAlertAction) in
            guard let phoneCallURL = NSURL(string: "tel://\(self.provider.phoneNumber!)") else { return }
            let application = UIApplication.sharedApplication()
            
            if application.canOpenURL(phoneCallURL) {
                application.openURL(phoneCallURL)
            } else {
                self.showErrorAlert("Can't call number", message: "\(self.provider.name) number can not be called")
            }
        }
        alert.addAction(okAction)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func goToMapStoryBoard() {
        let senderDictionary = ["userLocation": userLocation, "providerAddress": provider.address]
        performSegueWithIdentifier(SegueIdentifiers.MAP_VIEW, sender: senderDictionary)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension ProviderViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCellWithIdentifier("servicestableviewcell") as? ServicesTableViewCell else { return ServicesTableViewCell()
            }
            
            cell.configureCell(provider, profileImage: profileImage)
            
            return cell
        } else if indexPath.row == 1 {
            guard let cell = tableView.dequeueReusableCellWithIdentifier("biographytableviewcell") as? BiographyTableViewCell else { return BiographyTableViewCell()
            }
            
            cell.configureCell(provider)
            
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCellWithIdentifier("contacttableviewcell") as? ContactTableViewCell else { return ContactTableViewCell()
            }
            
            cell.configureCell(provider, userLocation: userLocation, distance: distance)
            
            return cell
        }
    }
}