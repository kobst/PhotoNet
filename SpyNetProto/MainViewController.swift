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



protocol AddMap {
    
    
    func addMap()
}

class MainViewController: UIViewController, GoToDetail {
    
//    var selectedSprite: TargetSprite?
    
    var selectedTarget: TargetSpriteNew?
    
    var sceneView: SCNView?
    
//    var sceneKitScene = GameScene(create: true)
    
//    @IBOutlet weak var sceneView: SKView!
    
    
    @IBOutlet weak var sceneKitView: SCNView!
    var gameScene = GameScene(create: true)
    

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
    
    
    func handlePan(_ gesture: UIPanGestureRecognizer) {
        
        let translationx = gesture.translation(in: sceneView!).x
        
        let xTranslation = Float(translationx / view.frame.width)
        
        let translationy = gesture.translation(in: sceneView!).y
        
        let yTranslation = Float(translationy / view.frame.width)
        
        
        if gesture.state == UIGestureRecognizerState.began {
            //            || gesture.state == UIGestureRecognizerState.changed  {
            
            //            scene.shift(translationX: xTranslation, translationY: yTranslation)
            
            //                        var touchLocation = gesture.location(in: sceneView)
            //                        touchLocation = self.convertPoint(fromView: touchLocation)
            
            //            scene.geometryNodes.slide( xTranslation)
        } else if gesture.state == UIGestureRecognizerState.changed {
            
            gameScene.shift(translationX: xTranslation, translationY: yTranslation)
            
            
            //            if translation > 100 {
            //                scene.geometryNodes.realign("RIGHT")
            //
            //            } else if translation < -100 {
            //                scene.geometryNodes.realign("LEFT")
            //            } else {
            //                scene.geometryNodes.realign("STAY")
            //            }
            
        }
        
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
  
//        var scene: FieldScene!
        
        sceneView = self.sceneKitView as? SCNView
        
        if let view = sceneView {
            
            view.scene = gameScene
            //            view.overlaySKScene = spriteScene
            
            view.showsStatistics = true
            view.backgroundColor = UIColor.black
            view.antialiasingMode = SCNAntialiasingMode.multisampling4X

            
            let panGesture = UIPanGestureRecognizer(target: self, action: #selector(MainViewController.handlePan(_:)))
            //            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(GameViewController.handleTap(_:)))
            view.addGestureRecognizer(panGesture)
    
            //            view.addGestureRecognizer(tapGesture)
            
        }

//        sceneView.isMultipleTouchEnabled = false
//        
//        // Create and configure the scene.
//        scene = FieldScene(size: sceneView.bounds.size)
//        scene.delegateMainVC = self
//        scene.scaleMode = .aspectFill
//        sceneView.presentScene(scene)
        
        
        
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

