//
//  DetailViewController.swift
//  SpyNetProto
//
//  Created by Edward Han on 2/5/17.
//  Copyright © 2017 Edward Han. All rights reserved.
//

import UIKit
import AVFoundation


//#import <ProjectOxfordFace/MPOFaceSDK.h>


class DetailViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let captureSession = AVCaptureSession()
    var device: AVCaptureDevice?
    
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var name: UILabel!
    
    var targetSprite: TargetSprite?

//    let picker = UIImagePickerController()
//    
//    let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle: .actionSheet)
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            profileImageView.image = pickedImage
        
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
