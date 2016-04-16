//
//  BasicInfoViewController.swift
//  NxtService
//
//  Created by Emanuel  Guerrero on 4/11/16.
//  Copyright © 2016 Project Omicron. All rights reserved.
//

import UIKit

class BasicInfoViewController: UIViewController {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var biographyTextView: UITextView!
    @IBOutlet weak var paymentInfoTextField: UITextField!
    @IBOutlet weak var indicatorView: MaterialIndicatorView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    var provider: Provider!
    var basicInfoChanged = false
    var placeHolderText = "Enter some information about your service"

    // MARK: - Navigation
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.delegate = self
        phoneNumberTextField.delegate = self
        paymentInfoTextField.delegate = self
        biographyTextView.delegate = self
        
        nameTextField.text = provider.name
        phoneNumberTextField.text = provider.phoneNumber
        
        if provider.biography == "" {
            biographyTextView.text = placeHolderText
            biographyTextView.textColor = UIColor.blackColor()
            biographyTextView.alpha = 0.2
        } else {
            biographyTextView.text = provider.biography
            biographyTextView.textColor = UIColor(red: 222.0 / 255.0, green: 228.0 / 255.0, blue: 232.0 / 255.0, alpha: 1.0)
        }
        
        paymentInfoTextField.text = provider.paymentInfo
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        if basicInfoChanged {
            NSNotificationCenter.defaultCenter().postNotificationName(NSNotificationCenterPostNotificationNames.BASIC_INFO_UPDATED, object: nil, userInfo: [NSNotificationCenterUserInfoDictKeys.UPDATED_PROVIDER: provider])
        }
    }
    
    // MARK: - Events
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
    }
    
    @IBAction func backButtonTapped(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func saveButtonTapped(sender: MaterialButton) {
        if let name = nameTextField.text where name != "", let phoneNumber = phoneNumberTextField.text where phoneNumber != "" {
            
            // Start activity indicator animation
            startSpinning(indicatorView, activityIndicatorView: activityIndicatorView)
            
            // Update the provider
            provider.name = name
            provider.phoneNumber = phoneNumber
            
            if biographyTextView.text == placeHolderText {
                provider.biography = ""
            } else {
                provider.biography = biographyTextView.text
            }
            
            provider.paymentInfo = paymentInfoTextField.text
            
            provider.updateProvider({ (providerUpdated) in
                if providerUpdated == true {
                    self.basicInfoChanged = true
                    
                    dispatch_async(dispatch_get_main_queue(), { 
                        self.stopSpinning(self.indicatorView, activityIndicatorView: self.activityIndicatorView)
                        self.showErrorAlert("Info updated", message: "Your info was updated")
                    })
                } else {
                    dispatch_async(dispatch_get_main_queue(), {
                        self.stopSpinning(self.indicatorView, activityIndicatorView: self.activityIndicatorView)
                        self.showErrorAlert("Error updating info", message: "There was an unknown error wit updating your info")
                    })
                }
            })
        } else {
            showErrorAlert("Certain fields needed", message: "A name and phone number must be used")
        }
    }
}

// MARK: - UITextFieldDelegate
extension BasicInfoViewController: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - UITextViewDelegate
extension BasicInfoViewController: UITextViewDelegate {
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        
        return true
    }
    
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        if textView.text == placeHolderText {
            textView.text = ""
            textView.textColor = UIColor(red: 222.0 / 255.0, green: 228.0 / 255.0, blue: 232.0 / 255.0, alpha: 1.0)
        }
        
        return true
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if textView.text == "" {
            textView.text = placeHolderText
            textView.textColor = UIColor.blackColor()
            textView.alpha = 0.2
        }
    }
}