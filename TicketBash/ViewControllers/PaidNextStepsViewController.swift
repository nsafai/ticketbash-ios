//
//  PaidNextStepsViewController.swift
//  TicketBash
//
//  Created by Nicolai Safai on 8/14/15.
//  Copyright (c) 2015 Lime. All rights reserved.
//

import UIKit

class PaidNextStepsViewController: UIViewController {

    @IBAction func helpButton(sender: AnyObject) {
        FeedBackMailer.sharedInstance.sendFeedback()
    }
   
    @IBAction func paidDismissButton(sender: AnyObject) {
        //pop to root view controller
        self.navigationController!.popToRootViewControllerAnimated(true)
    }
}
