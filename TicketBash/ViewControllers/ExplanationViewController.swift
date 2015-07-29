//
//  ExplanationViewController.swift
//  TicketBash
//
//  Created by Nicolai Safai on 7/27/15.
//  Copyright (c) 2015 Lime. All rights reserved.
//

import UIKit
import RealmSwift

class ExplanationViewController: UIViewController {
    
    @IBOutlet weak var explanationTextView: UITextView!
    var myTicket: Ticket?
    let realm = Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        if let ticket = myTicket {
            realm.write() { //changes must be done within a write transaction/closure.
                ticket.explanationText = self.explanationTextView.text // change realm text value to what user just wrote in text view
                self.realm.add(ticket, update: true) // 3 Add  new ticket to Realm if none exists, else update it
            }
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

