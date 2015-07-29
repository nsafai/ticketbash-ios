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

class ExplanationViewController: UIViewController, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate {
    
    @IBOutlet weak var explanationTextView: UITextView!
    var myTicket: Ticket?
    let realm = Realm()
    var parseLoginHelper: ParseLoginHelper!
    let loginViewController = PFLogInViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.parseLoginHelper = ParseLoginHelper {[unowned self] user, error in // Initialize the ParseLoginHelper with a callback
            
            if let error = error {
                ErrorHandling.defaultErrorHandler(error)
                println("Error logging in \(user)")
            } else if let user = user {
                // login was successful
                println("CASE 1 Logged in user is \(user)")
                self.dismissViewControllerAnimated(true, completion: nil)
                self.performSegueWithIdentifier("showContactInfo", sender: self)
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        explanationTextView.returnKeyType = .Next
        explanationTextView.becomeFirstResponder()
        
        var tickets = realm.objects(Ticket)
        
        if let ticket = tickets.first {
            myTicket = ticket
            explanationTextView.text = myTicket!.explanationText
            println("grabbed ticket from realm")
        } else {
            myTicket = Ticket()
            println("created new ticket")
        }
        
    }
    
    @IBAction func nextButton(sender: AnyObject) {
        
        // code that used to be in IBAction
        if let ticket = self.myTicket {
            self.realm.write() { //changes must be done within a write transaction/closure.
                ticket.explanationText = self.explanationTextView.text // change realm text value to what user just wrote in text view
                self.realm.add(ticket, update: true) // 3 Add  new ticket to Realm if none exists, else update it

        let user = PFUser.currentUser()
        if (user != nil) {
            // someone is logged in
            println("CASE 2 Logged in user is \(user)")
            self.performSegueWithIdentifier("showContactInfo", sender: self)
            
        } else {
            // no one is logged in
            
            self.loginViewController.fields = .UsernameAndPassword | .LogInButton | .SignUpButton | .PasswordForgotten | .Facebook
            self.loginViewController.delegate = self.parseLoginHelper
            self.loginViewController.signUpController?.delegate = self.parseLoginHelper
            
            // present login view controller modally
//            self.navigationController?.pushViewController(self.loginViewController, animated: true)
            self.presentViewController(self.loginViewController, animated: true, completion: nil)
//            
                }
            }
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

