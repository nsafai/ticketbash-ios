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
import JLPDFGenerator
import Foundation

class ContactInfoViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var address2TextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var zipTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    
    // local storage
    var myTicket: Ticket?
    let realm = Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        addressTextField.delegate = self
        address2TextField.delegate = self
        cityTextField.delegate = self
        stateTextField.delegate = self
        zipTextField.delegate = self
        phoneTextField.delegate = self
        
        //        firstNameTextField.placeholder.textColor = paletteGrey
    }
    
    override func viewWillAppear(animated: Bool) {
        
        delay(keyboardDelay) {
            firstNameTextField.becomeFirstResponder()
        }
        
        firstNameTextField.setValue(paletteGrey, forKeyPath: "_placeholderLabel.textColor")
        lastNameTextField.setValue(paletteGrey, forKeyPath: "_placeholderLabel.textColor")
        addressTextField.setValue(paletteGrey, forKeyPath: "_placeholderLabel.textColor")
        address2TextField.setValue(paletteGrey, forKeyPath: "_placeholderLabel.textColor")
        cityTextField.setValue(paletteGrey, forKeyPath: "_placeholderLabel.textColor")
        stateTextField.setValue(paletteGrey, forKeyPath: "_placeholderLabel.textColor")
        zipTextField.setValue(paletteGrey, forKeyPath: "_placeholderLabel.textColor")
        phoneTextField.setValue(paletteGrey, forKeyPath: "_placeholderLabel.textColor")
        
        
        var tickets = realm.objects(Ticket)
        
        if let ticket = tickets.first { // if there is a stored value then the 'tickets' array is not nil --> assign the value of the first ticket in the array to 'ticket'
            myTicket = ticket // assign the value of ticket to myTicket
            firstNameTextField.text = myTicket!.firstName // grab value of myTicket.FirstName and populate the text field
            lastNameTextField.text = myTicket!.lastName
            addressTextField.text = myTicket!.mailingAddress
            address2TextField.text = myTicket!.mailingAddress2
            cityTextField.text = myTicket!.mailingCity
            stateTextField.text = myTicket!.mailingState
            zipTextField.text = myTicket!.mailingZip
            phoneTextField.text = myTicket!.phoneNumber
            //            println("grabbed ticket from realm")
        } else {
            myTicket = Ticket()
            //            println("created new ticket")
        }
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if textField == firstNameTextField { // Switch focus to other text field
            lastNameTextField.becomeFirstResponder()
        } else if textField == lastNameTextField {
            addressTextField.becomeFirstResponder()
        } else if textField == addressTextField {
            address2TextField.becomeFirstResponder()
        } else if textField == address2TextField {
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
                ticket.mailingAddress2 = self.address2TextField.text
                ticket.mailingCity = self.cityTextField.text
                ticket.mailingState = self.stateTextField.text
                ticket.mailingZip = self.zipTextField.text
                ticket.phoneNumber = self.phoneTextField.text
                self.realm.add(ticket, update: true) // 3 Add a new ticket to Realm if none exists, else update it
            }
            
        }
        //        println(myTicket)
        if let ticketData = myTicket {
            //            println(ticketData)
            
            // generate PDF
            generatePDF(ticketData)
            
            // find current directory path
            let path:NSArray = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
            println(path.objectAtIndex(0))
            
            // TODO: convert PDF to NSData to upload to Parse
            var pdfPath = path.objectAtIndex(0).stringByAppendingPathComponent("hahaPDF.pdf")
            var myData = NSData(contentsOfFile: pdfPath)
            //            println(pdfPath)
        
            //send to parse
            let ticketObject = PFObject(className: "Ticket")
            ticketObject["ticketPDF"] = PFFile(data: myData!)
            ticketObject["ticketPicture"] = PFFile(data: ticketData.ticketPicture)
            ticketObject["evidencePicture"] = PFFile(data: ticketData.evidencePicture)
            ticketObject["explanationText"] = ticketData.explanationText
            ticketObject["firstName"] = ticketData.firstName
            ticketObject["lastName"] = ticketData.lastName
            ticketObject["mailingAddress"] = ticketData.mailingAddress
            ticketObject["mailingAddress2"] = ticketData.mailingAddress2
            ticketObject["mailingCity"] = ticketData.mailingCity
            ticketObject["mailingState"] = ticketData.mailingState
            ticketObject["mailingZip"] = ticketData.mailingZip
            ticketObject["phoneNumber"] = ticketData.phoneNumber
            ticketObject["user"] = PFUser.currentUser()
            
            ticketObject.saveInBackgroundWithBlock({ (success, ErrorHandling) -> Void in
                println("sent ticket to Parse")
                if let ticket = self.myTicket {
                    self.realm.write() {
                        ticketData.parseObjectID = ticketObject.objectId!
                        self.realm.add(ticket, update: true)
                    }
                }
            })
            
            println("let's take a look at the ticket object: \(ticketObject)")
        }
        
    }
}
