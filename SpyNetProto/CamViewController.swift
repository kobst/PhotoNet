//
//  CamViewController.swift
//  SpyNetProto
//
//  Created by Edward Han on 3/20/17.
//  Copyright © 2017 Edward Han. All rights reserved.
//

import UIKit
import SwiftyCam

class CamViewController: SwiftyCamViewController {
    
    var userTarget: UserTarget {
        return target?.target as! UserTarget
    }
    var target: TargetSpriteNew?
    
    
    
    @IBOutlet weak var buttonOverlayView: UIView!
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var name: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        
        let userTarget = target?.target as! UserTarget
        
        name.text = userTarget.userName
        let cgVersion = target?.texture!.cgImage()
        profileImage.image = UIImage(cgImage: cgVersion!)
        
        
        let buttonFrame = CGRect(x: 100, y: 100, width: 50, height: 50)
        let captureButton = SwiftyCamButton(frame: buttonFrame)
        captureButton.delegate = self
        // Do any additional setup after loading the view.
        
        
        
        self.view.bringSubview(toFront: buttonOverlayView)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didTake photo: UIImage) {
        // Called when takePhoto() is called or if a SwiftyCamButton initiates a tap gesture
        // Returns a UIImage captured from the current session
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didBeginRecordingVideo camera: SwiftyCamViewController.CameraSelection) {
        // Called when startVideoRecording() is called
        // Called if a SwiftyCamButton begins a long press gesture
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFinishRecordingVideo camera: SwiftyCamViewController.CameraSelection) {
        // Called when stopVideoRecording() is called
        // Called if a SwiftyCamButton ends a long press gesture
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFinishProcessVideoAt url: URL) {
        // Called when stopVideoRecording() is called and the video is finished processing
        // Returns a URL in the temporary directory where video is stored
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFocusAtPoint point: CGPoint) {
        // Called when a user initiates a tap gesture on the preview layer
        // Will only be called if tapToFocus = true
        // Returns a CGPoint of the tap location on the preview layer
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didChangeZoomLevel zoom: CGFloat) {
        // Called when a user initiates a pinch gesture on the preview layer
        // Will only be called if pinchToZoomn = true
        // Returns a CGFloat of the current zoom level
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didSwitchCameras camera: SwiftyCamViewController.CameraSelection) {
        // Called when user switches between cameras
        // Returns current camera selection   
    }

}
