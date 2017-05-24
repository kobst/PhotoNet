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


protocol GoToDetail: class {
    
    //    func goToDetail(targetSprite: TargetSprite)
    //
    //    func goToTweet(targetSprite: TargetSprite)
    
    func goToProfile()
    //    func goToTweetTarget(target: TargetSpriteNew)
    func goToUserTarget(target: TargetSpriteNew)
    
    
}


class PlayViewController: UIViewController, GoToDetail {
    
    //    var selectedSprite: TargetSprite?
    
    var didAddNodes: Bool = false
    
    @IBOutlet weak var backButton: UIButton!
    
    var distanceConversion: Double?
    
    var selectedTarget: TargetSpriteNew?
    
    @IBOutlet weak var overlay: UIView!
    
    var targets: [UserTarget]!
    //    var sceneView: SCNView?
    
    //    var sceneKitScene = GameScene(create: true)
    
    @IBOutlet weak var sceneView: SKView!

    var fieldScene: FieldScene!
    
    weak var mapView: MGLMapView!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetail" {
            
            let detailVC = segue.destination as! DetailViewController
            detailVC.target = selectedTarget
            
        }
        
        if segue.identifier == "toCamView" {
            
            let detailVC = segue.destination as! CamViewController
            detailVC.target = selectedTarget
            
        }
    }
    
    
    
    func goToProfile() {
        
        performSegue(withIdentifier: "toProfile", sender: nil)
    }
    
    func returnToCenter() {
        
        fieldScene.returnToCenter()
        
        
    }
    
    
    @IBAction func backButtonTouchUpInside(_ sender: Any) {
    
//        returnToCenter()
        
        
        view.bringSubview(toFront: overlay)
        view.bringSubview(toFront: backButton)
        
        for view in overlay.subviews {
            view.removeFromSuperview()
        }
        
   
        for target in Model.shared.targetSpriteNew {
            
            target.animateExit()
            
            let point = target.origPos
            
            let sceneViewPt = sceneView.scene!.convertPoint(toView: point!)
            
            let overlayPt = sceneView.convert(sceneViewPt, to: overlay)
            
            let blip = Blip(pos: overlayPt)
            
           
            
            overlay.addSubview(blip)
   
        }
        
        
        mapView.centerCoordinate = convertScale()
        
        dismiss(animated: false, completion: nil)

    }
    
    
    func convertScale() -> CLLocationCoordinate2D {
        
        
        
        let closestSprite = fieldScene.targetSpritesByDistance[0]
        
        // make closestSprite have a lat/lon property....
        
        let closestUser = closestSprite.target as! UserTarget
        
        
        let deltaSpriteY = closestSprite.origPos?.y
        let deltaCoordinateY = closestUser.lat - (Model.shared.myLocation?.coordinate.latitude)!
//        let deltaCoordinateY = closestUser.lat - (Model.shared.myDraggedLocation?.latitude)!
        
        
        let deltaSpriteX = closestSprite.origPos?.x
        let deltaCoordinateX = closestUser.lon - (Model.shared.myLocation?.coordinate.longitude)!
//        let deltaCoordinateX  = closestUser.lat - (Model.shared.myDraggedLocation?.longitude)!
        
        
        let slopeY = deltaCoordinateY / Double(deltaSpriteY!)
        let slopeX = deltaCoordinateX / Double(deltaSpriteX!)
        
        
        let newCenterLat = slopeY * Double(Model.shared.myScreenOrigin.y) + (Model.shared.myLocation?.coordinate.latitude)!
        let newCenterLon = slopeX * Double(Model.shared.myScreenOrigin.x) + (Model.shared.myLocation?.coordinate.longitude)!
        
        
        return CLLocationCoordinate2D(latitude: newCenterLat, longitude: newCenterLon)
        

    }
    
    
    func radiansToDegrees (radians: Double)->Double {
        return radians * 180 / M_PI
    }
    
    
    func locationWithBearing(bearing:Double, distanceMeters:Double, origin:CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        let distRadians = distanceMeters / (6372797.6) // earth radius in meters
        
        let lat1 = origin.latitude * M_PI / 180
        let lon1 = origin.longitude * M_PI / 180
        
        let lat2 = asin(sin(lat1) * cos(distRadians) + cos(lat1) * sin(distRadians) * cos(bearing))
        let lon2 = lon1 + atan2(sin(bearing) * sin(distRadians) * cos(lat1), cos(distRadians) - sin(lat1) * sin(lat2))
        
        return CLLocationCoordinate2D(latitude: lat2 * 180 / M_PI, longitude: lon2 * 180 / M_PI)
    }
    
    
    func goToUserTarget(target: TargetSpriteNew) {
        selectedTarget = target
        //         performSegue(withIdentifier: "toDetail", sender: nil)
        performSegue(withIdentifier: "toCamView", sender: nil)
    }
    
    @IBAction func unwindToMain(segue: UIStoryboardSegue) {}

    
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
        
        
        if didAddNodes == false {
            // Create and configure the scene.
            fieldScene = FieldScene(size: mapView.bounds.size, map: mapView)
            //        scene.addMapScene(map: mapView)
            fieldScene.delegateMainVC = self
            fieldScene.scaleMode = .aspectFill
            sceneView.presentScene(fieldScene)
            sceneView.frame = view.frame
            //        sceneView.overlaySKScene = sceneKitScene
            
            let myLoc = CLLocationCoordinate2D(latitude: (Model.shared.myLocation?.coordinate.latitude)!, longitude: (Model.shared.myLocation?.coordinate.longitude)!)
            let centerPt = mapView.convert(myLoc, toPointTo: overlay)
            fieldScene.centerNode.position = centerPt

            
            
            for target in Model.shared.userTargets {
     
                
                let pt = mapView.convert(target.annotation.coordinate, toPointTo: sceneView)

                
                let pt2 = sceneView.convert(pt, to: sceneView.scene!)
                
                
                let node = TargetSpriteNew(target: target, pos: pt2)
                Model.shared.targetSpriteNew.append(node)
  
                fieldScene.addChild(node)
                node.isHidden = true
                node.animateSize()
                node.changePhysicsBody()
            
            }
            
            didAddNodes = true
        }
        
        
        for target in Model.shared.userTargets {
            
            let blipPt = mapView.convert(target.annotation.coordinate, toPointTo: overlay)
            let blip = Blip(pos: blipPt)
            overlay.addSubview(blip)
            UIView.animate(withDuration: 2.0, animations: { 
                blip.alpha = 0
                
            })
        }
 
        
    
        }
    

    
    deinit {
         Model.shared.targetSpriteNew = []
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        view.bringSubview(toFront: overlay)
        view.bringSubview(toFront: backButton)
        overlay.isUserInteractionEnabled = false
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.isMultipleTouchEnabled = false
        
        
        let locMgr: INTULocationManager = INTULocationManager.sharedInstance()
        
        locMgr.subscribeToHeadingUpdates { (heading, status) in
            if status == .success {
                print(heading?.trueHeading ?? "no heading")
                Model.shared.myHeading = heading?.trueHeading
            }
        }
        
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}






