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
            
            // generate PDF
            generatePDF(ticketData)
            
            // find current directory path
            let path:NSArray = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
            println(path.objectAtIndex(0))
            let currentDirectoryPath = NSFileManager.defaultManager().currentDirectoryPath // this returns "/"
            let currentDirPathString: AnyObject = path.objectAtIndex(0) // this returns absolute path /Users/Nicolai/[...]
            
            // TODO: convert PDF to NSData to upload to Parse
            var pdfPath = path.objectAtIndex(0).stringByAppendingPathComponent("hahaPDF.pdf")
            var PDFUrl = NSURL(string: pdfPath)            //convert pdfPath string to NSURL
            var myData = NSData(contentsOfURL: PDFUrl!)
            
            
            var pdfData: NSData! = NSFileManager.defaultManager().contentsAtPath("\(path)/hahaPDF.pdf")
            
            //send to parse
            let ticketObject = PFObject(className: "Ticket")
            //            var testPDF: NSData!
            //            testPDF = NSData("testPDF")
//            ticketObject["ticketPDF"] = PFFile(data: pdfData)
            ticketObject["ticketPicture"] = PFFile(data: ticketData.ticketPicture)
            ticketObject["evidencePicture"] = PFFile(data: ticketData.evidencePicture)
            ticketObject["explanationText"] = ticketData.explanationText
            ticketObject["mailingAddress"] = ticketData.mailingAddress
            ticketObject["mailingCity"] = ticketData.mailingCity
            ticketObject["mailingState"] = ticketData.mailingState
            ticketObject["mailingZip"] = ticketData.mailingZip
            ticketObject["phoneNumber"] = ticketData.phoneNumber
            ticketObject["user"] = PFUser.currentUser()
            ticketObject.saveInBackgroundWithBlock({ (success, ErrorHandling) -> Void in
            })
            
            println("sent ticket to Parse")
        }
    }
    
    func generatePDF (ticketData: Ticket) {
        let pdfGenerator = JLPDFGenerator()
        
        // style setup
        
        let nameFont = UIFont(name:"HelveticaNeue", size: 20.0)
        let paraFont = UIFont(name: "HelveticaNeue-Light",
            size: 15.0)
        let black = UIColor.blackColor()
        let center = NSTextAlignment.Center
        let right = NSTextAlignment.Right
        let left = NSTextAlignment.Left
        var size: CGSize = CGSizeMake(850, 1100)
        let verticalMargin: Float = 100
        let horizontalMargin: Float = 75
        
        let toAddress = "NYC Department of Finance\n" +
                        "Hearings By Mail Unit\n" +
                        "P.O. Box 29021\n" +
                        "Cadman Plaza Station\n" +
                        "Brooklyn, NY 11202-9021"
        let openingNotes = "\n\n\n\nTo Whom It May Concern\n\nI'm writing you to contest my parking ticket. Please find my parking ticket and evidence attached. "
        
        // create pdf
        pdfGenerator.setupPDFDocumentNamed("hahaPDF", withSize: size)
        
        
        // add first page
        pdfGenerator.beginPDFPage()
        
        // add content
        //// header
        pdfGenerator.addText("\(ticketData.firstName) \(ticketData.lastName)", withFrame: CGRectMake(0,77,850,1100), withFont: nameFont, withColor: black, textAlignment: center, verticalAlignment: 0)
        pdfGenerator.addText("\(ticketData.mailingAddress), \(ticketData.mailingCity), \(ticketData.mailingState), \(ticketData.mailingZip)\ntel: \(ticketData.phoneNumber)", withFrame: CGRectMake(0,100,850,1100), withFont: paraFont, withColor: black, textAlignment: center, verticalAlignment: 0)
        //// draw lines
        pdfGenerator.addLineFromPoint(CGPointMake(75, 150), toEndPoint: CGPointMake(775, 150), withColor: black, andWidth: 0.5)
        
        //// body
        pdfGenerator.addText("\(toAddress)\(openingNotes)\(ticketData.explanationText)\n\nSincerely,\n\n\(ticketData.firstName) \(ticketData.lastName)\n\(ticketData.phoneNumber)", withFrame: CGRectMake(75, 200, 775, 1100), withFont: paraFont, withColor: black, textAlignment: left, verticalAlignment: 0)
        
        //// footer
        pdfGenerator.addLineFromPoint(CGPointMake(75, 1000), toEndPoint: CGPointMake(775, 1000), withColor: black, andWidth: 0.5)
        pdfGenerator.addText("Page 1 of 3", withFrame: CGRectMake(0,1025,775,1100), withFont: paraFont, withColor: black, textAlignment: right, verticalAlignment: 0)
        // save pdf, or if it exists, update it
        pdfGenerator.finishPDF()
    }
}