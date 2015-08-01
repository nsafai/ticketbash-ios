//
//  TicketCameraViewController.swift
//  TicketBash
//
//  Created by Nicolai Safai on 7/28/15.
//  Copyright (c) 2015 Lime. All rights reserved.
//

import UIKit
import PBJVision

class TicketCameraViewController: UIViewController {

    
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
        // save to realm
        // segue to next view
        self.performSegueWithIdentifier("showEvidenceController", sender: self)
    }
}
//