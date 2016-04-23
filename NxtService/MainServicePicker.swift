//
//  MainServicePickerViewController.swift
//  NxtService
//
//  Created by Emanuel  Guerrero on 4/22/16.
//  Copyright © 2016 Project Omicron. All rights reserved.
//

import UIKit

class MainServicePickerViewController: UIViewController {
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    
    private var _mainServiceSelected = ""
    private var _mainServiceDataSource = ["Tutor", "Cosmetologist", "Handyman", "Nanny", "Repairman"]
    
    weak var delegate: MainServicePickerDelegate? = nil
    
    convenience init() {
        self.init(nibName: "MainServicePicker", bundle: nil)
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
    }
}

// MARK: - Protocol for sending back to the parent view controller
protocol MainServicePickerDelegate: class {
    func mainServiceSelected(mainService: String)
}