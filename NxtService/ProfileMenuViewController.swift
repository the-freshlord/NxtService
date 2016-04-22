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
    @IBOutlet weak var addImageButton: UIButton!
    
    let editInfoTapGesture = UITapGestureRecognizer()
    let editCredentialsTapGesture = UITapGestureRecognizer()
    let editServicesOfferedTapGesture = UITapGestureRecognizer()
    let editLocationTapGesure = UITapGestureRecognizer()
    
    var account: Account!
    var provider: Provider!
    var profileImage: UIImage!
    var imagePickerController: UIImagePickerController!
    
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
        
        if provider.profileImage == true {
            profileImageView.image = profileImage
            //addImageButton.imageView?.image = UIImage(named: "cross")
            addImageButton.setImage(UIImage(named: "cross"), forState: UIControlState.Normal)
        } else {
            //addImageButton.imageView?.image = UIImage(named: "camera")
            addImageButton.setImage(UIImage(named: "camera"), forState: UIControlState.Normal)
        }
        
        // Use Notification Design Pattern (Post & Observe) to listen for when a provider is updated
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ProfileMenuViewController.providerUpdated(_:)), name: NSNotificationCenterPostNotificationNames.BASIC_INFO_UPDATED, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ProfileMenuViewController.accountUpdated(_:)), name: NSNotificationCenterPostNotificationNames.CREDENTIALS_UPDATED, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ProfileMenuViewController.providerUpdated(_:)), name: NSNotificationCenterPostNotificationNames.SERVICES_UPDATED, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ProfileMenuViewController.providerUpdated(_:)), name: NSNotificationCenterPostNotificationNames.LOCATION_UPDATED, object: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier {
        case SegueIdentifiers.PROFILE_BASIC_INFO?:
            guard let basicInfoViewController = segue.destinationViewController as? BasicInfoViewController else { return }
            guard let provider = sender as? Provider else { return }
            
            basicInfoViewController.provider = provider
        case SegueIdentifiers.PROFILE_CREDENTIALS?:
            guard let credentialsViewController = segue.destinationViewController as? CredentialsViewController else { return }
            guard let account = sender as? Account else { return }
            
            credentialsViewController.account = account
        case SegueIdentifiers.PROFILE_SERVICES?:
            guard let servicesViewController = segue.destinationViewController as? ServicesViewController else { return }
            guard let provider = sender as? Provider else { return }
            
            servicesViewController.provider = provider
        default:
            guard let locationViewController = segue.destinationViewController as? LocationViewController else { return }
            guard let provider = sender as? Provider else { return }
            
            locationViewController.provider = provider
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
        guard let userInfo = notification.userInfo else { return }
        provider = userInfo[NSNotificationCenterUserInfoDictKeys.UPDATED_PROVIDER] as! Provider
    }
    
    func accountUpdated(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        account = userInfo[NSNotificationCenterUserInfoDictKeys.UPDATED_ACCOUNT] as! Account
    }
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension ProfileMenuViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        imagePickerController.dismissViewControllerAnimated(true, completion: nil)
        addImageButton.imageView?.image = UIImage(contentsOfFile: "cross.png")
        profileImageView.image = image
        
        let normalImage = fixImageOrientation(image)
        DataService.dataService.addProfileImage(provider.providerID!, image: normalImage)
        
        provider.profileImage = true
        provider.updateProvider { (providerUpdated) in
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
}