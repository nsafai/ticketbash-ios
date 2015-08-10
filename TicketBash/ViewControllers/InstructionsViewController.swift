//
//  InstructionsViewController.swift
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

class InstructionsViewController: UIViewController {
    
    let realm = Realm()
    var myTicket: Ticket?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = backgroundColor
    }
    
    override func viewWillAppear(animated: Bool) {
        
//        self.navigationController?.navigationBarHidden = true
        
        var tickets = realm.objects(Ticket)
        
        if let ticket = tickets.first {
            myTicket = ticket
        } else {
            myTicket = Ticket()
        }
        
        realm.write { () -> Void in
            self.myTicket?.ticketOrigin = ""
            
            self.realm.add(self.myTicket!, update: true)
        }
        
        
    }
    
    @IBAction func disputeButton(sender: AnyObject) {
        self.performSegueWithIdentifier("dismissInstructions", sender: self)
        self.navigationController?.navigationBarHidden = false
    }
}