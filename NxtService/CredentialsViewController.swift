//
//  CredentialsViewController.swift
//  NxtService
//
//  Created by Emanuel  Guerrero on 4/16/16.
//  Copyright © 2016 Project Omicron. All rights reserved.
//

import UIKit

class CredentialsViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var indicatorView: MaterialIndicatorView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var saveButton: MaterialButton!
    
    var account: Account!
    var credentialsChanged = false

    // MARK: - Navigation
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        emailTextField.text = account.email
        passwordTextField.text = account.password
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        if credentialsChanged {
            NSNotificationCenter.defaultCenter().postNotificationName(NSNotificationCenterPostNotificationNames.CREDENTIALS_UPDATED, object: nil, userInfo: [NSNotificationCenterUserInfoDictKeys.UPDATED_ACCOUNT: account])
        }
    }
    
    // MARK: - Events
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
    }
    
    @IBAction func saveButtonTapped(sender: MaterialButton) {
        if let email = emailTextField.text where email != "", let password = passwordTextField.text where password != "" {
            emailTextField.enabled = false
            passwordTextField.enabled = false
            saveButton.enabled = false
            
            // Start activity indicator animation
            startSpinning(indicatorView, activityIndicatorView: activityIndicatorView)
            
            // Update the provider's email
            account.updateEmail(email, completion: { (emailUpdated, errorMessage) in
                if emailUpdated == true {
                    
                    // Update the password
                    self.account.updatePassword(password, completion: { (passwordUpdated) in
                        if passwordUpdated == true {
                            self.credentialsChanged = true
                            
                            dispatch_async(dispatch_get_main_queue(), { 
                                self.stopSpinning(self.indicatorView, activityIndicatorView: self.activityIndicatorView)
                                self.emailTextField.enabled = true
                                self.passwordTextField.enabled = true
                                self.saveButton.enabled = true
                                self.showErrorAlert("Credentials updated", message: "Your login info was updated")
                            })
                        } else {
                            dispatch_async(dispatch_get_main_queue(), { 
                                self.stopSpinning(self.indicatorView, activityIndicatorView: self.activityIndicatorView)
                                self.emailTextField.enabled = true
                                self.passwordTextField.enabled = true
                                self.saveButton.enabled = true
                                self.showErrorAlert("Error updating credentials", message: "There was an unknown error when updaing your password")
                            })
                        }
                    })
                } else {
                    dispatch_async(dispatch_get_main_queue(), {
                        self.stopSpinning(self.indicatorView, activityIndicatorView: self.activityIndicatorView)
                        self.emailTextField.enabled = true
                        self.passwordTextField.enabled = true
                        self.saveButton.enabled = true
                        self.showErrorAlert("Error updating credentials", message: errorMessage)
                    })
                }
            })
        } else {
            showErrorAlert("All fields needed", message: "There must be an email and password associated with the account")
        }
    }
    
    @IBAction func backButtonTapped(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}

// MARK: - UITextFieldDelegate
extension CredentialsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}