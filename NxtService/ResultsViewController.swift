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

    var providerList: ProviderList<Provider,Int>!
    
    // MARK: - Navigation
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        // Load the providers based on the main service and sub service
//        DataService.dataService.REF_PROVIDERINFO.observeEventType(.Value, withBlock: { snapshot in
//            self.providerList = ProvidierList()
//            
//            guard let snapshots = snapshot.children.allObjects as? [FDataSnapshot] else { return }
//            
//            // Traverse through the list
//            for snapshot in snapshots {
//                guard let providerDictionary = snapshot.value as? Dictionary<String, AnyObject> else { return }
//                
//                if self.mainService == providerDictionary[FirebaseProviderKeys.MAINSERVICE] as? String && self.subService == providerDictionary[FirebaseProviderKeys.SUBSERVICES] as? String {
//                    
//                    let provider = Provider(providerID: snapshot.key)
//                    
//                    guard let name = providerDictionary[FirebaseProviderKeys.NAME] as? String else { return }
//                    guard let address = providerDictionary[FirebaseProviderKeys.ADDRESS] as? String else { return }
//                    guard let phoneNumber = providerDictionary[FirebaseProviderKeys.PHONENUMBER] as? String else { return }
//                    guard let biography = providerDictionary[FirebaseProviderKeys.BIOGRAPHY] as? String else { return }
//                    guard let mainService = providerDictionary[FirebaseProviderKeys.MAINSERVICE] as? String else { return }
//                    guard let specialities = providerDictionary[FirebaseProviderKeys.SUBSERVICES] as? String else { return }
//                    guard let paymentInfo = providerDictionary[FirebaseProviderKeys.PAYMENTINFO] as? String else { return }
//                    guard let profileImage = providerDictionary[FirebaseProviderKeys.PROFILEIMAGE] as? Bool else { return }
//                    
//                    provider.name = name
//                    provider.address = address
//                    provider.phoneNumber = phoneNumber
//                    provider.biography = biography
//                    provider.mainService = mainService
//                    provider.specialities = specialities
//                    provider.paymentInfo = paymentInfo
//                    provider.profileImage = profileImage
//                    
//                    // Get the distance
//                    let distance = calculateDistance(self.userLocation, providerLocation: provider.address)
//                    
//                    // Insert Provider object and distance into provider list
//                    self.providerList.insertProvider(provider, distance: distance)
//                }
//            }
//            
//            self.tableView.reloadData()
//        })
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if providerList.count > 0 {
            tableView.reloadData()
        } else {
            tableView.hidden = true
            noResultsLabel.hidden = false
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
        
        guard let cell = tableView.dequeueReusableCellWithIdentifier("resultstableviewcell") as? ResultsTableViewCell else {
            return ResultsTableViewCell()
        }
        
        // Check if the image is already in the cache
        guard let image = ResultsViewController.profileImageCache.objectForKey(provider.providerID!) as? UIImage else {
            cell.configureCell(provider, image: nil, distance: distance)
            return cell
        }
        
        cell.configureCell(provider, image: image, distance: distance)

        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return providerList.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let currentCell = tableView.cellForRowAtIndexPath(indexPath) as! ResultsTableViewCell
        let provider = currentCell.provider
    }
}