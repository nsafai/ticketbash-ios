//
//  HomeViewController.swift
//  TicketBash
//
//  Created by Nicolai Safai on 8/8/15.
//  Copyright (c) 2015 Lime. All rights reserved.
//

import UIKit
import RealmSwift
import FBSDKCoreKit
import Parse
import ParseUI
import FBSDKLoginKit
import ParseFacebookUtils

class HomeViewController: UIViewController {
    
    let realm = Realm()
    var myTicket: Ticket?

    var parseLoginHelper: ParseLoginHelper!
    let loginViewController = PFLogInViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = backgroundColor
        // Do any additional setup after loading the view.
        
        
        self.parseLoginHelper = ParseLoginHelper {[unowned self] user, error in // Initialize the ParseLoginHelper with a callback
            
            if let error = error {
                ErrorHandling.defaultErrorHandler(error)
                //                println("Error logging in \(user)")
            } else if let user = user {
                // code below indicates what should happen if PFLogInViewController succesfully logs in a user
                //                println("CASE 1 Logged in user is \(user)")
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }
    
        override func viewWillAppear(animated: Bool) {
            self.navigationController?.navigationBarHidden = true
            
            var tickets = realm.objects(Ticket)
            
            if let ticket = tickets.first { // if there is a stored value then the 'tickets' array is not nil --> assign the value of the first ticket in the array to 'ticket'
                myTicket = ticket // assign the value of ticket to myTicket
            } else {
                myTicket = Ticket()
                //            println("created new ticket")
            }
            realm.write { () -> Void in
                self.myTicket?.ticketOrigin = ""
                self.realm.add(self.myTicket!, update: true)
                println(self.myTicket!.ticketOrigin)
            }
            
            
            let user = PFUser.currentUser()
            if (user != nil) {
                // someone is logged in
                //            println("CASE 2 Logged in user is \(user)")
                //            self.performSegueWithIdentifier("showContactInfo", sender: self)
                
            } else {
                // no one is logged in
                
                self.loginViewController.fields = .UsernameAndPassword | .LogInButton | .SignUpButton | .PasswordForgotten
                // add | .Facebook for Facebook
                self.loginViewController.emailAsUsername = true
                var logInLogoTitle = UILabel()
                logInLogoTitle.text = "Ticket Bash"
                logInLogoTitle.font = UIFont(name: "HelveticaNeue-UltraLight",
                    size: 70.0)
                
                self.loginViewController.logInView?.logo = logInLogoTitle
                self.loginViewController.delegate = self.parseLoginHelper
                self.loginViewController.signUpController?.delegate = self.parseLoginHelper
                
                // present login view controller modally
                self.presentViewController(self.loginViewController, animated: true, completion: nil)
                //            self.navigationController?.pushViewController(self.loginViewController, animated: true)
            }
    }
    
}