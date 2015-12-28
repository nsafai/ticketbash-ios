//
//  EvidenceCameraViewController.swift
//  TicketBash
//
//  Created by Nicolai Safai on 7/31/15.
//  Copyright (c) 2015 Lime. All rights reserved.
//

import UIKit
import PBJVision
import RealmSwift

class EvidenceCameraViewController: UIViewController {
    var myTicket: Ticket?
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        CameraViewController().vision.stopPreview()
        if (segue.identifier == "showCamera2") {
            let cameraViewController = segue.destinationViewController as! CameraViewController
            cameraViewController.delegate = self
            // do anything specific to ticket (different than in explanation)
        }
    }
    @IBAction func helpButton(sender: AnyObject) {
        
        FeedBackMailer.sharedInstance.sendFeedback()
    }
}

extension EvidenceCameraViewController: CameraViewControllerDelegate {
    func acceptedImage(image: UIImage) {
        // save to realm
        var tickets = realm.objects(Ticket)
        if let ticket = tickets.first {
            myTicket = ticket
        } else {
            myTicket = Ticket()
        }
        
        if let ticket = self.myTicket {
            try! realm.write() { //changes must be done within a write transaction/closure.
                var imageData = UIImageJPEGRepresentation(image, 0.5)
                ticket.evidencePicture =  imageData! // change realm image data value to what user just took in camera view controller
                realm.add(ticket, update: true) // 3 Add  new ticket to Realm if none exists, else update it
            }
        }
        // segue to next view
        self.performSegueWithIdentifier("showTicketController", sender: self)
    }
}