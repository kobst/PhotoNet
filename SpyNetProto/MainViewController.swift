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


protocol GoToDetail: class {
    
    func goToDetail(targetSprite: TargetSprite)
    func goToProfile()
    func goToTweet(targetSprite: TargetSprite)
    
}

class MainViewController: UIViewController, GoToDetail {
    
    var selectedSprite: TargetSprite?

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetail" {
            
            let detailVC = segue.destination as! DetailViewController
            detailVC.targetSprite = selectedSprite
            
        }
        
        
        if segue.identifier == "toTweet" {
            
            let detailVC = segue.destination as! TweetDetailViewController
            detailVC.targetSprite = selectedSprite
        }
    }
    
    
    
    func goToProfile() {
        
        performSegue(withIdentifier: "toProfile", sender: nil)
    }
    
    func goToDetail(targetSprite: TargetSprite) {
        
        selectedSprite = targetSprite
        performSegue(withIdentifier: "toDetail", sender: nil)
        
        
    }
    
    
    func goToTweet(targetSprite: TargetSprite) {
        selectedSprite = targetSprite
         performSegue(withIdentifier: "toTweet", sender: nil)
        
    }
    
     @IBAction func unwindToMain(segue: UIStoryboardSegue) {}
    
    
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
        scene.delegateMainVC = self
        scene.scaleMode = .aspectFill
        skView.presentScene(scene)
    
        
        let locMgr: INTULocationManager = INTULocationManager.sharedInstance()
 //
        

        locMgr.subscribeToHeadingUpdates { (heading, status) in
            if status == .success {
                print(heading?.trueHeading ?? "no heading")
                Model.shared.myHeading = heading?.trueHeading
            }
        }
        
        locMgr.requestLocation(withDesiredAccuracy: INTULocationAccuracy.block,
                               timeout: 5,
                               delayUntilAuthorized: true,
                               block: {(currentLocation: CLLocation?, achievedAccuracy: INTULocationAccuracy, status: INTULocationStatus) -> Void in
                                if status == INTULocationStatus.success {
                                    print("got location");
                                    
//                                    let dummyLocation = CLLocation(latitude: 40.7369432, longitude: -73.9918239)
//                                    let dummyLocation = Model.shared.makeFakeLocation()
                                    let dummyLocation = CLLocation(latitude: 40.7369432, longitude: -73.9918239)
//                                    Model.shared.myOrigin = currentLocation
//                                    Model.shared.updateMyLocation(myLocation: currentLocation!)
//                                    Model.shared.getTargets3(myLocation: currentLocation!)
                                    Model.shared.myLocation = CLLocation(latitude: 40.7369432, longitude: -73.9918239)
                                    
                                    print("\(currentLocation).....CL.")
                                    
                                    Model.shared.updateMyLocation(myLocation: dummyLocation)
                                    
//                                    Model.shared.getTargets3(myLocation: dummyLocation)
                                    Model.shared.getTweeterByDist(myLocation: dummyLocation)
//                                    Modelv2.shared.getTweeterByDist(myLocation: dummyLocation)
                                    
                                    
                                    //                                    let distMap = Modelv2.shared.getTweeterDist(myLocation: dummyLocation)
                                    //
                                    //                                    Modelv2.shared.getTweetData(totalMapSenders: distMap)

                                    
                                    
//                                    Model.shared.getTargets2(myLocation: dummyLocation) { targets in
////
////                                        scene.addTargetArray(targets: targets)
//
//                                        for target in targets {
//                                            print(target.sprite?.position ?? "no position")
//                                            print(target.sprite?.size ?? "no size")
//                                            scene.addTarget(target: target)
//                                            
//                                        }
//                                    }
//                                    
                                    
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

