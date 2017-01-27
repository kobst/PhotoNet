//
//  LoginViewController.swift
//  SpyNetProto
//
//  Created by Edward Han on 1/27/17.
//  Copyright © 2017 Edward Han. All rights reserved.
//

import UIKit

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}

//func alert(message: String, title: String = "") {
//    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
//    let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
//    alertController.addAction(OKAction)
//    self.present(alertController, animated: true, completion: nil)
//}


class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
