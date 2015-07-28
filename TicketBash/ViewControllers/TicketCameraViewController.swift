//
//  TicketCameraViewController.swift
//  TicketBash
//
//  Created by Nicolai Safai on 7/28/15.
//  Copyright (c) 2015 Lime. All rights reserved.
//

import UIKit

class TicketCameraViewController: UIViewController, PBJVisionDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let previewView = UIView(frame: CGRectZero)
        previewView.backgroundColor = UIColor.blackColor()
        var previewFrame: CGRect = CGRectMake(0, 20, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))
        previewView.frame = previewFrame
        var previewLayer = PBJVision.sharedInstance().previewLayer
        previewLayer.frame = previewView.bounds
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        previewView.layer.addSublayer(previewLayer)
        
        
        
        let vision: PBJVision = PBJVision.sharedInstance()
        vision.delegate = self;
        vision.cameraMode = PBJCameraMode.Photo
        vision.cameraOrientation = PBJCameraOrientation.Portrait
        vision.focusMode = PBJFocusMode.ContinuousAutoFocus
        vision.outputFormat = PBJOutputFormat.Square
        self.view.addSubview(previewView)
        vision.startPreview()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
