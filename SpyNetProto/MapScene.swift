//
//  MapScene.swift
//  SpyNetProto
//
//  Created by Edward Han on 3/9/17.
//  Copyright © 2017 Edward Han. All rights reserved.
//



import UIKit
import QuartzCore
import SceneKit
import MapKit
import Mapbox


class GameScene: SCNScene {
    
//    var geometryNodes = GeometryNodes()
    let cameraNode = SCNNode()
//    var map = MKMapView()
//    var map = MGLMapView()

    
    func snapshot(view: UIView) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, true, 0)
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        let snapshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return snapshot!
    }
    
    
    func takeSnapshot(mapView: MGLMapView, withCallback: @escaping (UIImage?, Error?) -> ()) {
        let options = MKMapSnapshotOptions()
        //        options.region = mapView.region
        options.size = mapView.frame.size
        options.scale = UIScreen.main.scale
        
        let snapshotter = MKMapSnapshotter(options: options)
        snapshotter.start() { snapshot, error in
            guard snapshot != nil else {
                withCallback(nil, error)
                return
            }
            
            withCallback(snapshot!.image, nil)
        }
    }
    
    convenience init(create: Bool, map: MGLMapView) {
        self.init()
        
//        geometryNodes.addNodesTo(rootNode)
        
        let floor = SCNFloor()
        let sphere = SCNSphere()
//        floor.firstMaterial!.diffuse.contents = UIColor.white
//        fillMap(mapView: map)
        
        
//        takeSnapshot(mapView: map) { (imageMap, error) in
//            floor.firstMaterial?.diffuse.contents = imageMap
//            floor.firstMaterial?.isDoubleSided = true
//            sphere.firstMaterial?.diffuse.contents = imageMap
//        }
        
        
        floor.firstMaterial?.diffuse.contents = snapshot(view: map)
        sphere.firstMaterial?.diffuse.contents = snapshot(view: map)
        
//        floor.firstMaterial!.diffuse.contents = UIImage(named: "androidjones")
//        floor.firstMaterial!.diffuse.contents = UIColor.red
//        floor.firstMaterial!.reflective.contents = UIColor.white
        
        let cube = SCNBox()
        
        
        let floorNode = SCNNode(geometry: floor)
        floorNode.position = SCNVector3(0,-5,0)
//        let sphereNode = SCNNode(geometry: sphere)
        rootNode.addChildNode(floorNode)
//        rootNode.addChildNode(sphereNode)
        cameraNode.camera = SCNCamera()
        //cameraNode.camera!.usesOrthographicProjection = true
        cameraNode.position = SCNVector3(0, 5, -3)
//        cameraNode.rotation = SCNVector4(1,0,0, Float(-M_PI / 16.0))
        
        rootNode.addChildNode(cameraNode)
        
        let lightNodeSpot = SCNNode()
        lightNodeSpot.light = SCNLight()
        lightNodeSpot.light!.type = SCNLight.LightType.ambient
//        lightNodeSpot.light!.attenuationStartDistance = 0
//        lightNodeSpot.light!.attenuationFalloffExponent = 2
//        lightNodeSpot.light!.attenuationEndDistance = 30
        lightNodeSpot.position = SCNVector3(0,0,0)
        
        
        let lightNodeSpot2 = SCNNode()
        lightNodeSpot2.light = SCNLight()
        lightNodeSpot2.light!.type = SCNLight.LightType.ambient
        //        lightNodeSpot.light!.attenuationStartDistance = 0
        //        lightNodeSpot.light!.attenuationFalloffExponent = 2
        //        lightNodeSpot.light!.attenuationEndDistance = 30
        lightNodeSpot2.position = SCNVector3(0,10,10)
        
        rootNode.addChildNode(lightNodeSpot2)
        rootNode.addChildNode(lightNodeSpot)
        
        let emptyTarget = SCNNode()
        emptyTarget.position = SCNVector3(0,0,0)
        
        lightNodeSpot.constraints = [SCNLookAtConstraint(target: emptyTarget )]
        
    }
    
}





//
//func fillMap(mapView: MKMapView) {
//    
//    let lanDelta: CLLocationDegrees = 0.00005
//    
//    let lonDelta: CLLocationDegrees = 0.00005
//    
//    let span = MKCoordinateSpan(latitudeDelta: lanDelta, longitudeDelta: lonDelta)
//    
//    let center = CLLocationCoordinate2D(latitude: (Model.shared.myLocation?.coordinate.latitude)!, longitude: (Model.shared.myLocation?.coordinate.longitude)!)
//    
//    let region = MKCoordinateRegion(center: center, span: span)
//    
//    mapView.setRegion(region, animated: true)
//  
//}

