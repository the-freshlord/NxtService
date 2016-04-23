//
//  SpecialitiesPickerViewController.swift
//  NxtService
//
//  Created by Emanuel  Guerrero on 4/23/16.
//  Copyright © 2016 Project Omicron. All rights reserved.
//

import UIKit

class SpecialitiesPickerViewController: UIViewController {
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    
    private var _specialitySelected = ""
    private var _mainService: String!
    private var _mainServiceDataSource = ["Tutor", "Cosmetologist", "Handyman", "Nanny"]
    private var _tutorDataSource = ["Math", "Science", "History", "Language", "Music", "Art", "Computers"]
    private var _cosmetologistDataSource = ["Barber", "HairSalon", "Makeup Artist", "Pedicure"]
    private var _handymanDataSource = ["Plumber", "Electrician", "Pool Cleaner", "Roofer", "Carpenter"]
    private var _nannyDataSource = ["Baby Sitter", "Full Time Nanny", "Part Time Nanny"]
    
    weak var delegate: SpecialitiesPickerDelegate? = nil
    
    convenience init(mainService: String) {
        self.init(nibName: "", bundle: nil)
        _mainService = mainService
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
        delegate?.specialitySelected(_specialitySelected)
        dismissViewControllerAnimated(true, completion: nil)
    }

}

// MARK: - UIPickerViewDelegate, UIPickerViewDataSource
extension SpecialitiesPickerViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch _mainService {
        case "Tutor":
            return _tutorDataSource.count
        case "Cosmetologist":
            return _cosmetologistDataSource.count
        case "Handyman":
            return _handymanDataSource.count
        case "Nanny":
            return _nannyDataSource.count
        default:
            return 1
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch _mainService {
        case "Tutor":
            return _tutorDataSource[row]
        case "Cosmetologist":
            return _cosmetologistDataSource[row]
        case "Handyman":
            return _handymanDataSource[row]
        case "Nanny":
            return _nannyDataSource[row]
        default:
            return ""
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch _mainService {
        case "Tutor":
            _specialitySelected = _tutorDataSource[row]
        case "Cosmetologist":
            _specialitySelected = _cosmetologistDataSource[row]
        case "Handyman":
            _specialitySelected = _handymanDataSource[row]
        case "Nanny":
            _specialitySelected = _nannyDataSource[row]
        default:
            break
        }
        
        doneButton.enabled = true
    }
}

// MARK: - Protocol for sending back to the parent view controller
protocol SpecialitiesPickerDelegate: class {
    func specialitySelected(speciality: String)
}