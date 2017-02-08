//
//  SplashViewController.swift
//  SpyNetProto
//
//  Created by Edward Han on 2/5/17.
//  Copyright © 2017 Edward Han. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {
  
    var userUID: String?
    
    @IBAction func goNext(_ sender: Any) {
        
//        Model.shared.loggedInUser = nil  // comment out 
        
        if let _ = Model.shared.loggedInUser {
            print("validUID")
            
            self.performSegue(withIdentifier: "toMain", sender: self)
           
//            Model.shared.fetchUser(UID: validUID , completionHandler: { (user) in
//                Model.shared.loggedInUser = user
//                print("in fetch user \n \n \n fetch user")
//                self.performSegue(withIdentifier: "toMain", sender: self)
//            })
        }
        
        else {
            print("not valid")
            self.performSegue(withIdentifier: "toLoginFromSplash", sender: self)
            
        }
        
        
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        
        print("viewdidload \n \n \n \n \n \n viewdidload")
        
//        let userUID = UserDefaults.standard.value(forKey: "uid")
//        userUID = UserDefaults.standard.value(forKey: "uid") as! String?
        
        userUID = "FbuuG386AhPGBofomp75aXqhE5W2"
        if let validUID = userUID {
            print("validUID")
            Model.shared.fetchUser(UID: validUID , completionHandler: { (user) in
                Model.shared.loggedInUser = user
                print("in fetch user \n \n \n fetch user")
//                self.performSegue(withIdentifier: "toMain", sender: self)
            })
        }
//
//        else {
//            print("not valid")
//            self.performSegue(withIdentifier: "toLoginFromSplash", sender: self)
//            
//        }
        
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
