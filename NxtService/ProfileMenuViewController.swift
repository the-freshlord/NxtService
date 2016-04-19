//
//  ProfileMenuViewController.swift
//  NxtService
//
//  Created by Emanuel  Guerrero on 3/30/16.
//  Copyright © 2016 Project Omicron. All rights reserved.
//

import UIKit

class ProfileMenuViewController: UIViewController {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var editBasicInfoLabel: UILabel!
    @IBOutlet weak var editCredentialsLabel: UILabel!
    @IBOutlet weak var editServicesOfferedLabel: UILabel!
    @IBOutlet weak var editLocationLabel: UILabel!
    
    let editInfoTapGesture = UITapGestureRecognizer()
    let editCredentialsTapGesture = UITapGestureRecognizer()
    let editServicesOfferedTapGesture = UITapGestureRecognizer()
    let editLocationTapGesure = UITapGestureRecognizer()
    
    var account: Account!
    var provider: Provider!
    var imagePickerController: UIImagePickerController!
    var imageSelect = false
    
    // MARK: - Navigation
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImageView.layer.borderColor = UIColor(red: 220.0 / 255.0, green: 217.0 / 255.0, blue: 222.0 / 255.0, alpha: 1.0).CGColor
        profileImageView.layer.borderWidth = 1.5
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
        profileImageView.clipsToBounds = true
        
        imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        setupTapGestureRecognizers()
        
        provider = Provider(providerID: account.accountID!)
        provider.loadProvider()
        
        // Use Notification Design Pattern (Post & Observe) to listen for when a provider is updated
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ProfileMenuViewController.providerUpdated(_:)), name: NSNotificationCenterPostNotificationNames.BASIC_INFO_UPDATED, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ProfileMenuViewController.accountUpdated(_:)), name: NSNotificationCenterPostNotificationNames.CREDENTIALS_UPDATED, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ProfileMenuViewController.providerUpdated(_:)), name: NSNotificationCenterPostNotificationNames.SERVICES_UPDATED, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ProfileMenuViewController.providerUpdated(_:)), name: NSNotificationCenterPostNotificationNames.LOCATION_UPDATED, object: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier {
        case SegueIdentifiers.PROFILE_BASIC_INFO?:
            if let basicInfoViewController = segue.destinationViewController as? BasicInfoViewController {
                if let provider = sender as? Provider {
                    basicInfoViewController.provider = provider
                }
            }
        case SegueIdentifiers.PROFILE_CREDENTIALS?:
            if let credentialsViewController = segue.destinationViewController as? CredentialsViewController {
                if let account = sender as? Account {
                    credentialsViewController.account = account
                }
            }
        case SegueIdentifiers.PROFILE_SERVICES?:
            if let servicesViewController = segue.destinationViewController as? ServicesViewController {
                if let provider = sender as? Provider {
                    servicesViewController.provider = provider
                }
            }
        default:
            if let locationViewController = segue.destinationViewController as? LocationViewController {
                if let provider = sender as? Provider {
                    locationViewController.provider = provider
                }
            }
        }
    }
    
    // MARK: - Events
    @IBAction func cameraImageTapped(sender: UIButton) {
        presentViewController(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func logoutButtonTapped(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func deleteButtonTapped(sender: MaterialButton) {
    }
    
    // MARK: - Helper methods
    func setupTapGestureRecognizers() {
        editInfoTapGesture.addTarget(self, action: #selector(ProfileMenuViewController.editInfoLabelTapped))
        editCredentialsTapGesture.addTarget(self, action: #selector(ProfileMenuViewController.editCredentialsLabelTapped))
        editServicesOfferedTapGesture.addTarget(self, action: #selector(ProfileMenuViewController.editServicesOfferedLabelTapped))
        editLocationTapGesure.addTarget(self, action: #selector(ProfileMenuViewController.editLocationLabelTapped))
        
        editInfoTapGesture.numberOfTapsRequired = 1
        editCredentialsTapGesture.numberOfTapsRequired = 1
        editServicesOfferedTapGesture.numberOfTapsRequired = 1
        editLocationTapGesure.numberOfTapsRequired = 1
        
        editBasicInfoLabel.addGestureRecognizer(editInfoTapGesture)
        editCredentialsLabel.addGestureRecognizer(editCredentialsTapGesture)
        editServicesOfferedLabel.addGestureRecognizer(editServicesOfferedTapGesture)
        editLocationLabel.addGestureRecognizer(editLocationTapGesure)
        
        editBasicInfoLabel.userInteractionEnabled = true
        editCredentialsLabel.userInteractionEnabled = true
        editServicesOfferedLabel.userInteractionEnabled = true
        editLocationLabel.userInteractionEnabled = true
    }
    
    func editInfoLabelTapped() {
        performSegueWithIdentifier(SegueIdentifiers.PROFILE_BASIC_INFO, sender: provider)
    }
    
    func editCredentialsLabelTapped() {
        performSegueWithIdentifier(SegueIdentifiers.PROFILE_CREDENTIALS, sender: account)
    }
    
    func editServicesOfferedLabelTapped() {
        performSegueWithIdentifier(SegueIdentifiers.PROFILE_SERVICES, sender: provider)
    }
    
    func editLocationLabelTapped() {
        performSegueWithIdentifier(SegueIdentifiers.PROFILE_LOCATION, sender: provider)
    }
    
    func providerUpdated(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            provider = userInfo[NSNotificationCenterUserInfoDictKeys.UPDATED_PROVIDER] as! Provider
        }
    }
    
    func accountUpdated(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            account = userInfo[NSNotificationCenterUserInfoDictKeys.UPDATED_ACCOUNT] as! Account
        }
    }
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension ProfileMenuViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        imagePickerController.dismissViewControllerAnimated(true, completion: nil)
        profileImageView.image = image
        imageSelect = true
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
}