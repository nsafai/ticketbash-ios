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

    override func viewDidLoad() {
        super.viewDidLoad()
            
          }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "showCamera") {
            let cameraViewController = segue.destinationViewController as! CameraViewController
            cameraViewController.delegate = self
        }
    }
}

extension TicketCameraViewController: CameraViewControllerDelegate {
    func acceptedImage(image: UIImage) {
        // save to realm
        // segue to next view
    }
}
//        self.performSegueWithIdentifier("showEvidenceCamera", sender: self)