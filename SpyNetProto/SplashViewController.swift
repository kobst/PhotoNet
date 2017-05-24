//
//  SplashViewController.swift
//  SpyNetProto
//
//  Created by Edward Han on 2/5/17.
//  Copyright © 2017 Edward Han. All rights reserved.
//

import UIKit
import INTULocationManager

class SplashViewController: UIViewController {
  
    var userUID: String?

    
    func getLocation() {
        
        
        let locMgr: INTULocationManager = INTULocationManager.sharedInstance()
        
        locMgr.requestLocation(withDesiredAccuracy: INTULocationAccuracy.block,
                               timeout: 5,
                               delayUntilAuthorized: true,
                               block: {(currentLocation: CLLocation?, achievedAccuracy: INTULocationAccuracy, status: INTULocationStatus) -> Void in
                                if status == INTULocationStatus.success {
                                    print("got location");
                                    
                                    let dummyLocation = CLLocation(latitude: 40.7369432, longitude: -73.9918239)
                                    
                                    
                                    Model.shared.updateMyLocation(myLocation: dummyLocation)
                                    
                                    Model.shared.myLocation = dummyLocation
                                    
                                    print("\(currentLocation).....CL.")
                                    
                                    
                                     self.performSegue(withIdentifier: "toRadar", sender: self)
                                    

//                                    
                                }
                                    
                                else {
                                    print("no location")
                                }
                                
        })

        
        
        
    }
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let userUIDfake = "Vk8DAXariGZWyIiVdO4apcatEo73"
        Model.shared.fetchUser(UID: userUIDfake, completionHandler: { (user) in
            Model.shared.loggedInUser = user
            print("in fetch user \n \n \n fetch user")
            //                self.performSegue(withIdentifier: "toMain", sender: self)
            //                self.performSegue(withIdentifier: "toRadar", sender: self)
            
            self.getLocation()
            }
        )
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    



}




