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
    
    func viewDidLoad(animated: Bool) {
        super.viewDidLoad()
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        explanationTextView.returnKeyType = .Next
        explanationTextView.becomeFirstResponder()
        
        var ticket: Ticket? {
            didSet {
                if let ticket = ticket, explanationTextView = explanationTextView {
                    explanationTextView.text = ticket.explanationText
                }
            }
        }
        
        //testing
        let sampleTicket = Ticket()
        sampleTicket.explanationText   = "Super Simple Test Note"
        println("excuse for sampleTicket is: \(sampleTicket.explanationText)")
        
        let realm = Realm() // 1 Before you can add it to Realm you must first grab the default Realm.
        realm.write() { // 2 All changes to an object (addition, modification and deletion) must be done within a write transaction/closure.
            realm.add(sampleTicket) // 3 Add your new note to Realm
        }

    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

