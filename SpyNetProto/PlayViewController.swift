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
import Mapbox

//protocol GoToDetail: class {
//    
//    //    func goToDetail(targetSprite: TargetSprite)
//    //
//    //    func goToTweet(targetSprite: TargetSprite)
//    
//    func goToProfile()
//    //    func goToTweetTarget(target: TargetSpriteNew)
//    func goToUserTarget(target: TargetSpriteNew)
//    
//    
//}

class PlayViewController: UIViewController, GoToDetail {
    
    //    var selectedSprite: TargetSprite?
    
    var selectedTarget: TargetSpriteNew?
    
    var targets: [UserTarget]?
    //    var sceneView: SCNView?
    
    //    var sceneKitScene = GameScene(create: true)
    
    @IBOutlet weak var sceneView: SKView!
    
    var mapView: MGLMapView!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetail" {
            
            let detailVC = segue.destination as! DetailViewController
            detailVC.target = selectedTarget
            
        }
        
        if segue.identifier == "toCamView" {
            
            let detailVC = segue.destination as! CamViewController
            detailVC.target = selectedTarget
            
        }
        
        
        //        if segue.identifier == "toTweet" {
        //
        //            let tweetVC = segue.destination as! TweetDetailViewController
        //            tweetVC.target = selectedTarget
        //        }
    }
    
    
    
    func goToProfile() {
        
        performSegue(withIdentifier: "toProfile", sender: nil)
    }
    
    
    
    func goToUserTarget(target: TargetSpriteNew) {
        selectedTarget = target
        //         performSegue(withIdentifier: "toDetail", sender: nil)
        performSegue(withIdentifier: "toCamView", sender: nil)
    }
    
    @IBAction func unwindToMain(segue: UIStoryboardSegue) {}
    
    
//    init() {
//        super.init()
//    
//    
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var scene: FieldScene!
        
        sceneView.isMultipleTouchEnabled = false
        
        // Create and configure the scene.
        scene = FieldScene(size: sceneView.bounds.size, map: mapView)
//        scene.addMapScene(map: mapView)
        scene.delegateMainVC = self
        scene.scaleMode = .aspectFill
        sceneView.presentScene(scene)
        //        sceneView.overlaySKScene = sceneKitScene
        
        
        
        for target in targets! {
            
            
                let pt2 = sceneView.convert(target.origPos, to: sceneView.scene!)
                let node = TargetSpriteNew(target: target)
                Model.shared.targetSpriteNew.append(node)
                node.position = pt2
                print("adding node \(pt2)...")
                scene.addChild(node)
            
        }
        
//        for i in 0...10 {
//            
//            let target = Model.shared.userTargetsByDistance[i]
//            let node = TargetSpriteNew(target: target)
//            let pt2 = sceneView.convert(target.origPos, to: sceneView.scene!)
//            node.position = pt2
//            Model.shared.targetSpriteNew.append(node)
//            scene.addChild(node)
//            print(node.position)
//            print(target.origPos)
//            print("postional")
//            //          scene.addTargetSpritesNew(target: userTarget)
//            
//        }
        
//        for userTarget in Model.shared.userTargetsByDistance {
//            //            Model.shared.addTargetDelegate?.addTargetSpritesNew(target: userTarget)
//            let pt2 = sceneView.convert(userTarget.origPos, to: sceneView.scene!)
//            let node = TargetSpriteNew(target: userTarget)
//            Model.shared.targetSpriteNew.append(node)
//            node.position = pt2
//            scene.addChild(node)
////          scene.addTargetSpritesNew(target: userTarget)
//        }
        
        
        let locMgr: INTULocationManager = INTULocationManager.sharedInstance()
        //
        
        
        locMgr.subscribeToHeadingUpdates { (heading, status) in
            if status == .success {
                print(heading?.trueHeading ?? "no heading")
                Model.shared.myHeading = heading?.trueHeading
            }
        }
        
        //        locMgr.requestLocation(withDesiredAccuracy: INTULocationAccuracy.block,
        //                               timeout: 5,
        //                               delayUntilAuthorized: true,
        //                               block: {(currentLocation: CLLocation?, achievedAccuracy: INTULocationAccuracy, status: INTULocationStatus) -> Void in
        //                                if status == INTULocationStatus.success {
        //                                    print("got location");
        //
        ////                                    let dummyLocation = CLLocation(latitude: 40.7369432, longitude: -73.9918239)
        ////                                    let dummyLocation = Model.shared.makeFakeLocation()
        //                                    let dummyLocation = CLLocation(latitude: 40.7369432, longitude: -73.9918239)
        ////                                    Model.shared.myOrigin = currentLocation
        ////                                    Model.shared.updateMyLocation(myLocation: currentLocation!)
        ////                                    Model.shared.getTargets3(myLocation: currentLocation!)
        //                                    Model.shared.myLocation = CLLocation(latitude: 40.7369432, longitude: -73.9918239)
        //
        //                                    print("\(currentLocation).....CL.")
        //
        //                                    Model.shared.updateMyLocation(myLocation: dummyLocation)
        ////
        //////                                    Model.shared.getTargets3(myLocation: dummyLocation)
        ////
        ////                                    Model.shared.getEater(myLocation: dummyLocation)
        //                                    Model.shared.getTargetNew(myLocation: dummyLocation)
        ////                                    Model.shared.getTweeterByDist(myLocation: dummyLocation)
        ////
        ////                                    Model.shared.getTimeOutEvents(myLocation: dummyLocation)
        //
        //                                    //                                    let distMap = Modelv2.shared.getTweeterDist(myLocation: dummyLocation)
        //                                    //
        //                                    //                                    Modelv2.shared.getTweetData(totalMapSenders: distMap)
        //
        //
        //
        ////                                    Model.shared.getTargets2(myLocation: dummyLocation) { targets in
        //////
        //////                                        scene.addTargetArray(targets: targets)
        ////
        ////                                        for target in targets {
        ////                                            print(target.sprite?.position ?? "no position")
        ////                                            print(target.sprite?.size ?? "no size")
        ////                                            scene.addTarget(target: target)
        ////
        ////                                        }
        ////                                    }
        //
        //
        //                                }
        //                                    
        //                                else {
        //                                    print("no location")
        //                                }
        //                               
        //        })
        
        
        
        // Present the scene.
        
        
        
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}








