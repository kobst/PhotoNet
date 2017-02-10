//
//  DetailViewController.swift
//  SpyNetProto
//
//  Created by Edward Han on 2/5/17.
//  Copyright © 2017 Edward Han. All rights reserved.
//

import UIKit
import AVFoundation
import INTULocationManager


//#import <ProjectOxfordFace/MPOFaceSDK.h>


class DetailViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var abortButton: UIButton!
 
    @IBOutlet weak var engageButton: UIButton!
    let captureSession = AVCaptureSession()
    var device: AVCaptureDevice?
    
    @IBOutlet weak var attemptedImageView: UIImageView!
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    var attemptedImageOrigin = CGPoint()
    var profileImageOrigin = CGPoint()
    
    @IBOutlet weak var name: UILabel!
    
    var centerImageOrigin: CGPoint {
        
        let midx  = (attemptedImageView.frame.origin.x + profileImageView.frame.origin.x) / 2.0
        let midy = (attemptedImageView.frame.origin.y + profileImageView.frame.origin.y) / 2.0
        return CGPoint(x: midx, y: midy)
        
    }
    
    var targetSprite: TargetSprite?

//    let picker = UIImagePickerController()
//    
//    let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle: .actionSheet)
    
   
    
    
    func makeAttempt() {
        
        
        
        let locMgr: INTULocationManager = INTULocationManager.sharedInstance()
        locMgr.requestLocation(withDesiredAccuracy: INTULocationAccuracy.block,
                               timeout: 5,
                               delayUntilAuthorized: true,
                               block: {(currentLocation: CLLocation?, achievedAccuracy: INTULocationAccuracy, status: INTULocationStatus) -> Void in
                                if status == INTULocationStatus.success {
                                    print("got location");
                                    
                                    let newAttempt = Attempt(target: (self.targetSprite?.target?.user?.uid)!, taker: (Model.shared.loggedInUser?.uid)!, location: currentLocation!, photo: self.profileImageView.image!)
                                    
                                    Model.shared.setNewAttempt(attempt: newAttempt)
                                    
                                    
                                    
                                }
                                    
                                else {
                                    print("no location")
                                }
                                
        })
        
        
        

        
    }
    
    
    func compareImage() {
        print(centerImageOrigin)
        print(attemptedImageOrigin)
        print(profileImageOrigin)
        
        let distY  =  profileImageView.frame.origin.y - attemptedImageView.frame.origin.y
        
        makeAttempt()

        UIView.animate(withDuration: 6.0) {
//            self.attemptedImageView.frame.origin = self.centerImageOrigin
//            self.profileImageView.frame.origin = self.centerImageOrigin
            
            self.profileImageView.frame.origin.y =  self.profileImageView.frame.origin.y - distY
            self.attemptedImageView.frame.origin.y = self.attemptedImageView.frame.origin.y + distY
            self.attemptedImageView.alpha = 0.50
            self.profileImageView.alpha = 0.50
        }
        
        let duration = 2.0
        let delay = 1.0
        
//        UIView.animateKeyframes(withDuration: duration, delay: delay, options: [.repeat], animations: {
//            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1/4, animations: {
//                self.attemptedImageView.frame.origin = self.attemptedImageOrigin
//                self.profileImageView.frame.origin = self.profileImageOrigin
//                self.attemptedImageView.alpha = 0.95
//                self.profileImageView.alpha = 0.95
//            })
//            UIView.addKeyframe(withRelativeStartTime: 1/3, relativeDuration: 3/4, animations: {
//                self.attemptedImageView.frame.origin = self.centerImageOrigin
//                self.profileImageView.frame.origin = self.centerImageOrigin
//                self.attemptedImageView.alpha = 0.50
//                self.profileImageView.alpha = 0.50
//            })
//        }, completion: nil
//        )
//        
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            attemptedImageView.image = pickedImage.circle
            
//            abortButton.isHidden = true
            abortButton.frame.origin = CGPoint(x: 0, y: 0)
            engageButton.isHidden = true
            self.compareImage()
            
            
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func engage(_ sender: Any) {
        print("in enagege")
        
        PermisisionManager.requestCameraAccess { (granted: Bool) in
            if !granted {
                print("cannot access camera")
            }
            
            
            else {
                
                if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
                    print("in camera")
                    let imagePicker = UIImagePickerController()
                    imagePicker.delegate = self
                    imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
                    imagePicker.allowsEditing = false
                    self.present(imagePicker, animated: true, completion: nil)
                }
                
                
            }
            
        }
        


    }
    
    
    
    @IBAction func abort(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        
        name.text = targetSprite?.name!
        let cgVersion = targetSprite?.texture!.cgImage()
        profileImageView.image = UIImage(cgImage: cgVersion!)
        
  
        captureSession.sessionPreset = AVCaptureSessionPresetHigh
        

        attemptedImageOrigin = attemptedImageView.frame.origin
        profileImageOrigin = profileImageView.frame.origin
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}










///MARK: IMAGE PICKER funcs
//
//let imagePickerController = UIImagePickerController()
//
//var logoPhoto = " "
//var imageName = ""
//
//
//func pickImagePressed (){
//    
//    let imagePickerController = UIImagePickerController()
//    imagePickerController.delegate = self
//    
//    let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle: .actionSheet)
//    
//    actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(action: UIAlertAction) in
//        if UIImagePickerController.isSourceTypeAvailable(.camera) {
//            imagePickerController.sourceType = .camera
//            self.present(imagePickerController, animated: true, completion: nil)
//        } else {
//            print("Camera not available")
//        }
//    }))
//    
//    actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: {(action: UIAlertAction) in
//        imagePickerController.sourceType = .photoLibrary
//        self.present(imagePickerController, animated: true, completion: nil)
//    }))
//    
//    actionSheet.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: nil))
//    
//    self.present(actionSheet, animated: true, completion: nil)
//}
//
//
//func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//    let image = info[UIImagePickerControllerOriginalImage] as! UIImage
//    imageName = NSUUID().uuidString // creates a randome string to  be uses as photo name
//    photoImageView.image = image
//    
//    
//    picker.dismiss(animated: true, completion: nil)
//}
//
//
//
//func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//    picker.dismiss(animated: true, completion: nil)
//}
////        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(action: UIAlertAction) in
//                if UIImagePickerController.isSourceTypeAvailable(.camera) {
//                    self.picker.sourceType = .camera
//                    self.present(self.picker, animated: true, completion: nil)
//                } else {
//                    print("Camera not available")
//                }
//            }))
//
//            actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: {(action: UIAlertAction) in
//                self.picker.sourceType = .photoLibrary
//                self.present(self.picker, animated: true, completion: nil)
//            }))
//
//            actionSheet.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: nil))
//
//            self.present(actionSheet, animated: true, completion: nil)

//        picker.allowsEditing = false
//        picker.sourceType = UIImagePickerControllerSourceType.camera
//        picker.cameraCaptureMode = .photo
//        picker.modalPresentationStyle = .fullScreen
//        present(picker,animated: true,completion: nil)
//
//UIImagePickerControllerDelegate, UINavigationControllerDelegate
