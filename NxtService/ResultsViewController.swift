//
//  ResultsViewController.swift
//  NxtService
//
//  Created by Emanuel  Guerrero on 4/24/16.
//  Copyright © 2016 Project Omicron. All rights reserved.
//

import UIKit
import Firebase

class ResultsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noResultsLabel: UILabel!
    
    static var profileImageCache = NSCache()

    var providerList: ProviderList<Provider,Int,UIImage>!
    var userLocation: String!
    
    // MARK: - Navigation
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        if providerList.count > 0 {
            tableView.reloadData()
        } else {
            tableView.hidden = true
            noResultsLabel.hidden = false
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == SegueIdentifiers.PROVIDER_VIEW {
            guard let providerViewController = segue.destinationViewController as? ProviderViewController else { return }
            guard let senderDictionary = sender as? Dictionary<String, AnyObject> else { return }
            guard let provider = senderDictionary["provider"] as? Provider else { return }
            guard let profileImage = senderDictionary["profileImage"] as? UIImage else{ return }
            guard let userLocation = senderDictionary["userLocation"] as? String else { return }
            guard let distance = senderDictionary["distance"] as? Int else { return }
            
            providerViewController.provider = provider
            providerViewController.profileImage = profileImage
            providerViewController.userLocation = userLocation
            providerViewController.distance = distance
        }
    }
    
    // MARK: - Events
    @IBAction func backButtonTapped(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension ResultsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let providerTuple = providerList.getProvider(indexPath.row)
        let provider = providerTuple.0
        let distance = providerTuple.1
        let profileImage = providerTuple.2
        
        guard let cell = tableView.dequeueReusableCellWithIdentifier("resultstableviewcell") as? ResultsTableViewCell else {
            return ResultsTableViewCell()
        }
        
        cell.configureCell(provider, image: profileImage, distance: distance)

        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return providerList.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let currentCell = tableView.cellForRowAtIndexPath(indexPath) as! ResultsTableViewCell
        let provider = currentCell.provider
        let profileImage = currentCell.profileImageView.image
        let distance = currentCell.distance
        let senderDictionary: Dictionary<String, AnyObject> = ["provider": provider, "profileImage": profileImage!, "userLocation": userLocation, "distance": distance!]
        
        performSegueWithIdentifier(SegueIdentifiers.PROVIDER_VIEW, sender: senderDictionary)
    }
}