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
        
        var ticket: Ticket? {
            didSet {
                if let ticket = ticket, explanationTextView = explanationTextView {
                    self.explanationTextView.text = ticket.explanationText
                }
            }
        }
        
        let sampleTicket = Ticket()
        sampleTicket.explanationText   = "Super Simple Test Note"
        
        println("excuse for sampleTicket is: \(sampleTicket.explanationText)")
//        explanationTextView.text = "Hello"
        
        let realm = Realm() // 1
        realm.write() { // 2
            realm.add(sampleTicket) // 3
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        explanationTextView.returnKeyType = .Next
        explanationTextView.becomeFirstResponder()
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

