//
//  PaymentViewController.swift
//  TicketBash
//
//  Created by Nicolai Safai on 8/6/15.
//  Copyright (c) 2015 Lime. All rights reserved.
//

import UIKit
import PaymentKit
//import PassKit
import RealmSwift
import Stripe

class PaymentViewController: UIViewController, STPPaymentCardTextFieldDelegate {
    
    //local storage
    var myTicket: Ticket?
    let realm = try! Realm()
    var shippingCost: NSDecimalNumber = 3
    
    @IBOutlet weak var paymentOptionsLabel: UILabel!
    @IBOutlet weak var orLabel: UILabel!
    // credit card (paymentkit)
    var paymentView: STPPaymentCardTextField?
    @IBOutlet weak var creditCardButton: UIButton!
    @IBOutlet weak var creditCardLine: UIImageView!
    
    @IBOutlet weak var disclaimerText: UILabel!
    //apple pay
    @IBOutlet weak var applePayButton: UIButton!
    let SupportedPaymentNetworks = [PKPaymentNetworkVisa, PKPaymentNetworkMasterCard, PKPaymentNetworkAmex]
    let ApplePaySwagMerchantID = "merchant.com.Lime.TicketBash"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "applicationWillEnterForeground:", name: UIApplicationWillEnterForegroundNotification, object: nil)
        
        // Do any additional setup after loading the view.
        applePayButton.hidden = !PKPaymentAuthorizationViewController.canMakePaymentsUsingNetworks(SupportedPaymentNetworks)
        
        if applePayButton.hidden == true {
            orLabel.hidden = true
            paymentOptionsLabel.hidden = true
        }
        
        var tickets = realm.objects(Ticket)
        if let ticket = tickets.first { // if there is a stored value then the 'tickets' array is not nil --> assign the value of the first ticket in the array to 'ticket'
            myTicket = ticket // assign the value of ticket to myTicket
            //            println("grabbed ticket from realm")
        } else {
            myTicket = Ticket()
            //            println("created new ticket")
        }
        
        //credit card text field location adjustment for
        if UIScreen.mainScreen().bounds.size.height == 480 {
            // iPhone 4S
            orLabel.hidden = true
            paymentView = STPPaymentCardTextField(frame: CGRectMake(creditCardLine.frame.origin.x+35, creditCardLine.frame.origin.y+30, 290, 55))
        } else if UIScreen.mainScreen().bounds.size.height == 568 {
            // iPhone 5

            paymentView = STPPaymentCardTextField(frame: CGRectMake(creditCardLine.frame.origin.x+38, creditCardLine.frame.origin.y+118, 290, 55))
        } else if UIScreen.mainScreen().bounds.size.height == 667 {
            // iPhone 6
//            orLabel.hidden = false
            paymentView = STPPaymentCardTextField(frame: CGRectMake(creditCardLine.frame.origin.x+45, creditCardLine.frame.origin.y+216, 290, 55))
        } else if UIScreen.mainScreen().bounds.size.height == 736 {
            // iPhone 6Plus

            paymentView = STPPaymentCardTextField(frame: CGRectMake(creditCardLine.frame.origin.x+55, creditCardLine.frame.origin.y+285, 290, 55))
        }

        
        //        paymentView?.center = view.center
        
        // polish
