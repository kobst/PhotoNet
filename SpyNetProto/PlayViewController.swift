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

class PlayViewController: UIViewController, GoToDetail {
    
    //    var selectedSprite: TargetSprite?
    
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
    
    @IBAction func backButtonTouchUpInside(_ sender: Any) {dismiss(animated: false, completion: nil)

    }
    
    
    func goToUserTarget(target: TargetSpriteNew) {
        selectedTarget = target
        //         performSegue(withIdentifier: "toDetail", sender: nil)
        performSegue(withIdentifier: "toCamView", sender: nil)
    }
    
    @IBAction func unwindToMain(segue: UIStoryboardSegue) {}

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

//        override func viewWillAppear(_ animated: Bool) {
//            super.viewWillAppear(animated)
        
        
        
//        if fieldScene.children.count > 0 {
//            return
//        }
        
        
        view.bringSubview(toFront: overlay)
        overlay.isUserInteractionEnabled = false
        
        for target in targets {
            let blipPt = mapView.convert(target.annotation.coordinate, toPointTo: overlay)
            let blip = Blip(pos: blipPt)
            overlay.addSubview(blip)
            
            
            let pt = mapView.convert(target.annotation.coordinate, toPointTo: sceneView)
            let pt2 = sceneView.convert(pt, to: sceneView.scene!)
            let node = TargetSpriteNew(target: target)
            Model.shared.targetSpriteNew.append(node)
            node.position = pt2
            node.origPos = pt2
            fieldScene.addChild(node)
            node.isHidden = true
            node.animateSize()
            
            
            UIView.animate(withDuration: 1.5, animations: { 
                blip.alpha = 0
            })
        }
        
        
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.isMultipleTouchEnabled = false
        
        // Create and configure the scene.
        fieldScene = FieldScene(size: sceneView.bounds.size, map: mapView)
//        scene.addMapScene(map: mapView)
        fieldScene.delegateMainVC = self
        fieldScene.scaleMode = .aspectFill
        sceneView.presentScene(fieldScene)
        //        sceneView.overlaySKScene = sceneKitScene
        

        
        
        let locMgr: INTULocationManager = INTULocationManager.sharedInstance()
        //
        
        
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








