//
//  LoginViewController.swift
//  NxtService
//
//  Created by Emanuel  Guerrero on 3/28/16.
//  Copyright © 2016 Project Omicron. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var indicatorView: UIView!
    
    // MARK: - Navigation
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        // Listen for the event of when an account is created
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginViewController.accountWasCreated), name: NSNotificationCenterPostNotificationNames.ACCOUNT_CREATED, object: nil)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        stopSpinning(indicatorView, activityIndicatorView: activityIndicatorView)
        emailTextField.text = ""
        passwordTextField.text = ""
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier {
        case SegueIdentifiers.SIGNUP?:
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
    
    // MARK: - Events
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
    }
    
    @IBAction func loginSignUpButtonTapped(sender: MaterialButton) {
        if let email = emailTextField.text where email != "", let password = passwordTextField.text where password != "" {
            
            // Start activity indicator animation
            startSpinning(indicatorView, activityIndicatorView: activityIndicatorView)
            
            DataService.dataService.REF_BASE.authUser(email, password: password, withCompletionBlock: { NSError, FAuthData in
                // Check if login successful
                if NSError != nil {
                    print(NSError.debugDescription)
                    
                    // Check error code
                    switch NSError.code {
                    case FirebaseErrorCodes.ACCOUNT_NONEXIST:
                        // Send user to sign up storyboard
                        self.goToSignUpStoryBoard(email, password: password)
                    case FirebaseErrorCodes.INVALID_EMAIL:
                        // Go back to the main thread to display the alert view controller
                        dispatch_async(dispatch_get_main_queue(), {
                            self.stopSpinning(self.indicatorView, activityIndicatorView: self.activityIndicatorView)
                            self.showErrorAlert("Invalid email", message: "The email entered is not valid")
                        })
                    case FirebaseErrorCodes.TOO_MANY_REQUESTS:
                        dispatch_async(dispatch_get_main_queue(), { 
                            self.stopSpinning(self.indicatorView, activityIndicatorView: self.activityIndicatorView)
                            self.showErrorAlert("Unknown error", message: "There was an unknown error logging in")
                        })
                    default:
                        // Go back to the main thread to display the alert view controller
                        dispatch_async(dispatch_get_main_queue(), {
                            self.stopSpinning(self.indicatorView, activityIndicatorView: self.activityIndicatorView)
                            self.showErrorAlert("Invalid login", message: "Please check your email or password")
                        })
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
    func goToSignUpStoryBoard(email: String, password: String) {
        let account = Account(email: email, password: password, accountID: nil)
        performSegueWithIdentifier(SegueIdentifiers.SIGNUP, sender: account)
    }
    
    func goToProfileMenuStoryBoard(email: String, password: String, accountID: String) {
        let account = Account(email: email, password: password, accountID: accountID)
        performSegueWithIdentifier(SegueIdentifiers.PROFILE_MENU, sender: account)
    }
    
    func accountWasCreated() {
        showErrorAlert("Account created", message: "Please login to check out your profile")
    }
}

// MARK: - UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
