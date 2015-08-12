//
//  NextStepsViewController.swift
//  TicketBash
//
//  Created by Nicolai Safai on 8/11/15.
//  Copyright (c) 2015 Lime. All rights reserved.
//

import UIKit

class NextStepsViewController: UIViewController {

    @IBAction func helpButton(sender: AnyObject) {
        FeedBackMailer.sharedInstance.sendFeedback()
    }
}
