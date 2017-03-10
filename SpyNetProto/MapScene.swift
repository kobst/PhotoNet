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

class GameScene: SCNScene {
    
//    var geometryNodes = GeometryNodes()
    let cameraNode = SCNNode()
    var map = MKMapView()
    
    convenience init(create: Bool) {
        self.init()
        
//        geometryNodes.addNodesTo(rootNode)
        
        let floor = SCNFloor()
//        floor.firstMaterial!.diffuse.contents = UIColor.white
//        fillMap(mapView: map)
        
        floor.firstMaterial!.diffuse.contents = map
        
        floor.firstMaterial!.specular.contents = UIColor.white
        floor.firstMaterial!.reflective.contents = UIColor.black
        
        let floorNode = SCNNode(geometry: floor)
        rootNode.addChildNode(floorNode)
        
        
        cameraNode.camera = SCNCamera()
        //cameraNode.camera!.usesOrthographicProjection = true
        cameraNode.position = SCNVector3(0, 1, 2)
        cameraNode.rotation = SCNVector4(1,0,0, Float(-M_PI / 16.0))
        
        rootNode.addChildNode(cameraNode)
        
        let lightNodeSpot = SCNNode()
        lightNodeSpot.light = SCNLight()
        lightNodeSpot.light!.type = SCNLight.LightType.spot
        lightNodeSpot.light!.attenuationStartDistance = 0
        lightNodeSpot.light!.attenuationFalloffExponent = 2
        lightNodeSpot.light!.attenuationEndDistance = 30
        lightNodeSpot.position = SCNVector3(0,3,2)
        
        rootNode.addChildNode(lightNodeSpot)
        
//        let emptyTarget = SCNNode()
//        emptyTarget.position = SCNVector3(0,0,0)
//        
//        lightNodeSpot.constraints = [SCNLookAtConstraint(target: emptyTarget )]
        
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

