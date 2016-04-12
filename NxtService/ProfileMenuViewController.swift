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
    }
    
    // MARK: - Events
    @IBAction func cameraImageTapped(sender: UIButton) {
        presentViewController(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func deleteButtonTapped(sender: MaterialButton) {
    }
    
    // MARK: Helper methods
    @IBAction func editInfoLabelTapped(sender: UITapGestureRecognizer) {
    }
    
    @IBAction func editCredentialsLabelTapped(sender: UITapGestureRecognizer) {
    }
    
    @IBAction func editServicesLabelTapped(sender: UITapGestureRecognizer) {
    }
    
    @IBAction func editLocationLabelTapped(sender: UITapGestureRecognizer) {
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