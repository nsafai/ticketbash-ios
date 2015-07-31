//
//  EvidenceCameraViewController.swift
//  TicketBash
//
//  Created by Nicolai Safai on 7/31/15.
//  Copyright (c) 2015 Lime. All rights reserved.
//

import UIKit
import PBJVision

class EvidenceCameraViewController: UIViewController, PBJVisionDelegate {

    let vision = PBJVision.sharedInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let previewView = UIView(frame: self.view.frame)
        previewView.backgroundColor = UIColor.blackColor()
        let previewLayer = PBJVision.sharedInstance().previewLayer
        previewLayer.frame = previewView.bounds
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        previewView.layer.addSublayer(previewLayer)
        self.view.addSubview(previewView)
        self.view.sendSubviewToBack(previewView)
        
        
        
        self.vision.delegate = self
        self.vision.cameraMode = .Photo
        self.vision.cameraOrientation = .Portrait
        self.vision.focusMode = .ContinuousAutoFocus
        self.vision.outputFormat = PBJOutputFormat.Standard
        self.vision.captureSessionPreset = AVCaptureSessionPresetHigh
        self.vision.startPreview()
        
    }
    
    @IBAction func retryPicture(sender: AnyObject) {
        self.vision.startPreview()
    }
    
    @IBAction func acceptPicture(sender: AnyObject) {
        // save picture
        
        // switch to explanation view controller
        self.performSegueWithIdentifier("showExplanation", sender: self)
    }
    
    @IBAction func photoButtonTapped(sender: AnyObject) {
        self.vision.capturePhoto()
    }
}

extension TicketCameraViewController: PBJVisionDelegate {
    func vision(vision: PBJVision, capturedPhoto photoDict: [NSObject : AnyObject]?, error: NSError?) {
        // TODO: handle errors
        
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), { () -> Void in
            let imageData: NSData = photoDict![PBJVisionPhotoJPEGKey] as! NSData
            let image = UIImage(data: imageData)
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
        })
        
        
    }
}
