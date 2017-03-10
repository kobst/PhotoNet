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
import SceneKit


protocol GoToDetail: class {
    
//    func goToDetail(targetSprite: TargetSprite)
//
//    func goToTweet(targetSprite: TargetSprite)
    
    func goToProfile()
    func goToTweetTarget(target: TargetSpriteNew)
    func goToUserTarget(target: TargetSpriteNew)
    
    
}

class MainViewController: UIViewController, GoToDetail {
    
//    var selectedSprite: TargetSprite?
    
    var selectedTarget: TargetSpriteNew?
    
//    var sceneView: SCNView?
    
    var sceneKitScene = GameScene(create: true)
    
    @IBOutlet weak var sceneView: SCNView!
    
    var spriteKitScene: SKScene?

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetail" {
            
            let detailVC = segue.destination as! DetailViewController
            detailVC.target = selectedTarget
            
        }
        
        
        if segue.identifier == "toTweet" {
            
            let tweetVC = segue.destination as! TweetDetailViewController
            tweetVC.target = selectedTarget
        }
    }
    
    
    
    func goToProfile() {
        
        performSegue(withIdentifier: "toProfile", sender: nil)
    }
    
//    func goToDetail(targetSprite: TargetSprite) {
//        
//        selectedSprite = targetSprite
//        performSegue(withIdentifier: "toDetail", sender: nil)
//        
//        
//    }
//    
//    
//    func goToTweet(targetSprite: TargetSprite) {
//        selectedSprite = targetSprite
//         performSegue(withIdentifier: "toTweet", sender: nil)
//        
//    }
    
    
    func goToTweetTarget(target: TargetSpriteNew) {
        selectedTarget = target
         performSegue(withIdentifier: "toTweet", sender: nil)
    }
    
    
    func goToUserTarget(target: TargetSpriteNew) {
        selectedTarget = target
         performSegue(withIdentifier: "toDetail", sender: nil)
    }
    
     @IBAction func unwindToMain(segue: UIStoryboardSegue) {}
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        var fieldScene: FieldScene!
        
        sceneView.allowsCameraControl = true
        sceneView.autoenablesDefaultLighting = true // 5
        sceneView.showsStatistics = true // 6
        sceneView.backgroundColor = .black
        
        let scene = SCNScene()
        sceneView.scene = scene
        
        let sphereGeometry = SCNSphere(radius: 2) // 1
        let sphereNode = SCNNode(geometry: sphereGeometry) // 2
        sphereNode.position = SCNVector3Zero // 3
        scene.rootNode.addChildNode(sphereNode) // 4
        
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3Make(0, 0, 8)
        scene.rootNode.addChildNode(cameraNode)
        
        // Create and configure the scene.
        fieldScene = FieldScene(size: sceneView.bounds.size)
        fieldScene.delegateMainVC = self
        fieldScene.scaleMode = .aspectFill
        sceneView.overlaySKScene = fieldScene
//        sceneView.overlaySKScene = sceneKitScene
    
        
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
                                    
                                    Model.shared.getEater(myLocation: dummyLocation)
                                    Model.shared.getTargetNew(myLocation: dummyLocation)
                                    Model.shared.getTweeterByDist(myLocation: dummyLocation)

                                    Model.shared.getTimeOutEvents(myLocation: dummyLocation)
                                    
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

