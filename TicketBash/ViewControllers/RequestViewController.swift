//
//  RequestViewController.swift
//  TicketBash
//
//  Created by Nicolai Safai on 8/9/15.
//  Copyright (c) 2015 Lime. All rights reserved.
//

import UIKit
import RealmSwift

class RequestViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var cityRequestTextField: UITextField!
    @IBOutlet weak var textImageView: UIImageView!
    @IBOutlet weak var confirmationLabel: UILabel!
    
    @IBOutlet weak var internetLabel: UILabel!
    @IBOutlet weak var disclaimerLabel: UILabel!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var notifyButton: UIButton!
    let realm = try! Realm()
    var myTicket: Ticket?
    
    override func viewDidLoad() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "applicationWillEnterForeground:", name: UIApplicationWillEnterForegroundNotification, object: nil)
        
        cityRequestTextField.delegate = self
        cityRequestTextField.addTarget(self, action: "textFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
        disclaimerLabel.hidden = true
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        refreshButton()
        var tickets = realm.objects(Ticket)
        cityRequestTextField.text == ""
        submitButton.hidden = true
        
        if let ticket = tickets.first { // if there is a stored value then the 'tickets' array is not nil --> assign the value of the first ticket in the array to 'ticket'
            myTicket = ticket // assign the value of ticket to myTicket
            
//            cityRequestTextField.text = myTicket!.ticketOrigin
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
        cityRequestTextField .setValue(paletteGrey, forKeyPath: "_placeholderLabel.textColor")
    }
    
    func textFieldDidChange(textField: UITextField) {
        showButton()
        if cityRequestTextField.text == "" {
            submitButton.hidden = true
        }
    }
    
    func showButton() {
        if (cityRequestTextField.text == "") {
            submitButton.hidden = true
        } else {
            submitButton.hidden = false
        }
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        submitButton.hidden = false
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        submitRequest(self)
        return true
    }

    
    @IBAction func submitRequest(sender: AnyObject) {
        refreshButton()
        
        
        realm.write { () -> Void in
            self.myTicket?.ticketOrigin = self.cityRequestTextField.text!
            self.realm.add(self.myTicket!, update: true)
            print(self.myTicket!.ticketOrigin)
        }
        
        
        
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
            print("sent Request to Parse")
            if let ticket = self.myTicket {
                self.realm.write() {
//                    ticketData.parseObjectID = ticketObject.objectId!
                    self.realm.add(ticket, update: true)
                }
            }
            self.confirmationLabel.hidden = false
            self.disclaimerLabel.hidden = false
        })
    }
    
    func refreshButton(){
        print("refresh")
        if (Reachability.isConnectedToNetwork() == true) {
            submitButton.backgroundColor = paletteBlue
            internetLabel.hidden = true
            submitButton.setTitle("Submit", forState: UIControlState.Normal)
        } else {
            submitButton.backgroundColor = paletteRed
            internetLabel.text = "Hmmm... No internet connection."
            submitButton.setTitle("Retry", forState: UIControlState.Normal)
        }
    }
    
    func applicationWillEnterForeground(notification: NSNotification) {
        print("did enter foreground")
        refreshButton()
    }

    
    @IBAction func helpButton(sender: AnyObject) {
        FeedBackMailer.sharedInstance.sendFeedback()
    }
    @IBAction func notifyMe(sender: AnyObject) {
        //registering for sending user various kinds of notifications
        var types: UIUserNotificationType = [.Badge, .Alert, .Sound]
        
        var settings: UIUserNotificationSettings = UIUserNotificationSettings( forTypes: types, categories: nil )
        
        UIApplication.sharedApplication().registerUserNotificationSettings( settings )
        UIApplication.sharedApplication().registerForRemoteNotifications()
        
        realm.write { () -> Void in
            self.myTicket?.notificationsEnabled = false
            self.realm.add(self.myTicket!, update: true)
            print(self.myTicket!.ticketOrigin)
        }
    }
}
