//
//  InstructionsViewController.swift
//  TicketBash
//
//  Created by Nicolai Safai on 8/8/15.
//  Copyright (c) 2015 Lime. All rights reserved.
//

import UIKit
import RealmSwift
import Parse
import ParseUI
import BMPageViewController

class InstructionsViewController: BMPageViewController {
    
    override func pageIdentifiers() -> [AnyObject] {
        return ["step1", "step2", "step3", "step4", "step5"]
    }
}