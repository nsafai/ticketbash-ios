//
//  TicketOriginViewController.swift
//  TicketBash
//
//  Created by Nicolai Safai on 8/8/15.
//  Copyright (c) 2015 Lime. All rights reserved.
//

import UIKit
import RealmSwift

class TicketOriginViewController: UIViewController {
    
    let realm = Realm()
    var myTicket: Ticket?
    @IBOutlet weak var newYorkButton: UIButton!
    @IBOutlet weak var otherButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = false
        
        var tickets = realm.objects(Ticket)
        
        if let ticket = tickets.first { // if there is a stored value then the 'tickets' array is not nil --> assign the value of the first ticket in the array to 'ticket'
            myTicket = ticket // assign the value of ticket to myTicket
                    } else {
            myTicket = Ticket()
            //            println("created new ticket")
        }

    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func newYorkButton(sender: AnyObject) {
        realm.write { () -> Void in
            self.myTicket?.ticketOrigin = newYorkCity
            self.realm.add(self.myTicket!, update: true)
            println(self.myTicket!.ticketOrigin)
        }
    }
}
