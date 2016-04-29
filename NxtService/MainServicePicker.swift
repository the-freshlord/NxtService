//
//  MainServicePickerViewController.swift
//  NxtService
//
//  Created by Emanuel Guerrero
//             Shaquella Dunanson
//             Santago Facuno
//             Jevin Francis
//             Marcus Guerrer
//             Stephen Green
//             Ryan Fernandez on 4/22/16.
//  Copyright © 2016 Project Omicron. All rights reserved.
//

import UIKit

class MainServicePickerViewController: UIViewController {
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    
    private var _mainServiceSelected = ""
    private var _mainServiceDataSource = ["Tutor", "Cosmetologist", "Handyman", "Nanny"]
    
    weak var delegate: MainServicePickerDelegate? = nil
    
    convenience init() {
        let bundle = NSBundle(forClass: MainServicePickerViewController.self)
        self.init(nibName: "MainServicePicker", bundle: bundle)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Navigation
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.delegate = self
        pickerView.dataSource = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        doneButton.enabled = false
    }
    
    // MARK: - Events
    @IBAction func backButtonTapped(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func doneButtonTapped(sender: UIButton) {
        delegate?.mainServiceSelected(_mainServiceSelected)
        dismissViewControllerAnimated(true, completion: nil)
    }
}

// MARK: - UIPickerViewDelegate, UIPickerViewDataSource
extension MainServicePickerViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return _mainServiceDataSource.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return _mainServiceDataSource[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        _mainServiceSelected = _mainServiceDataSource[row]
        doneButton.enabled = true
        doneButton.alpha = 1.0
    }
    
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let titleData = _mainServiceDataSource[row]
        let customColor = UIColor(red: 222.0 / 255.0, green: 228.0 / 255.0, blue: 232.0 / 255.0, alpha: 1.0)
        let attributedTitle = NSAttributedString(string: titleData, attributes: [NSForegroundColorAttributeName: customColor])
        
        return attributedTitle
    }
}

// MARK: - Protocol for sending back to the parent view controller
protocol MainServicePickerDelegate: class {
    func mainServiceSelected(mainService: String)
}