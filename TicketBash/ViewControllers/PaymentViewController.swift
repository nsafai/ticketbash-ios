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

class PaymentViewController: UIViewController {
    
    @IBOutlet weak var applePayButton: UIButton!
    let SupportedPaymentNetworks = [PKPaymentNetworkVisa, PKPaymentNetworkMasterCard, PKPaymentNetworkAmex]
    let ApplePaySwagMerchantID = "merchant.com.Lime.TicketBash"//    @IBOutlet weak var saveButton: UIButton!
//    weak var paymentView: PTKView
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        applePayButton.hidden = !PKPaymentAuthorizationViewController.canMakePaymentsUsingNetworks(SupportedPaymentNetworks)
        
//        var view: PTKView = PTKView(frame: CGRectMake(15, 20, 290, 55))
//        self.paymentView = view
//        self.paymentView.delegate = self
//        self.view.addSubview(self.paymentView)
        
    }
    
//    func paymentView(view: PTKView, withCard card: PTKCard, isValid valid: Bool) {
//        self.saveButton.enabled = valid
//    }

    
    @IBAction func purchase(sender: UIButton) {
        
        let request = PKPaymentRequest()
        request.merchantIdentifier = ApplePaySwagMerchantID
        request.supportedNetworks = SupportedPaymentNetworks
        request.merchantCapabilities = PKMerchantCapability.Capability3DS
        request.countryCode = "US"
        request.currencyCode = "USD"
        
        request.paymentSummaryItems = [
            PKPaymentSummaryItem(label: "TicketBash Shipping", amount: 3),
//            PKPaymentSummaryItem(label: "Certified Mail", amount: 10)
        ]
        
        let applePayController = PKPaymentAuthorizationViewController(paymentRequest: request)
        applePayController.delegate = self
        
        request.requiredShippingAddressFields = PKAddressField.Email //potentially unnecessary
        
        self.presentViewController(applePayController, animated: true, completion: nil)
        
    }
}
extension PaymentViewController: PKPaymentAuthorizationViewControllerDelegate {
    func paymentAuthorizationViewController(controller: PKPaymentAuthorizationViewController!, didAuthorizePayment payment: PKPayment!, completion: ((PKPaymentAuthorizationStatus) -> Void)!) {
        completion(PKPaymentAuthorizationStatus.Success)
    }
    
    func paymentAuthorizationViewControllerDidFinish(controller: PKPaymentAuthorizationViewController!) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
}
