//
//  ContactInfoViewController.swift
//  TicketBash
//
//  Created by Nicolai Safai on 7/29/15.
//  Copyright (c) 2015 Lime. All rights reserved.
//

import UIKit
import RealmSwift
import Parse

class ContactInfoViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var zipTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    
    // local storage
    var myTicket: Ticket?
    let realm = Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        addressTextField.delegate = self
        cityTextField.delegate = self
        stateTextField.delegate = self
        zipTextField.delegate = self
        phoneTextField.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        
        firstNameTextField.becomeFirstResponder()
        
        var tickets = realm.objects(Ticket)
        
        if let ticket = tickets.first { // if there is a stored value then the 'tickets' array is not nil --> assign the value of the first ticket in the array to 'ticket'
            myTicket = ticket // assign the value of ticket to myTicket
            firstNameTextField.text = myTicket!.firstName // grab value of myTicket.FirstName and populate the text field
            lastNameTextField.text = myTicket!.lastName
            addressTextField.text = myTicket!.mailingAddress
            cityTextField.text = myTicket!.mailingCity
            stateTextField.text = myTicket!.mailingState
            zipTextField.text = myTicket!.mailingZip
            phoneTextField.text = myTicket!.phoneNumber
            println("grabbed ticket from realm")
        } else {
            myTicket = Ticket()
            println("created new ticket")
        }
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if textField == firstNameTextField { // Switch focus to other text field
            lastNameTextField.becomeFirstResponder()
        } else if textField == lastNameTextField {
            addressTextField.becomeFirstResponder()
        } else if textField == addressTextField {
            cityTextField.becomeFirstResponder()
        } else if textField == cityTextField {
            stateTextField.becomeFirstResponder()
        } else if textField == stateTextField {
            zipTextField.becomeFirstResponder()
        } else if textField == zipTextField {
            // this doesn't do anything yet because there is no Return key on numeric pad.
            phoneTextField.becomeFirstResponder()
        } else if textField == phoneTextField {
            // click next Button
        }
        
        return true
    }
    
    @IBAction func nextButton(sender: AnyObject) {
        
        if let ticket = self.myTicket { // safety just incase this button is clicked before viewWillAppear finished loading
            self.realm.write() { //changes must be done within a write transaction/closure.
                ticket.firstName = self.firstNameTextField.text // change realm text value to what user just wrote in text view
                ticket.lastName = self.lastNameTextField.text
                ticket.mailingAddress = self.addressTextField.text
                ticket.mailingCity = self.cityTextField.text
                ticket.mailingState = self.stateTextField.text
                ticket.mailingZip = self.zipTextField.text
                ticket.phoneNumber = self.phoneTextField.text
                self.realm.add(ticket, update: true) // 3 Add a new ticket to Realm if none exists, else update it
            }
        
        }
        println(myTicket)
        if let ticketData = myTicket {
            println(ticketData)
            
            let ticketObject = PFObject(className: "Ticket")
            ticketObject["explanationText"] = ticketData.explanationText
            ticketObject["mailingAddress"] = ticketData.mailingAddress
            ticketObject["mailingCity"] = ticketData.mailingCity
            ticketObject["mailingState"] = ticketData.mailingState
            ticketObject["mailingZip"] = ticketData.mailingZip
            ticketObject["user"] = PFUser.currentUser()
            ticketObject.saveInBackgroundWithBlock({ (success, ErrorHandling) -> Void in
            })
            println("")
        }
    }
}