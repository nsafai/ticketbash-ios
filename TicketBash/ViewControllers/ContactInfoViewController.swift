//
//  ContactInfoViewController.swift
//  TicketBash
//
//  Created by Nicolai Safai on 7/29/15.
//  Copyright (c) 2015 Lime. All rights reserved.
//

import UIKit

class ContactInfoViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var zipTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        phoneTextField.delegate = self
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        addressTextField.delegate = self
        cityTextField.delegate = self
        zipTextField.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {

        firstNameTextField.becomeFirstResponder()
        
            }
   
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if textField == firstNameTextField { // Switch focus to other text field
            lastNameTextField.becomeFirstResponder()
        } else if textField == lastNameTextField {
            addressTextField.becomeFirstResponder()
        } else if textField == addressTextField {
            cityTextField.becomeFirstResponder()
        } else if textField == cityTextField {
            zipTextField.becomeFirstResponder()
        } else if textField == zipTextField {
            phoneTextField.becomeFirstResponder()
        } else if textField == phoneTextField {
            // click next
        }
        
        return true
    }
    
}