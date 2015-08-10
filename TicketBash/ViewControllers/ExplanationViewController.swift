//
//  ExplanationViewController.swift
//  TicketBash
//
//  Created by Nicolai Safai on 7/27/15.
//  Copyright (c) 2015 Lime. All rights reserved.
//

import UIKit
import RealmSwift
import FBSDKCoreKit
import Parse
import ParseUI
import FBSDKLoginKit
import ParseFacebookUtils

class ExplanationViewController: UIViewController, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate, UITextViewDelegate {
    
    
    let placeholderText: String = "Enter text here…. Why did you NOT deserve the parking ticket?"
    
    @IBOutlet weak var explanationTextView: UITextView!
    var myTicket: Ticket?
    let realm = Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationItem.hidesBackButton = true
        self.navigationController?.navigationBarHidden = false
        
        explanationTextView.delegate = self
        explanationTextView.text = self.placeholderText
        explanationTextView.textColor = UIColor.lightGrayColor()
        
        delay(2.5) {
            explanationTextView.becomeFirstResponder()
        }

        
        var tickets = realm.objects(Ticket)
        if let ticket = tickets.first {
            myTicket = ticket
//            explanationTextView.text = myTicket!.explanationText
        } else {
            myTicket = Ticket()
        }
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.text == placeholderText {
            textView.text = ""
            textView.textColor = paletteWhite
        }
        textView.becomeFirstResponder()
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if textView.text == "" {
            textView.text = placeholderText
            textView.textColor = paletteGrey
        }
        textView.resignFirstResponder()
    }
    
    @IBAction func nextButton(sender: AnyObject) {
        
        if let ticket = self.myTicket {
            self.realm.write() { //changes must be done within a write transaction/closure.
                ticket.explanationText = self.explanationTextView.text // change realm text value to what user just wrote in text view
                self.realm.add(ticket, update: true) // 3 Add  new ticket to Realm if none exists, else update it
            }
        }
        self.performSegueWithIdentifier("showContactInfo", sender: self)
    }
}

   