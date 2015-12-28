//
//  SubmitViewController.swift
//  TicketBash
//
//  Created by Nicolai Safai on 7/31/15.
//  Copyright (c) 2015 Lime. All rights reserved.
//

import UIKit
import RealmSwift

class SubmitViewController: UIViewController {
    
    // local storage
    var myTicket: Ticket?
    
    @IBOutlet weak var freeButtonDisclaimer: UILabel!
    @IBOutlet weak var paidButtonDisclaimer: UILabel!
    @IBOutlet weak var freeButton: UIButton!
    @IBOutlet weak var paidButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        
        let tickets = realm.objects(Ticket)
        
        if let ticket = tickets.first { // if there is a stored value then the 'tickets' array is not nil --> assign the value of the first ticket in the array to 'ticket'
            myTicket = ticket // assign the value of ticket to myTicket
            print("grabbed ticket from realm")
        } else {
            myTicket = Ticket()
            print("created new ticket")
        }
    }
    func refreshButton() {
        print("refresh")
        if (Reachability.isConnectedToNetwork() == true) {
            freeButton.backgroundColor = paletteGrey
            freeButtonDisclaimer.text = "You print it, address it, stamp it & send it"
            freeButton.setTitle("I'll do the work myself - Free", forState: UIControlState.Normal)
        } else {
            freeButton.backgroundColor = paletteRed
            freeButtonDisclaimer.text = "Hmmm... No internet connection."
            freeButton.setTitle("Retry", forState: UIControlState.Normal)
        }
    }
    func refreshButton2() {
        print(")refreshed paid button")
        if (Reachability.isConnectedToNetwork() == true) {
            paidButton.backgroundColor = paletteOrange
            paidButtonDisclaimer.text = "Let us do the work... Relax!"
            paidButton.setTitle("We mail it for you - $3", forState: UIControlState.Normal)
        } else {
            paidButton.backgroundColor = paletteRed
            paidButtonDisclaimer.text = "Hmmm... No internet connection."
            paidButton.setTitle("Retry", forState: UIControlState.Normal)
        }
    }
    @IBAction func freeButton(sender: AnyObject) {
        
        if (Reachability.isConnectedToNetwork() == true) {
            sendTicketData()
            self.performSegueWithIdentifier("freeSegue", sender:self)
        } else {
            refreshButton()
        }
        print(myTicket)
    }
    @IBAction func paidOption(sender: AnyObject) {
        
        if (Reachability.isConnectedToNetwork() == true) {
            self.performSegueWithIdentifier("paidSegue", sender:self)
        } else {
            refreshButton2()
        }
        print(myTicket)
    }
    @IBAction func helpButton(sender: AnyObject) {
        FeedBackMailer.sharedInstance.sendFeedback()
    }
    func sendTicketData() {
        let URLstring = "\(Constants.ticketbashBaseURL)/api/v0/process_ticket?parse_id=\(self.myTicket!.parseObjectID)"
        
        // 5
        let url = NSURL(string: URLstring)  // Replace with your server or computer's local IP Address!
        
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        var error: NSError?
        
        // 7
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response, data, error) -> Void in
            if (error != nil) {
                //failure
            } else {
                //sucess
            }
        }
    }
}