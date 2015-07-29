//
//  Ticket.swift
//  TicketBash
//
//  Created by Nicolai Safai on 7/28/15.
//  Copyright (c) 2015 Lime. All rights reserved.
//

import UIKit
import RealmSwift

class Ticket: Object {
    dynamic var id = 0
    
    dynamic var explanationText: String = ""
    
//    dynamic var user: NSData!
//    dynamic var ticketPicture: NSData!
//    dynamic var evidencePicture: NSData!
//    
//    dynamic var mailingAddress: String = ""
//    dynamic var mailingCity: String = ""
//    dynamic var mailingZip: String = ""
//    dynamic var mailingState: String = ""
//    
//    dynamic var modificationDate = NSDate()


    override class func primaryKey() -> String {
        return "id"
    }


}

