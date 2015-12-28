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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func helpButton(sender: AnyObject) {
        FeedBackMailer.sharedInstance.sendFeedback()
    }
}
