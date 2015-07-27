//
//  ViewController.swift
//  TicketBash
//
//  Created by Nicolai Safai on 7/27/15.
//  Copyright (c) 2015 Lime. All rights reserved.
//

import UIKit

class ViewController: UIViewController, PBJVisionDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // preview and AV layer
        
//        _previewView = [[UIView alloc] initWithFrame:CGRectZero];
//        _previewView.backgroundColor = [UIColor blackColor];
//        CGRect previewFrame = CGRectMake(0, 60.0f, CGRectGetWidth(self.view.frame), CGRectGetWidth(self.view.frame));
//        _previewView.frame = previewFrame;
//        _previewLayer = [[PBJVision sharedInstance] previewLayer];
//        _previewLayer.frame = _previewView.bounds;
//        _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
//        [_previewView.layer addSublayer:_previewLayer];
        
        let previewView = UIView(frame: CGRectZero)
        previewView.backgroundColor = UIColor.blackColor()
        var previewFrame: CGRect = CGRectMake(0, 20, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))
        previewView.frame = previewFrame
        var previewLayer = PBJVision.sharedInstance().previewLayer
        previewLayer.frame = previewView.bounds
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        previewView.layer.addSublayer(previewLayer)
        

        // should be its own method
        
//        _longPressGestureRecognizer.enabled = YES;
//        
//        PBJVision *vision = [PBJVision sharedInstance];
//        vision.delegate = self;
//        vision.cameraMode = PBJCameraModeVideo;
//        vision.cameraOrientation = PBJCameraOrientationPortrait;
//        vision.focusMode = PBJFocusModeContinuousAutoFocus;
//        vision.outputFormat = PBJOutputFormatSquare;
//        
//        [vision startPreview];
        
        let vision: PBJVision = PBJVision.sharedInstance()
        vision.delegate = self;
        vision.cameraMode = PBJCameraMode.Photo
        vision.cameraOrientation = PBJCameraOrientation.Portrait
        vision.focusMode = PBJFocusMode.ContinuousAutoFocus
        vision.outputFormat = PBJOutputFormat.Square
        self.view.addSubview(previewView)
        vision.startPreview()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

