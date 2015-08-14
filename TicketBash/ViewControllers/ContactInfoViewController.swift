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
//import JLPDFGenerator
import Foundation
import Mixpanel
import GooglePlacesAutocomplete

class ContactInfoViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var address2TextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    let mixpanel: Mixpanel = Mixpanel.sharedInstance()
    
    @IBOutlet weak var disclaimerText: UILabel!
    
    let gpaViewController = GooglePlacesAutocomplete(
        apiKey: "AIzaSyAL6IoheqMuKptTF3lnonhR3WZeLn9sNi4",
        placeType: .Address
    )
    
    // local storage
    var myTicket: Ticket?
    let realm = Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "applicationWillEnterForeground:", name: UIApplicationWillEnterForegroundNotification, object: nil)
        
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        addressTextField.delegate = self
        address2TextField.delegate = self
        emailTextField.delegate = self
        
    }
    
    override func viewWillAppear(animated: Bool) {
    
        refreshButton()
        
        gpaViewController.placeDelegate = self
        gpaViewController.navigationItem.title = "Mailing Address"
        
        delay(keyboardDelay) {
            firstNameTextField.becomeFirstResponder()
        }
        
        firstNameTextField.setValue(paletteGrey, forKeyPath: "_placeholderLabel.textColor")
        lastNameTextField.setValue(paletteGrey, forKeyPath: "_placeholderLabel.textColor")
        addressTextField.setValue(paletteGrey, forKeyPath: "_placeholderLabel.textColor")
        address2TextField.setValue(paletteGrey, forKeyPath: "_placeholderLabel.textColor")
        emailTextField.setValue(paletteGrey, forKeyPath: "_placeholderLabel.textColor")
        
        var tickets = realm.objects(Ticket)
        
        if let ticket = tickets.first { // if there is a stored value then the 'tickets' array is not nil --> assign the value of the first ticket in the array to 'ticket'
            myTicket = ticket // assign the value of ticket to myTicket
            firstNameTextField.text = myTicket!.firstName // grab value of myTicket.FirstName and populate the text field
            lastNameTextField.text = myTicket!.lastName
            addressTextField.text = myTicket!.mailingAddress
            address2TextField.text = myTicket!.mailingAddress2
            emailTextField.text = myTicket!.email
        } else {
            myTicket = Ticket()
        }
        
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if textField == firstNameTextField {
            lastNameTextField.becomeFirstResponder()
        } else if textField == lastNameTextField {
            emailTextField.becomeFirstResponder()
        } else if textField == emailTextField {
            addressTextField.becomeFirstResponder()
        } else if textField == addressTextField {
            address2TextField.becomeFirstResponder()
        } else if textField == address2TextField {
            nextButton.sendActionsForControlEvents(UIControlEvents.TouchUpInside)
        }
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if (textField == addressTextField) {
            if (Reachability.isConnectedToNetwork() == true) {
                presentViewController(gpaViewController, animated: true, completion: nil)
            }
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        saveToRealm()
    }
    
    func saveToRealm() {
        if let ticket = self.myTicket { // safety just incase this button is clicked before viewWillAppear finished loading
            self.realm.write() { //changes must be done within a write transaction/closure.
                ticket.firstName = self.firstNameTextField.text // change realm text value to what user just wrote in text view
                ticket.lastName = self.lastNameTextField.text
                ticket.mailingAddress = self.addressTextField.text
                ticket.mailingAddress2 = self.address2TextField.text
                ticket.email = self.emailTextField.text
                self.realm.add(ticket, update: true) // 3 Add a new ticket to Realm if none exists, else update it
            }
        }
    }
    
    @IBAction func nextButton(sender: AnyObject) {
        
        saveToRealm()
        
        if (firstNameTextField.text != "") && (lastNameTextField.text != "") && (addressTextField.text != "") && (emailTextField.text != "") {
            
            if let ticketData = myTicket {
                // generate PDF
//                generatePDF(ticketData)
                
                // find current directory path
                let path:NSArray = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
                println(path.objectAtIndex(0))
                

//                var pdfPath = path.objectAtIndex(0).stringByAppendingPathComponent("hahaPDF.pdf")
//                var myData = NSData(contentsOfFile: pdfPath)

                
                //send to parse
                let ticketObject = PFObject(className: "Ticket")
//                ticketObject["ticketPDF"] = PFFile(data: myData!)
                ticketObject["ticketPicture"] = PFFile(data: ticketData.ticketPicture)
                ticketObject["evidencePicture"] = PFFile(data: ticketData.evidencePicture)
                ticketObject["explanationText"] = ticketData.explanationText
                ticketObject["firstName"] = ticketData.firstName
                ticketObject["lastName"] = ticketData.lastName
                ticketObject["mailingAddress"] = ticketData.mailingAddress
                ticketObject["mailingAddress2"] = ticketData.mailingAddress2
                ticketObject["email"] = ticketData.email
                ticketObject["user"] = PFUser.currentUser()
                mixpanel.timeEvent("Ticket Upload")
                if Reachability.isConnectedToNetwork() == true {
                    ticketObject.saveInBackgroundWithBlock({ (success, ErrorHandling) -> Void in
                        println("sent ticket to Parse")
                        if let ticket = self.myTicket {
                            self.realm.write() {
                                ticketData.finishedUploading = true
                                ticketData.parseObjectID = ticketObject.objectId!
                                self.mixpanel.track("Ticket Upload")
                                self.realm.add(ticket, update: true)
                            }
                        }
                    })
                    self.performSegueWithIdentifier("submitContactInfo", sender: self)
                } else {
                    refreshButton()
                }
                println("let's take a look at the ticket object: \(ticketObject)")
            }
            
        } else {
            determineNextButtonFunction()
        }
    }
    
    func applicationWillEnterForeground(notification: NSNotification) {
        println("did enter foreground")
        refreshButton()
    }

    
    func refreshButton(){
        println("refresh")
        if (Reachability.isConnectedToNetwork() == true) {
            nextButton.backgroundColor = paletteBlue
            disclaimerText.text = "We only ask for this info once"
            nextButton.setTitle("Next", forState: UIControlState.Normal)
        } else {
            nextButton.backgroundColor = paletteRed
            disclaimerText.text = "Hmmm... No internet connection."
            nextButton.setTitle("Retry", forState: UIControlState.Normal)
        }
    }
    
    func determineNextButtonFunction() {
        
        // first name
        if ((firstNameTextField.isFirstResponder() == true) && (lastNameTextField.text == "")) {
            lastNameTextField.becomeFirstResponder()
        } else if ((firstNameTextField.isFirstResponder() == true) && (emailTextField.text == "")) {
            emailTextField.becomeFirstResponder()
        } else if ((firstNameTextField.isFirstResponder() == true) && (addressTextField.text == "")){
            addressTextField.becomeFirstResponder()
        } else if ((firstNameTextField.isFirstResponder() == true) && (address2TextField.text == "")){
            address2TextField.becomeFirstResponder()
        }
            // last name
        else if ((lastNameTextField.isFirstResponder() == true) && (firstNameTextField.text == "")) {
            emailTextField.becomeFirstResponder()
        } else if ((lastNameTextField.isFirstResponder() == true) && (emailTextField.text == "")) {
            emailTextField.becomeFirstResponder()
        }else if ((lastNameTextField.isFirstResponder() == true) && (addressTextField.text == "")){
            addressTextField.becomeFirstResponder()
        } else if ((lastNameTextField.isFirstResponder() == true) && (address2TextField.text == "")){
            address2TextField.becomeFirstResponder()
        }
            // address 2
        else if ((address2TextField.isFirstResponder() == true) && (firstNameTextField.text == "")) {
            firstNameTextField.becomeFirstResponder()
        } else if ((address2TextField.isFirstResponder() == true) && (lastNameTextField.text == "")) {
            lastNameTextField.becomeFirstResponder()
        } else if ((address2TextField.isFirstResponder() == true) && (emailTextField.text == "")) {
            emailTextField.becomeFirstResponder()
        } else if ((address2TextField.isFirstResponder() == true) && (addressTextField.text == "")) {
            addressTextField.becomeFirstResponder()
        }
        
    }
    @IBAction func helpButton(sender: AnyObject) {
        FeedBackMailer.sharedInstance.sendFeedback()
    }
    
}
extension ContactInfoViewController: GooglePlacesAutocompleteDelegate {
    func placeSelected(place: Place) {
        println(place.description)
        
        place.getDetails { details in
            println(details)
        }
        dismissViewControllerAnimated(true) { () -> Void in
            self.addressTextField.text = place.description
            self.address2TextField.becomeFirstResponder()
        }
    }
    
    func placeViewClosed() {
        dismissViewControllerAnimated(true, completion: nil)
    }
}