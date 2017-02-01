//
//  ViewController.swift
//  SpyNetProto
//
//  Created by Edward Han on 1/25/17.
//  Copyright © 2017 Edward Han. All rights reserved.
//

import UIKit
import SpriteKit
import CoreLocation
import INTULocationManager
import GeoFire


class MainViewController: UIViewController {

   
    
    
    override func loadView() {
        self.view = SKView(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        var scene: FieldScene!
        
        
        let skView = view as! SKView
        skView.isMultipleTouchEnabled = false
        
        // Create and configure the scene.
        scene = FieldScene(size: skView.bounds.size)
        scene.scaleMode = .aspectFill
        skView.presentScene(scene)
        
        let locMgr: INTULocationManager = INTULocationManager.sharedInstance()
        locMgr.requestLocation(withDesiredAccuracy: INTULocationAccuracy.block,
                               timeout: 5,
                               delayUntilAuthorized: true,
                               block: {(currentLocation: CLLocation?, achievedAccuracy: INTULocationAccuracy, status: INTULocationStatus) -> Void in
                                if status == INTULocationStatus.success {
                                    print("got location");
                                    Model.shared.myOrigin = currentLocation
                                    Model.shared.updateMyLocation(myLocation: currentLocation!)

                                    Model.shared.getTargets3(myLocation: currentLocation!)
//                                    Model.shared.getTargets2(myLocation: currentLocation!) { targets in
//                                        
//                                        scene.addTargetArray(targets: targets)
//                                        if targets.count > 7 {
//                                            for target in targets {
//                                                print(target.user?.name ?? "no name in closure")
//                                                scene.addTarget(target: target)
//                                                
//                                            }
//                                        }

//                                        
//                                    }
//                                        for target in targets {
////                                            print(target.sprite?.position ?? "no position")
////                                            print(target.sprite?.size ?? "no size")
//                                            scene.addTarget(target: target)
//                                            
//                                        }
//                                    }
//
//
//                                        // for spot in spots ...scene.addspot2(spot)
//                                    //include closure w getTargets that takes in locations/users and populates them using a scene.method.....
//                                    
//                                    }
                                    
                                    
                                    
                                }
                                    
                                else {
                                    print("no location")
                                }
                               
        })
        
        
        
        // Present the scene.
     
        
        
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

