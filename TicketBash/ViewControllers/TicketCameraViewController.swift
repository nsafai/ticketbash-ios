//
//  TicketCameraViewController.swift
//  TicketBash
//
//  Created by Nicolai Safai on 7/28/15.
//  Copyright (c) 2015 Lime. All rights reserved.
//

import UIKit
import PBJVision
import RealmSwift

class TicketCameraViewController: UIViewController {
    
    let realm = Realm()
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "showCamera") {
            let cameraViewController = segue.destinationViewController as! CameraViewController
            cameraViewController.delegate = self
            // do anything specific to ticket (different than in explanation)
        }
    }
}

extension TicketCameraViewController: CameraViewControllerDelegate {
    func acceptedImage(image: UIImage) {
        
        var myTicket: Ticket?
        // save to realm
        var tickets = self.realm.objects(Ticket)
        if let ticket = tickets.first {
            myTicket = ticket
            //            explanationTextView.text = myTicket!.explanationText
//            println("grabbed ticket from realm")
        } else {
            myTicket = Ticket()
//            println("created new ticket")
        }
        
        
        if let ticket = myTicket {
            self.realm.write() {
                //changes must be done within a write transaction/closure.
                
                var imageData = UIImageJPEGRepresentation(image, 0.8)
                ticket.ticketPicture = imageData
                // change realm image data value to what user just took in camera view controller
                
                self.realm.add(ticket, update: true)
                // 3 Add  new ticket to Realm if none exists, else update it
            }
        }
        self.performSegueWithIdentifier("showEvidenceController", sender: self)
    }
}
