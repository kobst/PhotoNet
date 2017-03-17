//
//  sceneKitScene.swift
//  SpyNetProto
//
//  Created by Edward Han on 3/14/17.
//  Copyright © 2017 Edward Han. All rights reserved.
//
//
//  GameScene.swift
//  Basics
//
//  Created by Ibram Uppal on 10/25/15.
//  Copyright © 2015 Ibram Uppal. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit
import MapKit
import SpriteKit

//func fillMap() -> MKMapView {
//    
//    let mapView = MKMapView()
//    let lanDelta: CLLocationDegrees = 0.00005
//    
//    let lonDelta: CLLocationDegrees = 0.00005
//    
//    let span = MKCoordinateSpan(latitudeDelta: lanDelta, longitudeDelta: lonDelta)
//    
//    let center = CLLocationCoordinate2D(latitude: 40.4134134, longitude: -73.9143145)
//    
//    let region = MKCoordinateRegion(center: center, span: span)
//    
//    mapView.setRegion(region, animated: true)
//    
//    return mapView
//    
//}



protocol AddSceneNode: class {
    
    func addTargetNode(target: TargetNew)
    
    
}


protocol FillMap: class {
    
    func fillMap()
}


class GameScene: SCNScene, AddSceneNode, FillMap {
    

    let cameraNode = SCNNode()
    var mapView = MKMapView()
    
    let floor = SCNFloor()
    
//    func setMap(location: CLLocation) {
//        
//        let regionRadius = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
//        let region = MKCoordinateRegion(center: location.coordinate, span: regionRadius)
//        
//        map.setRegion(region, animated: true)
//        
//        
//    }
    
    
    
    func fillMap() {
        
        
        let userLocation = Model.shared.myLocation
        
//        let destAnnotation = MKPointAnnotation()
//        destAnnotation.coordinate = (userLocation?.coordinate)!
        
        let latitude = userLocation?.coordinate.latitude
        
        let longitude = userLocation?.coordinate.longitude
        
        let lanDelta: CLLocationDegrees = 0.005
        
        let lonDelta: CLLocationDegrees = 0.005
        
        let span = MKCoordinateSpan(latitudeDelta: lanDelta, longitudeDelta: lonDelta)
        
        let center = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
        
        let region = MKCoordinateRegion(center: center, span: span)
        
        mapView.setRegion(region, animated: true)
        
        takeSnapshot(mapView: mapView) { (mapImage) in
            self.floor.firstMaterial?.diffuse.contents = mapImage
        }
        
        //        floor.firstMaterial!.diffuse.contents = UIImage(named: "5MEO")
        //        floor.firstMaterial!.specular.contents = UIImage(named: "12apostles")
        floor.firstMaterial!.reflective.contents = UIColor.clear
        
        
        let floorNode = SCNNode(geometry: floor)
        floorNode.position = SCNVector3(0, -5, 0)
        floorNode.rotation = SCNVector4(0, 0, 0, Float(-M_PI))
        rootNode.addChildNode(floorNode)
        
        
//        mapView.addAnnotation(destAnnotation)
    }

    
    
    convenience init(create: Bool) {
        self.init()
        

        Model.shared.addTargetSceneNode = self
        
        Model.shared.fillMapDelegate = self
        
        
        cameraNode.camera = SCNCamera()
        //cameraNode.camera!.usesOrthographicProjection = true
        cameraNode.position = SCNVector3(0, 0, 20)
        cameraNode.rotation = SCNVector4(1,0,0, Float(-M_PI / 16.0))
        
        rootNode.addChildNode(cameraNode)
        
        let lightNodeSpot = SCNNode()
        lightNodeSpot.light = SCNLight()
        lightNodeSpot.light!.type = SCNLight.LightType.omni
        lightNodeSpot.position = SCNVector3(0,0,10)
        
        
        let overheadLight = SCNNode()
        overheadLight.light = SCNLight()
        overheadLight.light!.type = SCNLight.LightType.ambient
        overheadLight.position = SCNVector3(0, 15, 0)
        
        rootNode.addChildNode(overheadLight)
        rootNode.addChildNode(lightNodeSpot)
        
        let emptyTarget = SCNNode()
        emptyTarget.position = SCNVector3(0,0,0)
        lightNodeSpot.constraints = [SCNLookAtConstraint(target: emptyTarget )]
        
        
 
        
    }
    
    
    
    
    
    //        UIPanGestureRecognizer(target: self, action: "rotateXGesture:")
    //        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.panHandle(_:)))
    //
    //        self.addGestureRecognizer(panGesture)
    
    
    //        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(GameViewController.handleTap(_:)))
    //        self.addGestureRecognizer(tapGesture)
    
    
    
    
    //    func panHandle(sender: UIPanGestureRecognizer) {
    //        let translation = (sender.translation(in: sender.view!))
    //        cameraNode.position.x += translation.x
    //        cameraNode.position.z -= translation.y
    //
    //    }
    
    
    
    
    func addTargetNode(target: TargetNew) {
        
        
        
        
        let targetPlane = SCNPlane(width: 1.5, height: 1.5)
        targetPlane.cornerRadius = targetPlane.width / 2
        
        targetPlane.firstMaterial?.diffuse.contents = UIImage(named: "trippy2")
        
        
        
        let targetNode = SCNNode(geometry: targetPlane)
  
        
        let x = target.origPos.x / 100
        let y = target.origPos.y / 100
        targetNode.position = SCNVector3(x, y, 0)
        rootNode.addChildNode(targetNode)
        
//        let targetNode = TargetSceneNode(target: target)
//        rootNode.addChildNode(targetNode)
        
        
        
    }
    
    
    
    
    
    func addTargetSpritesNew(target: TargetNew) {
        
        let sprite = TargetSpriteNew(target: target)
        
        Model.shared.targetSpriteNew.append(sprite)
        
        
        
        if sprite.category == .tweet {
            Model.shared.fetchImage(stringURL: sprite.profileImageURL) { returnedImage in
                guard let validImage = returnedImage else {
                    return
                }
                let roundedImage = validImage.circle
                let myTexture = SKTexture(image: roundedImage!)
                sprite.texture = myTexture
                
            }

            
        }
    }
    
    
    
    
    func shift(translationX: Float, translationY: Float) {
        
        cameraNode.position.x -= translationX * 10
        cameraNode.position.z -= translationY * 10
        
        
    }
    
}






func takeSnapshot(mapView: MKMapView, withCallback: @escaping (UIImage?) -> ()) {
    let options = MKMapSnapshotOptions()
    options.region = mapView.region
    options.size = CGSize(width: 400, height: 400)
    options.scale = CGFloat(2)
    
    let snapshotter = MKMapSnapshotter(options: options)
    snapshotter.start() { snapshot, error in
        guard snapshot != nil else {
            //            withCallback(nil, error as NSError?)
            return
        }
        
        withCallback(snapshot!.image)
    }
}
