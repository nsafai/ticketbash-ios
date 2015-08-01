//
//  EvidenceCameraViewController.swift
//  TicketBash
//
//  Created by Nicolai Safai on 7/31/15.
//  Copyright (c) 2015 Lime. All rights reserved.
//

import UIKit
import PBJVision

class EvidenceCameraViewController: UIViewController {
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "showCamera2") {
            let cameraViewController = segue.destinationViewController as! CameraViewController
            cameraViewController.delegate = self
            // do anything specific to ticket (different than in explanation)
        }
    }
}

extension EvidenceCameraViewController: CameraViewControllerDelegate {
    func acceptedImage(image: UIImage) {
        // save to realm
        // segue to next view
        self.performSegueWithIdentifier("showExplanationController", sender: self)
    }

}