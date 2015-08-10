//
//  InstructionsPages.swift
//  TicketBash
//
//  Created by Nicolai Safai on 8/10/15.
//  Copyright (c) 2015 Lime. All rights reserved.
//

import UIKit
import BMPageViewController


class InstructionsPages: BMPageViewControllerPage {

    @IBOutlet weak var getStartedButton: UIButton!
    

    
    @IBAction func getStarted(sender: AnyObject) {
//        self.performSegueWithIdentifier("dismissInstructions", sender: self)
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            
        })
    }
}
