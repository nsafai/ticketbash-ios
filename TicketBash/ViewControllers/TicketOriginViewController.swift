//
//  TicketOriginViewController.swift
//  TicketBash
//
//  Created by Nicolai Safai on 8/8/15.
//  Copyright (c) 2015 Lime. All rights reserved.
//

import UIKit
import Realm
import RealmSwift
import Parse
import ParseUI
import MessageUI

class TicketOriginViewController: UIViewController {
    

    
    var parseLoginHelper: ParseLoginHelper!
    let loginViewController = PFLogInViewController()
    var myTicket: Ticket?
    @IBOutlet weak var newYorkButton: UIButton!
    @IBOutlet weak var sanFranciscoButton: UIButton!
    @IBOutlet weak var otherButton: UIButton!
    @IBOutlet weak var howItWorksButton: UIButton!
    @IBOutlet weak var parkingMeterImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // realm migration
//        RLMRealm.migrateRealm(RLMRealmConfiguration.defaultConfiguration())
        
//        setSchemaVersion(1, realmPath: Realm.defaultPath, migrationBlock: { migration, oldSchemaVersion in
//            if oldSchemaVersion < 1 { }
//        })

        
        print("Hello from TicketOriginViewController")
        var tickets = realm.objects(Ticket)
        if let ticket = tickets.first { // if there is a stored value then the 'tickets' array is not nil --> assign the value of the first ticket in the array to 'ticket'
            myTicket = ticket // assign the value of ticket to myTicket
        } else {
            myTicket = Ticket()
            //            println("created new ticket")
        }
        
        try! realm.write({ () -> Void in
            self.myTicket?.isFirstTime == true
            realm.add(self.myTicket!, update: true)
        })
        try! realm.write({ () -> Void in
            if self.myTicket?.isFirstTime == true {
//                self.navigationController?.navigationBarHidden = false
                self.performSegueWithIdentifier("showInstructions", sender: self)
                self.myTicket?.isFirstTime = false
            }
            realm.add(self.myTicket!, update: true)
        })
        
        if UIScreen.mainScreen().bounds.size.height == 480 {
            // iPhone 4S
//            self.howItWorksButton.hidden = true
            self.parkingMeterImage.hidden = true
        }  else if UIScreen.mainScreen().bounds.size.height == 568 {
            // iPhone 5
            self.parkingMeterImage.hidden = true
        }
    }
    
    override func viewWillAppear(animated: Bool) {
//        self.navigationController?.navigationBarHidden = false
        
        var user = PFUser.currentUser()
        if (user != nil) {
            // someone is logged in
            print(PFUser.currentUser())
        } else {
            // no one is logged in, create an automatic user
            PFUser.enableAutomaticUser()
            PFUser.currentUser()?.saveInBackgroundWithBlock({ (sucess, ErrorHandling) -> Void in
                print(PFUser.currentUser())
            })
            
        }
    }
    
    @IBAction func howItWorks(sender: AnyObject) {
        self.performSegueWithIdentifier("showInstructions", sender: self)
    }
    @IBAction func newYorkButton(sender: AnyObject) {
        
        try! realm.write { () -> Void in
            self.myTicket?.ticketOrigin = newYorkCity
            
            realm.add(self.myTicket!, update: true)
            print(self.myTicket!.ticketOrigin)
        }
    }
    @IBAction func sanFranciscoButton(sender: AnyObject) {
        
        try! realm.write { () -> Void in
            self.myTicket?.ticketOrigin = sanFranciscoCity
            
            realm.add(self.myTicket!, update: true)
            print(self.myTicket!.ticketOrigin)
        }
    }
    
    @IBAction func helpButton(sender: AnyObject) {
        FeedBackMailer.sharedInstance.sendFeedback()
    }
}
