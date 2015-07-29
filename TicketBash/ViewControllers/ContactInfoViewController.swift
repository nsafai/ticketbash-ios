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
        
        firstNameTextField.becomeFirstResponder()

    }
    
    override func viewWillAppear(animated: Bool) {
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        addressTextField.delegate = self
        cityTextField.delegate = self
        zipTextField.delegate = self
        phoneTextField.delegate = self
        
        firstNameTextField.becomeFirstResponder()
        
        
        
            }
}