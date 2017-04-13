//
//  SceneKitViewController.swift
//  SpyNetProto
//
//  Created by Edward Han on 4/3/17.
//  Copyright © 2017 Edward Han. All rights reserved.
//

import UIKit
import SceneKit
import Mapbox



class SceneKitViewController: UIViewController {
    
    
    @IBOutlet weak var SceneView: SCNView!
    

    var map: MGLMapView?

    
    
    func createScnTargets(target: TargetNew) {
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scene = GameScene(create: true, map: map!)
//        let spriteScene = FieldSceneOverlay(size: view.bounds.size)
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanFrom))
        view.addGestureRecognizer(gestureRecognizer)
        
        if let view = SceneView {
            view.scene = scene
            view.allowsCameraControl = false
            view.autoenablesDefaultLighting = false
            view.showsStatistics = true
            view.backgroundColor = UIColor.green
//            view.overlaySKScene = spriteScene
//            view.addGestureRecognizer(gestureRecognizer)
        }
        
        for userTarget in Model.shared.userTargetsByDistance {
//            Model.shared.addTargetDelegate?.addTargetSpritesNew(target: userTarget)
            scene.createScnTargets(target: userTarget)
        }
        
        

//        self.view.addGestureRecognizer(gestureRecognizer)
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func handlePanFrom(recognizer: UIPanGestureRecognizer) {
        if recognizer.state == .changed {
            var translation = recognizer.translation(in: recognizer.view!)
            translation = CGPoint(x: translation.x, y: -translation.y)
            Model.shared.moveScnTargets(translation: translation)
        }
        
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
