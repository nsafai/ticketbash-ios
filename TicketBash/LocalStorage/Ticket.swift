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
    
    // stored in InstructionsViewController
    dynamic var isFirstTime: Bool = true
    
    // stored in RequestViewController
    dynamic var notificationsEnabled: Bool = false
    
    // stored in TicketOriginViewController
    dynamic var ticketOrigin: String = ""
    
    // stored in CitationCameraViewController
    dynamic var ticketPicture = NSData()
    
    // stored in EvidenceCameraViewController
    dynamic var evidencePicture = NSData()
    
    // stored in ExplanationViewController
    dynamic var explanationText: String = ""
    
    // stored in ContactInfoViewController
    dynamic var firstName: String = ""
    dynamic var lastName: String = ""
    dynamic var mailingAddress: String = ""
    dynamic var mailingAddress2: String = ""
    dynamic var mailingCity: String = ""
    dynamic var mailingState: String = ""
    dynamic var mailingZip: String = ""
    dynamic var phoneNumber: String = ""
    dynamic var parseObjectID: String = ""
    
    
    override class func primaryKey() -> String {
        return "id"
    }
    
    
//    dynamic var modificationDate = NSDate()

}

