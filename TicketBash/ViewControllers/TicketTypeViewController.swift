//
//  TicketTypeViewController.swift
//  TicketBash
//
//  Created by Nicolai Safai on 12/14/15.
//  Copyright © 2015 Lime. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift
import Parse
import ParseUI

class TicketTypeViewController: UIViewController {
    var myTicket: Ticket?
    
    var buttonPressed: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //boilerplate realm code
        let tickets = realm.objects(Ticket)
        if let ticket = tickets.first {
            myTicket = ticket
        } else {
            myTicket = Ticket()
        }
        
    }
    
    //change ticketType
    @IBAction func helpButton(sender: AnyObject) {
        FeedBackMailer.sharedInstance.sendFeedback()
    }
    
    func chooseDisputeReason(buttonPressed: String) {
        
        try! realm.write { () -> Void in
            self.myTicket?.ticketType = buttonPressed
            realm.add(self.myTicket!, update: true)
            print(self.myTicket!.ticketType)
        }
    }
    /* 
    @IBAction func sanFranciscoButton(sender: AnyObject) {
    
    try! realm.write { () -> Void in
    self.myTicket?.ticketOrigin = sanFranciscoCity
    
    realm.add(self.myTicket!, update: true)
    print(self.myTicket!.ticketOrigin)
    }
    }
    */
    
    @IBAction func meterPaidMalfunction(sender: AnyObject) {
        chooseDisputeReason(meterPaidMalfunctionString)
    }
    @IBAction func vehicleStolen(sender: AnyObject) {
        chooseDisputeReason(stolenVehicleString)
    }
    @IBAction func fixItCitation(sender: AnyObject) {
        chooseDisputeReason(complianceFixItString)
    }
    @IBAction func curbPaintFaded(sender: AnyObject) {
        chooseDisputeReason(curbPaintFadedString)
    }
    @IBAction func vehicleSoldNotOwned(sender: AnyObject) {
        chooseDisputeReason(soldNotOwnedString)
    }
    @IBAction func missingSign(sender: AnyObject) {
        chooseDisputeReason(missingSignString)
    }
    @IBAction func vehiclePermitDisplayed(sender: AnyObject) {
        chooseDisputeReason(validPermitDisplayedString)
    }
    @IBAction func other(sender: AnyObject) {
        chooseDisputeReason(transitOrOtherString)
    }
}

