//
//  FeedbackMailer.swift
//  TicketBash
//
//  Created by Nicolai Safai on 8/11/15.
//  Copyright (c) 2015 Lime. All rights reserved.
//

import UIKit
import MessageUI

class FeedBackMailer: UIViewController, MFMailComposeViewControllerDelegate {
    
    let feedbackEmail = "help@ticketbash.xyz"
    
    class var sharedInstance : FeedBackMailer {
        struct Static {
            static let instance : FeedBackMailer = FeedBackMailer()
        }
        return Static.instance
    }
    
    func sendFeedback() {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewControllerFromTopViewController(mailComposeViewController, animated: true, completion: { () -> Void in
                
            })
                //addChildViewController(mailComposeViewController)
//            presentViewController(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device is not set up to send e-mail. Please email us directly at \(feedbackEmail)", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setToRecipients([feedbackEmail])
        mailComposerVC.setSubject("I need some help!")
        mailComposerVC.setMessageBody("Description of my problem:", isHTML: false)
        
        return mailComposerVC
    }
    
    
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
}