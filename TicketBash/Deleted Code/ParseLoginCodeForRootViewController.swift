//
//  ParseLoginCodeForRootViewController.swift
//  TicketBash
//
//  Created by Nicolai Safai on 8/11/15.
//  Copyright (c) 2015 Lime. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class ParseLoginCodeForRootViewController: UIViewController {
    var parseLoginHelper: ParseLoginHelper!
    let loginViewController = PFLogInViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.parseLoginHelper = ParseLoginHelper {[unowned self] user, error in // Initialize the ParseLoginHelper with a callback
            
            if let error = error {
                ErrorHandling.defaultErrorHandler(error)
                //                println("Error logging in \(user)")
            } else if let user = user {
                // code below indicates what should happen if PFLogInViewController succesfully logs in a user
                //                println("CASE 1 Logged in user is \(user)")
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = false
        
        var user = PFUser.currentUser()
        if (user != nil) {
            // someone is logged in

        } else {
                        self.loginViewController.fields = .UsernameAndPassword | .LogInButton | .SignUpButton | .PasswordForgotten
                        // add | .Facebook for Facebook
                        self.loginViewController.emailAsUsername = true
                        var logInLogoTitle = UILabel()
                        logInLogoTitle.text = "Ticket Bash"
                        logInLogoTitle.font = UIFont(name: "HelveticaNeue-UltraLight",
                            size: 70.0)
            
                        self.loginViewController.logInView?.logo = logInLogoTitle
                        self.loginViewController.delegate = self.parseLoginHelper
                        self.loginViewController.signUpController?.delegate = self.parseLoginHelper
            
                        // present login view controller modally
                        self.presentViewController(self.loginViewController, animated: true, completion: nil)
                                    self.navigationController?.pushViewController(self.loginViewController, animated: true)
        }

    }

}
