//
//  InstructionsViewController.swift
//  TicketBash
//
//  Created by Nicolai Safai on 8/8/15.
//  Copyright (c) 2015 Lime. All rights reserved.
//

import UIKit
import RealmSwift
import FBSDKCoreKit
import Parse
import ParseUI
import FBSDKLoginKit
import ParseFacebookUtils
import BMPageViewController

class InstructionsViewController: BMPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    override func pageIdentifiers() -> [AnyObject] {
        return ["step1", "step2", "step3", "step4"]
    }
    
    func viewWillAppear() {
        println("intructions view controller did appear")
    }
}