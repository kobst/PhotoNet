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
import ProjectOxfordFace


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
    
    @IBOutlet weak var resultLabel: UILabel!
    var centerImageOrigin: CGPoint {
        
        let midx  = (attemptedImageView.frame.origin.x + profileImageView.frame.origin.x) / 2.0
        let midy = (attemptedImageView.frame.origin.y + profileImageView.frame.origin.y) / 2.0
        return CGPoint(x: midx, y: midy)
        
    }
    
//    var targetSprite: TargetSprite?
    
    var userTarget: UserTarget {
        return target?.target as! UserTarget
    }
    var target: TargetSpriteNew?
    
    var targetFaceID: String?
    var attemptedFaceID: String?

    let faceClient = MPOFaceServiceClient(subscriptionKey: Model.shared.msApiKey)
    
//    let picker = UIImagePickerController()
//    
//    let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle: .actionSheet)
    
    
    
    func makeAttempt(result: Bool) {
        
        let locMgr: INTULocationManager = INTULocationManager.sharedInstance()
        locMgr.requestLocation(withDesiredAccuracy: INTULocationAccuracy.block,
                               timeout: 5,
                               delayUntilAuthorized: true,
                               block: {(currentLocation: CLLocation?, achievedAccuracy: INTULocationAccuracy, status: INTULocationStatus) -> Void in
                                if status == INTULocationStatus.success {
                                    print("got location");
                                    
                                    let newAttempt = Attempt(target: self.userTarget.uid, taker: (Model.shared.loggedInUser?.uid)!, location: currentLocation!, photo: self.profileImageView.image!, success: result)
                                    
                                    Model.shared.setNewAttempt(attempt: newAttempt)
                                    
                                
                                }
                                    
                                else {
                                    print("no location")
                                }
                                
        })
        
        
        

        
    }
    
    
    func showResult(success: Bool) {
        
        resultLabel.isHidden = false
        
        if success {
            resultLabel.text = "SUCCESS - 100 Pts"
            resultLabel.backgroundColor = UIColor.green

        }
        
        if !success {
            resultLabel.text = "ATTEMPT MISSED"
            resultLabel.backgroundColor = UIColor.red

        }
        
        
        UIView.animate(withDuration: 1.0, delay: 1.5, options: .curveEaseInOut, animations: {
            self.resultLabel.alpha = 0
        }, completion: { _ in
             self.dismiss(animated: true, completion: nil)
        })
        

        

        
        
//        let popVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SuccessPopUp") as! SuccessViewController
//        
//        if success {
//            popVC.result = .success
//        }
//        
//        if !success {
//            popVC.result = .failed
//        }
//        
//        self.addChildViewController(popVC)
//        popVC.view.frame = self.view.frame
//        self.view.addSubview(popVC.view)
//        popVC.didMove(toParentViewController: self)
        
    }
    
    func compareFaces() {
        
            let _ = faceClient?.verify(withFirstFaceId: attemptedFaceID, faceId2: targetFaceID, completionBlock: { (result, error) in
                
                if let goodResult = result {
                    print(goodResult.isIdentical)
                    
                    self.showResult(success: goodResult.isIdentical)
                    self.makeAttempt(result: goodResult.isIdentical)
                    
                }
                
                else {
                    print("inconclusive")
                    
                    
                    
                    
                }
                
            })
        
        
    }
    
    func setImage() {
        print(centerImageOrigin)
        print(attemptedImageOrigin)
        print(profileImageOrigin)
        
        let distY  =  profileImageView.frame.origin.y - attemptedImageView.frame.origin.y

        UIView.animate(withDuration: 6.0) {
//            self.attemptedImageView.frame.origin = self.centerImageOrigin
//            self.profileImageView.frame.origin = self.centerImageOrigin
            
            self.profileImageView.frame.origin.y =  self.profileImageView.frame.origin.y - distY
            self.attemptedImageView.frame.origin.y = self.attemptedImageView.frame.origin.y + distY
            self.attemptedImageView.alpha = 1.0
            self.profileImageView.alpha = 1.0
        }
        
        
        var faceData = Data()
        faceData = UIImageJPEGRepresentation(attemptedImageView.image!, 0.5)!
 
        
        let _ = faceClient?.detect(with: faceData, returnFaceId: true, returnFaceLandmarks: false, returnFaceAttributes: nil, completionBlock: { (faces, error) in
            
            if (faces?.count)! > 0 {
                self.attemptedFaceID = faces?[0].faceId
                print(self.attemptedFaceID ?? "no face")
                self.compareFaces()
            }
            
            else {
                print("no faces")
                self.resultLabel.text = "No Targets Identified"
                self.resultLabel.backgroundColor = UIColor.yellow
                self.resultLabel.isHidden = false
                self.attemptedImageView.image = nil
               
                UIView.animate(withDuration: 2.5, animations: { 
                    self.resultLabel.alpha = 0
                })
//                self.resultLabel.isHidden = true
                self.engageButton.isHidden = false
                self.engageButton.isEnabled = true
                
                
            }
            
        })
        
    
        
        
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            attemptedImageView.image = pickedImage.circle
            
//            abortButton.isHidden = true
            abortButton.frame.origin = CGPoint(x: 0, y: 0)
            engageButton.isHidden = true
            self.setImage()
            
            
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

        resultLabel.isHidden = true
        
        let userTarget = target?.target as! UserTarget
        
        name.text = userTarget.userName
        let cgVersion = target?.texture!.cgImage()
        profileImageView.image = UIImage(cgImage: cgVersion!)
        
//        name.text = targetSprite?.name!
//        let cgVersion = targetSprite?.texture!.cgImage()
//        profileImageView.image = UIImage(cgImage: cgVersion!)
        
  
        captureSession.sessionPreset = AVCaptureSessionPresetHigh
        

        attemptedImageOrigin = attemptedImageView.frame.origin
        profileImageOrigin = profileImageView.frame.origin
        

        
        let _ = faceClient?.detect(withUrl: userTarget.avatar, returnFaceId: true, returnFaceLandmarks: false, returnFaceAttributes: nil, completionBlock: { (faces, error) in
            
            if (faces?.count)! > 0 {
                self.targetFaceID = faces?[0].faceId
                print("got face \n")
                print(faces?[0].faceId ?? "no face")

            }
            

            
        })
        


        
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
