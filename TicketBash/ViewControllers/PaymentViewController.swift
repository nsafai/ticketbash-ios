//
//  PaymentViewController.swift
//  TicketBash
//
//  Created by Nicolai Safai on 8/6/15.
//  Copyright (c) 2015 Lime. All rights reserved.
//

import UIKit
import PaymentKit

class PaymentViewController: UIViewController {
    
    @IBOutlet weak var saveButton: UIButton!
    weak var paymentView: PTKView
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        var view: PTKView = PTKView(frame: CGRectMake(15, 20, 290, 55))
        self.paymentView = view
        self.paymentView.delegate = self
        self.view.addSubview(self.paymentView)
        
    }
    
    func paymentView(view: PTKView, withCard card: PTKCard, isValid valid: Bool) {
        self.saveButton.enabled = valid
    }

}
