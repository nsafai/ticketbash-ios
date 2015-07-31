//
//  EvidenceCameraViewController.swift
//  TicketBash
//
//  Created by Nicolai Safai on 7/31/15.
//  Copyright (c) 2015 Lime. All rights reserved.
//

import UIKit
import PBJVision

class EvidenceCameraViewController: UIViewController, PBJVisionDelegate {

    let vision = PBJVision.sharedInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}