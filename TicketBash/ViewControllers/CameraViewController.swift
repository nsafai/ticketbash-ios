//
//  CameraViewController.swift
//  TicketBash
//
//  Created by Nicolai Safai on 7/31/15.
//  Copyright (c) 2015 Lime. All rights reserved.
//

import UIKit
import PBJVision

protocol CameraViewControllerDelegate {
    func acceptedImage(image: UIImage)
}

class CameraViewController: UIViewController, PBJVisionDelegate {
    
    let vision = PBJVision.sharedInstance()
    var ticketImage: UIImage?
    
    var delegate: CameraViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let previewView = UIView(frame: self.view.frame)
        previewView.backgroundColor = UIColor.blackColor()
        let previewLayer = PBJVision.sharedInstance().previewLayer
        previewLayer.frame = previewView.bounds
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        previewView.layer.addSublayer(previewLayer)
        view.addSubview(previewView)
        view.sendSubviewToBack(previewView)
        
        
        
        vision.delegate = self
        vision.cameraMode = .Photo
        vision.cameraOrientation = .Portrait
        vision.focusMode = .ContinuousAutoFocus
        vision.outputFormat = PBJOutputFormat.Standard
        vision.captureSessionPreset = AVCaptureSessionPresetHigh
        vision.startPreview()
        
    }
    
    @IBAction func retryPicture(sender: AnyObject) {
        self.vision.startPreview()
    }
    
    @IBAction func acceptPicture(sender: AnyObject) {
        
        if let delegate = delegate, ticketImage = ticketImage {
            // save to property
            delegate.acceptedImage(ticketImage)
            // save picture realm
            
            // save to camera roll (in background)
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), { () -> Void in
                UIImageWriteToSavedPhotosAlbum(ticketImage, nil, nil, nil)
            })
        }
    }
    @IBAction func photoButtonTapped(sender: AnyObject) {
        self.vision.capturePhoto()
    }
}

extension CameraViewController: PBJVisionDelegate {
    func vision(vision: PBJVision, capturedPhoto photoDict: [NSObject : AnyObject]?, error: NSError?) {
        // TODO: handle errors
        
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), { () -> Void in
            let imageData: NSData = photoDict![PBJVisionPhotoJPEGKey] as! NSData
            let image = UIImage(data: imageData)
            self.ticketImage = image
            
            dispatch_async(dispatch_get_main_queue()) {
                // unhide approve/retry buttons
                println("I'm useful!")
            }
        })
    }
}