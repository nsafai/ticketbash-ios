//
//  PaymentViewController.swift
//  TicketBash
//
//  Created by Nicolai Safai on 8/6/15.
//  Copyright (c) 2015 Lime. All rights reserved.
//

import UIKit
import PaymentKit
import PassKit
import RealmSwift
import Stripe

class PaymentViewController: UIViewController, PTKViewDelegate {
    
    //local storage
    var myTicket: Ticket?
    let realm = Realm()
    var shippingCost: NSDecimalNumber = 3
    
    // credit card (paymentkit)
    var paymentView: PTKView?
    @IBOutlet weak var creditCardButton: UIButton!
    @IBOutlet weak var creditCardLine: UIImageView!
    
    //apple pay
    @IBOutlet weak var applePayButton: UIButton!
    let SupportedPaymentNetworks = [PKPaymentNetworkVisa, PKPaymentNetworkMasterCard, PKPaymentNetworkAmex]
    let ApplePaySwagMerchantID = "merchant.com.Lime.TicketBash"


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        applePayButton.hidden = !PKPaymentAuthorizationViewController.canMakePaymentsUsingNetworks(SupportedPaymentNetworks)
        
        var tickets = realm.objects(Ticket)
        if let ticket = tickets.first { // if there is a stored value then the 'tickets' array is not nil --> assign the value of the first ticket in the array to 'ticket'
            myTicket = ticket // assign the value of ticket to myTicket
            //            println("grabbed ticket from realm")
        } else {
            myTicket = Ticket()
            //            println("created new ticket")
        }
        
        //credit card text field location
        paymentView = PTKView(frame: CGRectMake(creditCardLine.frame.origin.x+5, creditCardLine.frame.origin.y+34, 290, 55))
//        paymentView?.center = view.center
        
        // polish
        paymentView?.cardNumberField.textColor = paletteWhite
        paymentView?.cardExpiryField.textColor = paletteWhite
        paymentView?.cardCVCField.textColor = paletteWhite
        paymentView?.placeholderView.image = UIImage(named: "line")
        
        paymentView?.delegate = self
        view.addSubview(paymentView!)
        
        creditCardButton!.enabled = false
        creditCardButton.hidden = true
        
    }
    //credit card
    func paymentView(paymentView: PTKView!, withCard card: PTKCard!, isValid valid: Bool) {
        creditCardButton!.enabled = valid
        creditCardButton.hidden = false
    }
    //credit card
    func createToken() {
        let card = STPCard()
        card.number = paymentView!.card.number
        card.expMonth = paymentView!.card.expMonth
        card.expYear = paymentView!.card.expYear
        card.cvc = paymentView!.card.cvc
        
        STPAPIClient.sharedClient().createTokenWithCard(card, completion: { (token, ErrorHandling) -> Void in
            self.handleToken(token)
        })
    }
    
    //credit card
    func handleToken(token: STPToken!) {
        //send token to backend and create charge
    }
    
    //credit card
    @IBAction func creditCardPurchase(sender: AnyObject) {
        createToken()
    }
    
    //apple pay
    @IBAction func purchase(sender: UIButton) {
        
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
                println(error)
                completion(PKPaymentAuthorizationStatus.Failure)
                return
            }
            
//            // 4
//            let shippingAddress = self.createShippingAddressFromRef(payment.shippingAddress)
            let URLstring = "https://ticketbash.ngrok.com/api/v0/process_ticket?parse_id=\(self.myTicket!.parseObjectID)&stripe_token=\(token!.tokenId)"

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
                }
            }
        }
    }
    
    func paymentAuthorizationViewControllerDidFinish(controller: PKPaymentAuthorizationViewController!) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
}
