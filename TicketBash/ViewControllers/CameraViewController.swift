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

class CameraViewController: UIViewController {
    
    let vision = PBJVision.sharedInstance()
    var acceptedImage: UIImage?
    
    @IBOutlet weak var retryButton: UIButton!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var cameraText: UILabel!
    
    @IBOutlet weak var photoButton: UIButton!
    var delegate: CameraViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // hide buttons
        retryButton.hidden = true
        acceptButton.hidden = true
        
        
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
    }
    
    override func viewWillAppear(animated: Bool) {
//        vision.stopPreview()
        vision.startPreview()
        self.photoButton.userInteractionEnabled = true;
        self.photoButton.hidden = false
//        self.navigationController?.navigationBarHidden = true
        
        if (self.parentViewController?.isKindOfClass(CitationCameraViewController) == true) {
            cameraText.text = "Take a picture of\nyour parking ticket"
        } else if (self.parentViewController?.isKindOfClass(EvidenceCameraViewController) == true) {
            cameraText.text = "Take a picture of\nyour vehicle\n(or evidence)"
        }
    }
    
    @IBAction func retryPicture(sender: AnyObject) {
        vision.startPreview()
        // hide buttons again
        retryButton.hidden = true
        acceptButton.hidden = true
        self.photoButton.userInteractionEnabled = true;
        self.photoButton.hidden = false
    }
    
    @IBAction func acceptPicture(sender: AnyObject) {
        
//        println(self.delegate)
        
            if let delegate = delegate, acceptedImage = acceptedImage {
                // save to property
                delegate.acceptedImage(acceptedImage)
                // save picture realm
                
                // save to camera roll (in background)
                dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), { () -> Void in
//                    UIImageWriteToSavedPhotosAlbum(acceptedImage, nil, nil, nil)
//                    println("Photo just accepted!!!")
                })
            }
    }
    @IBAction func photoButtonTapped(sender: AnyObject) {
        self.photoButton.userInteractionEnabled = false;
        self.photoButton.hidden = true
        self.vision.capturePhoto()
    }
}

extension CameraViewController: PBJVisionDelegate {
    func vision(vision: PBJVision, capturedPhoto photoDict: [NSObject : AnyObject]?, error: NSError?) {
        // TODO: handle errors
        
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), { () -> Void in
            let imageData: NSData = photoDict![PBJVisionPhotoJPEGKey] as! NSData
            let image = UIImage(data: imageData)
            
                self.acceptedImage = image

            dispatch_async(dispatch_get_main_queue()) {
                // unhide approve/retry buttons
                self.retryButton.hidden = false
                self.acceptButton.hidden = false
                vision.stopPreview()
//                println("picture was taken, unhide buttons!")
            }
        })
    }
}