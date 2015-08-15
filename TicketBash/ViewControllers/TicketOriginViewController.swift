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
import MessageUI

class TicketOriginViewController: UIViewController {
    
    
    var parseLoginHelper: ParseLoginHelper!
    let loginViewController = PFLogInViewController()
    let realm = Realm()
    var myTicket: Ticket?
    @IBOutlet weak var newYorkButton: UIButton!
    @IBOutlet weak var otherButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
//                self.navigationController?.navigationBarHidden = false
                self.performSegueWithIdentifier("showInstructions", sender: self)
                self.myTicket?.isFirstTime = false
            }
            self.realm.add(self.myTicket!, update: true)
        })
    }
    
    override func viewWillAppear(animated: Bool) {
//        self.navigationController?.navigationBarHidden = false
        
        var user = PFUser.currentUser()
        if (user != nil) {
            // someone is logged in
            println(PFUser.currentUser())
        } else {
            // no one is logged in, create an automatic user
            PFUser.enableAutomaticUser()
            PFUser.currentUser()?.saveInBackgroundWithBlock({ (sucess, ErrorHandling) -> Void in
                println(PFUser.currentUser())
            })
            
        }
    }
    
//    @IBAction func howItWorks(sender: AnyObject) {
//        self.performSegueWithIdentifier("showInstructions", sender: self)
//    }
    @IBAction func newYorkButton(sender: AnyObject) {
        realm.write { () -> Void in
            self.myTicket?.ticketOrigin = newYorkCity
            
            self.realm.add(self.myTicket!, update: true)
            println(self.myTicket!.ticketOrigin)
        }
    }
    @IBAction func helpButton(sender: AnyObject) {
        FeedBackMailer.sharedInstance.sendFeedback()
    }
}
