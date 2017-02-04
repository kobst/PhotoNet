//
//  OnBoardOneViewController.swift
//  SpyNetProto
//
//  Created by Edward Han on 1/27/17.
//  Copyright © 2017 Edward Han. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage


class OnBoardController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    
    func alert(message: String, title: String = "") {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
    alertController.addAction(OKAction)
    self.present(alertController, animated: true, completion: nil)
    }
    
    
    var imagePicked = false
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    
    @IBOutlet weak var uploadPhotoLabel: UILabel!
    
    
    @IBOutlet weak var codeName: UITextField!
    
    
    @IBOutlet weak var blurbField: UITextView!
    
    

    @IBAction func completeRegistration(_ sender: Any) {
        
        if imagePicked == false {
            alert(message: "please upload a photo")
        }
        
        guard let imageUploaded = profileImageView.image else {
            alert(message: "please upload a photo")
            return
        }
        
        guard let codeName = codeName.text else {
            alert(message: "please enter a code name")
            return
        }
        
        guard let blurb = blurbField.text else {
            alert(message: "please enter non-classified vital")
            return
            
        }
        
        
        var data = Data()
        data = UIImageJPEGRepresentation(imageUploaded, 0.1)!
        
        //        let metaData = FIRStorageMetadata()
        //        metaData.contentType = "image/jpg"
        
        let storageRef = FIRStorage.storage().reference()
        let imageUID = NSUUID().uuidString
        let imageRef = storageRef.child(imageUID)
        
        Model.shared.loggedInUser?.blurb = blurb
        Model.shared.loggedInUser?.name = codeName
        
        imageRef.put(data, metadata: nil).observe(.success) { (snapshot) in
            let imageURL = snapshot.metadata?.downloadURL()?.absoluteString
            
            
            let baseRef = FIRDatabase.database().reference()
            let ref = baseRef.child("users").child(Model.shared.loggedInUser!.uid)
            
            //            let ref  = FIRDatabase.database().reference(withPath: "users/\(Model.shared.loggedInUser!.uid)")
            let avatarRef = ref.child("avatar")
            avatarRef.setValue(imageURL)
            
            let nameRef = ref.child("name")
            nameRef.setValue(codeName)
            
            let blurbRef = ref.child("blurb")
            blurbRef.setValue(blurb)
            
            
            
        }
        
        
       
         performSegue(withIdentifier: "toMain", sender: nil)

        
        
        
        
        
    }
    
//    @IBAction func completeRegistration(_ sender: Any) {
//        
//        if imagePicked == false {
//            alert(message: "please upload a photo")
//        }
//        
//        guard let imageUploaded = profileImageView.image else {
//            alert(message: "please upload a photo")
//            return
//        }
//        
//        guard let codeName = codeName.text else {
//            alert(message: "please enter a code name")
//            return
//        }
//        
//        guard let blurb = blurbField.text else {
//            alert(message: "please enter non-classified vital")
//            return
//            
//        }
//        
//        
//        
//        var data = Data()
//        data = UIImageJPEGRepresentation(imageUploaded, 0.1)!
//        
//        //        let metaData = FIRStorageMetadata()
//        //        metaData.contentType = "image/jpg"
//        
//        let storageRef = FIRStorage.storage().reference()
//        let imageUID = NSUUID().uuidString
//        let imageRef = storageRef.child(imageUID)
//        
//        Model.shared.loggedInUser?.blurb = blurb
//        Model.shared.loggedInUser?.name = codeName
//        
//        imageRef.put(data, metadata: nil).observe(.success) { (snapshot) in
//            let imageURL = snapshot.metadata?.downloadURL()?.absoluteString
//            
//            
//            let baseRef = FIRDatabase.database().reference()
//            let ref = baseRef.child("users").child(Model.shared.loggedInUser!.uid)
//            
////            let ref  = FIRDatabase.database().reference(withPath: "users/\(Model.shared.loggedInUser!.uid)")
//            let avatarRef = ref.child("avatar")
//            avatarRef.setValue(imageURL)
//            
//            let nameRef = ref.child("name")
//            nameRef.setValue(codeName)
//            
//            let blurbRef = ref.child("blurb")
//            blurbRef.setValue(blurb)
//            
//        }
//        
//        
//        performSegue(withIdentifier: "toMainFromOnboard", sender: nil)
//        
//    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

            
            profileImageView.isUserInteractionEnabled = true
            
            profileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImage)))
            
            // Do any additional setup after loading the view.
    }

    
    
    
    
    func handleSelectProfileImage() {
    
    print("tapped")
    let picker = UIImagePickerController()
    picker.delegate = self
    picker.allowsEditing = true
    present(picker, animated: true, completion: nil)
    }
    

    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    
    var selectedImageFromPicker: UIImage?
    
    if let editedImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
    selectedImageFromPicker = editedImage
    } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
    selectedImageFromPicker = originalImage
    }
    
    if let selectedImage = selectedImageFromPicker {
    profileImageView.image = selectedImage
    uploadPhotoLabel.isHidden = true
    imagePicked = true
    }
    
    dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    dismiss(animated: true, completion: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
    }
    
    

}