//        paymentView?.cardNumberField.textColor = paletteWhite
//        paymentView?.cardExpiryField.textColor = paletteWhite
//        paymentView?.cardCVCField.textColor = paletteWhite
//        paymentView?.placeholderView.image = UIImage(named: "line")
        
        paymentView?.delegate = self
        view.addSubview(paymentView!)
        
        creditCardButton!.enabled = false
        creditCardButton.backgroundColor = paletteGrey
        
    }
    //credit card
    func paymentView(paymentView: PTKView!, withCard card: PTKCard!, isValid valid: Bool) {
        creditCardButton!.enabled = valid
        creditCardButton.backgroundColor = paletteBlue
        refreshButton()
    }
    //credit card
    func createToken() {
        let card = STPCard()
        card.number = paymentView!.card!.number
        card.expMonth = paymentView!.card!.expMonth
        card.expYear = paymentView!.card!.expYear
        card.cvc = paymentView!.card!.cvc
        
        STPAPIClient.sharedClient().createTokenWithCard(card, completion: { (token, ErrorHandling) -> Void in
            self.handleToken(token)
        })
    }
    
    //credit card
    func handleToken(token: STPToken!) {
        //send token to backend and create charge
        
                let URLstring = "\(Constants.ticketbashBaseURL)/api/v0/process_ticket?parse_id=\(self.myTicket!.parseObjectID)&stripe_token=\(token!.tokenId)"
        
                // 5
                let url = NSURL(string: URLstring)  // Replace with your server or computer's local IP Address!
        
                let request = NSMutableURLRequest(URL: url!)
                request.HTTPMethod = "POST"
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.setValue("application/json", forHTTPHeaderField: "Accept")
        
                var error: NSError?
        
                // 7
                NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response, data, error) -> Void in
                    if (error != nil) {
                        //failure
                    } else {
                        //sucess
                        self.performSegueWithIdentifier("paymentSucessSegue", sender: self)
                    }
                }
    }
    
    //credit card
    @IBAction func creditCardPurchase(sender: AnyObject) {
        var tickets = realm.objects(Ticket)
        if let ticket = tickets.first {
            if (ticket.finishedUploading == true) {
                refreshButton()
                createToken()
            } else {
                disclaimerText.text = "Please try again in a few seconds. Your dispute is still being uploaded."
            }
        }
    }
    
    //apple pay
    @IBAction func purchase(sender: UIButton) {
        if (Reachability.isConnectedToNetwork()) {
            var tickets = realm.objects(Ticket)
            if let ticket = tickets.first {
                if (ticket.finishedUploading == true) {
                    disclaimerText.text = "Please try again in a few seconds. Your dispute is still being uploaded."
                    let request = PKPaymentRequest()
                    request.merchantIdentifier = ApplePaySwagMerchantID
                    request.supportedNetworks = SupportedPaymentNetworks
                    request.merchantCapabilities = PKMerchantCapability.Capability3DS
                    request.countryCode = "US"
                    request.currencyCode = "USD"
                    
                    request.paymentSummaryItems = [
                        PKPaymentSummaryItem(label: "TicketBash Shipping", amount: shippingCost),
                        //            PKPaymentSummaryItem(label: "Certified Mail", amount: 10)
                    ]
                    
                    let applePayController = PKPaymentAuthorizationViewController(paymentRequest: request)
                    applePayController.delegate = self
                    
                    request.requiredShippingAddressFields = PKAddressField.Email //potentially unnecessary
                    
                    self.presentViewController(applePayController, animated: true, completion: nil)
                    refreshButton()
                }
            } else {
                // there is no object in realm
                disclaimerText.text = "Try again in a minute. Your dispute is being uploaded."
            }

        } else {
            refreshButton()
        }
    }
    @IBAction func helpButton(sender: AnyObject) {
        FeedBackMailer.sharedInstance.sendFeedback()
    }
}

extension PaymentViewController: PKPaymentAuthorizationViewControllerDelegate {
    func paymentAuthorizationViewController(controller: PKPaymentAuthorizationViewController!, didAuthorizePayment payment: PKPayment!, completion: ((PKPaymentAuthorizationStatus) -> Void)!) {
        
        //        // 1
        //        let shippingAddress = self.createShippingAddressFromRef(payment.shippingAddress)
        
        // 2
        Stripe.setDefaultPublishableKey("pk_test_NPRQHdM6jMvSoWV0D74zEdIE")  // Replace With Real Stripe Key
        
        // 3
        STPAPIClient.sharedClient().createTokenWithPayment(payment) {
            (token, error) -> Void in
            
            if (error != nil) {
                print(error)
                completion(PKPaymentAuthorizationStatus.Failure)
                return
            }
            
            //            // 4
            //            let shippingAddress = self.createShippingAddressFromRef(payment.shippingAddress)
            let URLstring = "\(Constants.ticketbashBaseURL)/api/v0/process_ticket?parse_id=\(self.myTicket!.parseObjectID)&stripe_token=\(token!.tokenId)"
            
            // 5
            let url = NSURL(string: URLstring)  // Replace with your server or computer's local IP Address!
            
            let request = NSMutableURLRequest(URL: url!)
            request.HTTPMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            
            // 6
            //            let body: [String:AnyObject] = ["stripeToken": token!.tokenId,
            //                "amount": self.shippingCost,
            //                "description": "TicketBash Shipping Cost",
            //                "shipping": ["city": self.myTicket?.mailingCity,
            //                    "state": self.myTicket?.mailingState,
            //                    "zip": self.myTicket?.mailingZip,
            //                    "firstName": self.myTicket?.firstName,
            //                    "lastName": self.myTicket?.lastName]
            //                // include product ID (Ticket ID) sowe know what was shipped with this purchase
            //            ]
            
            var error: NSError?
            //            request.HTTPBody = NSJSONSerialization.dataWithJSONObject(body, options: NSJSONWritingOptions(), error: &error)
            
            // 7
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response, data, error) -> Void in
                if (error != nil) {
                    completion(PKPaymentAuthorizationStatus.Failure)
                } else {
                    completion(PKPaymentAuthorizationStatus.Success)
                    self.performSegueWithIdentifier("paymentSucessSegue", sender: self)
                }
            }
        }
    }
    
    func paymentAuthorizationViewControllerDidFinish(controller: PKPaymentAuthorizationViewController!) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func refreshButton() {
        print("refresh")
        if (Reachability.isConnectedToNetwork() == true) {
            creditCardButton.backgroundColor = paletteBlue
            disclaimerText.text = "We process all transactions with 256 bit SSL encryption using Stripe.com"
            creditCardButton.setTitle("Pay with Credit Card", forState: UIControlState.Normal)
        } else {
            creditCardButton.backgroundColor = paletteRed
            disclaimerText.text = "Hmmm... No internet connection. Check your internet connection and try again in a few moments."
            creditCardButton.setTitle("Retry", forState: UIControlState.Normal)
        }
    }
    
    func applicationWillEnterForeground(notification: NSNotification) {
        print("did enter foreground")
        refreshButton()
    }
}
