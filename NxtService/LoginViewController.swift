//
//  LoginViewController.swift
//  NxtService
//
//  Created by Emanuel  Guerrero on 3/28/16.
//  Copyright © 2016 Project Omicron. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var indicatorView: UIView!
    
    // MARK: - Navigation
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
    }
    
    override func viewDidDisappear(animated: Bool) {
        stopSpinning()
        emailTextField.text = ""
        passwordTextField.text = ""
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier {
        case SEGUE_SIGNUP?:
            if let signUpViewController = segue.destinationViewController as? SignUpViewController {
                if let account = sender as? Account {
                    signUpViewController.account = account
                }
            }
        default:
            if let profileMenuViewController = segue.destinationViewController as? ProfileMenuViewController {
                if let account = sender as? Account {
                    profileMenuViewController.account = account
                }
            }
        }
    }
    
    // MARK: - UITextField
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }
    
    // MARK: - Events
    @IBAction func loginSignUpButtonTapped(sender: MaterialButton) {
        if let email = emailTextField.text where email != "", let password = passwordTextField.text where password != "" {
            
            // Start activity indicator animation
            startSpinning()
            
            DataService.dataService.REF_BASE.authUser(email, password: password, withCompletionBlock: { NSError, FAuthData in
                // Check if login successful
                if NSError != nil {
                    print(NSError.debugDescription)
                    
                    // Check error code
                    switch NSError.code {
                    case STATUS_ACCOUNT_NONEXIST:
                        //Send user to sign up storyboard
                        self.goToSignUpStoryBoard(email, password: password)
                    case STATUS_INVALID_EMAIL:
                        self.stopSpinning()
                        self.showErrorAlert("Invalid email", message: "The email entered is not valid")
                    default:
                        self.stopSpinning()
                        self.showErrorAlert("Invalid login", message: "Please check your email or password")
                    }
                    
                } else {
                    // Send user to profile menu controller
                    self.goToProfileMenuStoryBoard(email, password: password, accountID: FAuthData.uid)
                }
            })
        } else {
            showErrorAlert("Email and Password Required", message: "You must enter an email and a password")
        }
    }
    
    @IBAction func backButtonTapped(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Helper methods
    func showErrorAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func goToSignUpStoryBoard(email: String, password: String) {
        let account = Account(email: email, password: password, accountID: nil)
        performSegueWithIdentifier(SEGUE_SIGNUP, sender: account)
    }
    
    func goToProfileMenuStoryBoard(email: String, password: String, accountID: String) {
        let account = Account(email: email, password: password, accountID: accountID)
        performSegueWithIdentifier(SEGUE_PROFILE_MENU, sender: account)
    }
    
    func startSpinning() {
        indicatorView.hidden = false
        activityIndicatorView.startAnimating()
    }
    
    func stopSpinning() {
        indicatorView.hidden = true
        activityIndicatorView.stopAnimating()
    }
}
