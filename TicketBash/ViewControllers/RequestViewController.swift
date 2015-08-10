//
//  RequestViewController.swift
//  TicketBash
//
//  Created by Nicolai Safai on 8/9/15.
//  Copyright (c) 2015 Lime. All rights reserved.
//

import UIKit
import RealmSwift
import ConvenienceKit

class RequestViewController: UIViewController, UITextFieldDelegate {
    
    var keyboardNotificationHandler: KeyboardNotificationHandler?
    @IBOutlet weak var toolbarBottomSpace: NSLayoutConstraint!
    
    @IBOutlet weak var cityRequestTextField: UITextField!
    @IBOutlet weak var textImageView: UIImageView!
    @IBOutlet weak var confirmationLabel: UILabel!
    
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var notifyButton: UIButton!
    let realm = Realm()
    var myTicket: Ticket?
    
    override func viewDidLoad() {
        cityRequestTextField.delegate = self
        
    }
    
    override func viewWillAppear(animated: Bool) {
        var tickets = realm.objects(Ticket)
        
        if let ticket = tickets.first { // if there is a stored value then the 'tickets' array is not nil --> assign the value of the first ticket in the array to 'ticket'
            myTicket = ticket // assign the value of ticket to myTicket
            
            cityRequestTextField.text = myTicket!.ticketOrigin
        } else {
            myTicket = Ticket()
            //            println("created new ticket")
        }
      
        //polish
        
        confirmationLabel.hidden = true
        notifyButton.hidden = true
//        submitButton.hidden = true
        
        delay(keyboardDelay) {
            cityRequestTextField.becomeFirstResponder()
        }
        
        keyboardNotificationHandler = KeyboardNotificationHandler()
        
        
//        keyboardNotificationHandler!.keyboardWillBeHiddenHandler = { (height: CGFloat) in
//            UIView.animateWithDuration(0.3){
//                self.toolbarBottomSpace.constant = 0
//                self.view.layoutIfNeeded()
//            }
//        }
//        
//        keyboardNotificationHandler!.keyboardWillBeShownHandler = { (height: CGFloat) in
//            UIView.animateWithDuration(0.3) {
//                self.toolbarBottomSpace.constant = -height
//                self.view.layoutIfNeeded()
//            }
//        }
        
        cityRequestTextField .setValue(paletteGrey, forKeyPath: "_placeholderLabel.textColor")
        
        

    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        submitButton.hidden = false
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        submitRequest(self)
        return true
    }

    
    @IBAction func submitRequest(sender: AnyObject) {
        realm.write { () -> Void in
            self.myTicket?.ticketOrigin = self.cityRequestTextField.text
            self.realm.add(self.myTicket!, update: true)
            println(self.myTicket!.ticketOrigin)
        }
        
        confirmationLabel.hidden = false
        
        if (self.myTicket?.notificationsEnabled == true) {
            notifyButton.hidden = false
        }
//        else {
//            notifyButton.hidden = true
//        }
        
        //send to parse
        let requestObject = PFObject(className: "CityRequest")
        requestObject["city"] = self.cityRequestTextField.text
        requestObject["user"] = PFUser.currentUser()
        
        requestObject.saveInBackgroundWithBlock({ (success, ErrorHandling) -> Void in
            println("sent Request to Parse")
            if let ticket = self.myTicket {
                self.realm.write() {
//                    ticketData.parseObjectID = ticketObject.objectId!
                    self.realm.add(ticket, update: true)
                }
            }
        })

        
    }
    
    @IBAction func notifyMe(sender: AnyObject) {
        //registering for sending user various kinds of notifications
        var types: UIUserNotificationType = UIUserNotificationType.Badge |
            UIUserNotificationType.Alert |
            UIUserNotificationType.Sound
        
        var settings: UIUserNotificationSettings = UIUserNotificationSettings( forTypes: types, categories: nil )
        
        UIApplication.sharedApplication().registerUserNotificationSettings( settings )
        UIApplication.sharedApplication().registerForRemoteNotifications()
        
        realm.write { () -> Void in
            self.myTicket?.notificationsEnabled = false
            self.realm.add(self.myTicket!, update: true)
            println(self.myTicket!.ticketOrigin)
        }
        }
    
    
    }
