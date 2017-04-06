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
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scene = GameScene(create: true, map: map!)

        if let view = SceneView {
            view.scene = scene
            view.allowsCameraControl = true
            view.autoenablesDefaultLighting = false
            view.showsStatistics = true
            view.backgroundColor = UIColor.green
            
            
        }
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
