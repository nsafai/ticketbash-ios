//
//  ExplanationViewController.swift
//  TicketBash
//
//  Created by Nicolai Safai on 7/27/15.
//  Copyright (c) 2015 Lime. All rights reserved.
//

import UIKit
import RealmSwift
import Parse
import ParseUI

class ExplanationViewController: UIViewController, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate, UITextViewDelegate {
    
    
    let placeholderText: String = "Keep in mind that whatever you type will end up directly on your dispute. Keep it formal, include any relevant evidence (like permit numbers), and avoid spelling mistakes!"
    
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var explanationTextView: UITextView!
    var myTicket: Ticket?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showButton()
    }
    
    override func viewWillAppear(animated: Bool) {
//        self.navigationItem.hidesBackButton = true
//        self.navigationController?.navigationBarHidden = false
        
        nextButton.hidden = true
        
        explanationTextView.delegate = self
        explanationTextView.text = self.placeholderText
        
//        delay(instructionsDelay) {
//            explanationTextView.becomeFirstResponder()
//        }

        
        let tickets = realm.objects(Ticket)
        if let ticket = tickets.first {
            myTicket = ticket
            if (explanationTextView.text != "") {
                explanationTextView.text = myTicket!.explanationText
            }
            
        } else {
            myTicket = Ticket()
            // first time user is seeing this screen        
        }
        // this code needs to be below realm code above
        showButton()
//        if explanationTextView.text == "" {
//            explanationTextView.text = placeholderText
//            explanationTextView.textColor = paletteGrey
//        }
        self.explanationTextView.becomeFirstResponder()
//        self.explanationTextView!.layer.borderWidth = 1
//        self.explanationTextView!.layer.borderColor = paletteWhite.CGColor
    }
    func showButton() {
        if (explanationTextView.text == "") || (explanationTextView.text == self.placeholderText) {
            nextButton.hidden = true
        } else {
            nextButton.hidden = false
        }
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.text == placeholderText {
            textView.text = ""
            textView.textColor = paletteWhite
        }
        textView.becomeFirstResponder()
    }
    
    func textViewDidChange(textView: UITextView) {
        showButton()
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        
        textView.resignFirstResponder()
    }
    
    @IBAction func nextButton(sender: AnyObject) {
        
        if let ticket = self.myTicket {
            
            try! realm.write() { //changes must be done within a write transaction/closure.
                ticket.explanationText = self.explanationTextView.text // change realm text value to what user just wrote in text view
                realm.add(ticket, update: true) // 3 Add  new ticket to Realm if none exists, else update it
            }
        }
        self.performSegueWithIdentifier("showContactInfo", sender: self)
    }
    @IBAction func invisibleEdit(sender: AnyObject) {
                explanationTextView.becomeFirstResponder()
    }
    @IBAction func helpButton(sender: AnyObject) {
        FeedBackMailer.sharedInstance.sendFeedback()
    }
}

   