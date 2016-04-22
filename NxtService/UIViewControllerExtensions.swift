//
//  UIViewExtensions.swift
//  NxtService
//
//  Created by Emanuel  Guerrero on 4/13/16.
//  Copyright © 2016 Project Omicron. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func showErrorAlert(title: String, message: String) {
        // Check if an alert controller is already being presented
        if self.presentedViewController == nil {
            createNewAlertViewController(title, message: message)
        } else {
            // The alert controller is already presented or there is another view controller being presented
            let thePresentedViewController: UIViewController? = self.presentedViewController as UIViewController?
            
            if thePresentedViewController != nil {
                
                // Check if the presented controller is an alert view controller
                guard let _: UIAlertController = thePresentedViewController as? UIAlertController else { return }
                
                // Another view controller presented, so use thePresentedViewController
                let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
                let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
                alert.addAction(action)
                thePresentedViewController?.presentViewController(alert, animated: true, completion: nil)
            }
        }
    }
    
    func createNewAlertViewController(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        alert.addAction(action)
        self.presentViewController(alert, animated: true, completion: nil)
    }

    func startSpinning(indicatorView: UIView, activityIndicatorView: UIActivityIndicatorView) {
        indicatorView.hidden = false
        activityIndicatorView.startAnimating()
    }
    
    func stopSpinning(indicatorView: UIView, activityIndicatorView: UIActivityIndicatorView) {
        indicatorView.hidden = true
        activityIndicatorView.stopAnimating()
    }
}