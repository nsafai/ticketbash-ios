//
//  Delay.swift
//  TicketBash
//
//  Created by Nicolai Safai on 8/9/15.
//  Copyright (c) 2015 Lime. All rights reserved.
//

import Foundation

func delay(delay:Double, closure:()->()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(), closure)
}