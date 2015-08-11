//
//  TicketOriginViewController.swift
//  TicketBash
//
//  Created by Nicolai Safai on 8/8/15.
//  Copyright (c) 2015 Lime. All rights reserved.
//

import UIKit
import RealmSwift
import Parse
import ParseUI

class TicketOriginViewController: UIViewController {
    
    var parseLoginHelper: ParseLoginHelper!
    let loginViewController = PFLogInViewController()
    let realm = Realm()
    var myTicket: Ticket?
    @IBOutlet weak var newYorkButton: UIButton!
    @IBOutlet weak var otherButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        self.parseLoginHelper = ParseLoginHelper {[unowned self] user, error in // Initialize the ParseLoginHelper with a callback
//            
//            if let error = error {
//                ErrorHandling.defaultErrorHandler(error)
//                //                println("Error logging in \(user)")
//            } else if let user = user {
//                // code below indicates what should happen if PFLogInViewController succesfully logs in a user
//                //                println("CASE 1 Logged in user is \(user)")
//                self.dismissViewControllerAnimated(true, completion: nil)
//            }
//        }

        var tickets = realm.objects(Ticket)
        if let ticket = tickets.first { // if there is a stored value then the 'tickets' array is not nil --> assign the value of the first ticket in the array to 'ticket'
            myTicket = ticket // assign the value of ticket to myTicket
        } else {
            myTicket = Ticket()
            //            println("created new ticket")
        }
        
        realm.write({ () -> Void in
                self.myTicket?.isFirstTime == true
                self.realm.add(self.myTicket!, update: true)
        })
        realm.write({ () -> Void in
            if self.myTicket?.isFirstTime == true {
                self.navigationController?.navigationBarHidden = false
                self.performSegueWithIdentifier("showInstructions", sender: self)
                self.myTicket?.isFirstTime = false
            }
            self.realm.add(self.myTicket!, update: true)
        })
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = false
        
        var user = PFUser.currentUser()
        if (user != nil) {
            // someone is logged in
            //            println("CASE 2 Logged in user is \(user)")
            //            self.performSegueWithIdentifier("showContactInfo", sender: self)
            println(PFUser.currentUser())
        } else {
            // no one is logged in, create an automatic user
            PFUser.enableAutomaticUser()
            PFUser.currentUser()?.saveInBackgroundWithBlock({ (sucess, ErrorHandling) -> Void in
                println(PFUser.currentUser())
            })
            
//            self.loginViewController.fields = .UsernameAndPassword | .LogInButton | .SignUpButton | .PasswordForgotten
//            // add | .Facebook for Facebook
//            self.loginViewController.emailAsUsername = true
//            var logInLogoTitle = UILabel()
//            logInLogoTitle.text = "Ticket Bash"
//            logInLogoTitle.font = UIFont(name: "HelveticaNeue-UltraLight",
//                size: 70.0)
//            
//            self.loginViewController.logInView?.logo = logInLogoTitle
//            self.loginViewController.delegate = self.parseLoginHelper
//            self.loginViewController.signUpController?.delegate = self.parseLoginHelper
//            
//            // present login view controller modally
//            self.presentViewController(self.loginViewController, animated: true, completion: nil)
//                        self.navigationController?.pushViewController(self.loginViewController, animated: true)
        }
    }
    
    @IBAction func newYorkButton(sender: AnyObject) {
        realm.write { () -> Void in
            self.myTicket?.ticketOrigin = newYorkCity
            
            self.realm.add(self.myTicket!, update: true)
            println(self.myTicket!.ticketOrigin)
        }
    }
}
