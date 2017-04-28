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


protocol CreateScnTargets: class {
    func createScnTargets(target: TargetNew)
}

protocol MoveSceneTargets: class {
    func handlePan(translation: CGPoint)
}

    

class GameScene: SCNScene, CreateScnTargets, MoveSceneTargets {
    
//    var geometryNodes = GeometryNodes()
    let cameraNode = SCNNode()
//    var map = MKMapView()
//    var map = MGLMapView()

    let lightNode = SCNNode()
    
    var targetNodes: [TargetScnNode] = []
    
    var planeNode = SCNNode()
    
    func handlePan(translation: CGPoint){
        print(translation)
        let adjustedX = translation.x / 10
        let adjustedY = translation.y / 10
//        planeNode.position.x += Float(adjustedX)
//        planeNode.position.y += Float(adjustedY)
//        print(adjustedY)
//        print(adjustedX)
//        print("-------adjustx")
//       lightNode.position.x += Float(adjustedX)
//        lightNode.position.y += Float(adjustedY)
//        lightNode.light?.color = UIColor.lightGray
        
        
        
//        let emptyTarget = SCNNode()
//        emptyTarget.position = SCNVector3(adjustedX, adjustedY, 0)
//        lightNode.constraints = [SCNLookAtConstraint(target: emptyTarget)]
        
//        planeNode.eulerAngles = SCNVector3(x: GLKMathDegreesToRadians(-70), y: 0, z: 0)
        
//        cameraNode.position.x -= Float(adjustedX)
//        cameraNode.position.y -= Float(adjustedY)
    
//        for node in targetNodes {
//            node.position.x += Float(adjustedX)
//            node.position.y += Float(adjustedY)
//        }
        
    }
    
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
    
    
    
    func createScnTargets(target: TargetNew) {
        let scnNode = TargetScnNode(target: target)
        
        Model.shared.fetchImage(stringURL: scnNode.profileImageURL) { (imageReturned) in
            if let image = imageReturned {
                scnNode.geometry?.firstMaterial?.diffuse.contents = image.circle
                let randY = Int(arc4random()%2)
                let randX = Int(arc4random()%2)
                scnNode.position = SCNVector3(randX, randY, 0)
                self.rootNode.addChildNode(scnNode)
                self.targetNodes.append(scnNode)
                
            }
        }
        
        
    }
    
    convenience init(create: Bool, map: MGLMapView) {


        
        self.init()
        
//        geometryNodes.addNodesTo(rootNode)
        
        
        Model.shared.moveScnTargetDelegate = self
        
        let floor = SCNFloor()
        let cube = SCNBox()
        let sphere = SCNSphere()
        let plane = SCNPlane()
//        floor.firstMaterial!.diffuse.contents = UIColor.white
//        fillMap(mapView: map)
        
        
//        takeSnapshot(mapView: map) { (imageMap, error) in
//            floor.firstMaterial?.diffuse.contents = imageMap
//            floor.firstMaterial?.isDoubleSided = true
//            sphere.firstMaterial?.diffuse.contents = imageMap
//        }
        
        
        floor.firstMaterial?.diffuse.contents = snapshot(view: map)
        sphere.firstMaterial?.diffuse.contents = snapshot(view: map)
        plane.firstMaterial?.diffuse.contents = snapshot(view: map)
//        floor.firstMaterial!.diffuse.contents = UIImage(named: "androidjones")
//        floor.firstMaterial!.diffuse.contents = UIColor.red
//        floor.firstMaterial!.reflective.contents = UIColor.white
        
      
        
        cube.firstMaterial?.diffuse.contents = snapshot(view: map)
        
        let cubeNode = SCNNode(geometry: cube)
        cube.height = 10
        cube.width = 10
        cubeNode.position = SCNVector3(0,0,0)

        
        let floorNode = SCNNode(geometry: floor)
        floorNode.position = SCNVector3(0,-5,0)
        
        plane.height = 6
        plane.width = 3
        planeNode = SCNNode(geometry: plane)
        planeNode.position = SCNVector3(0,-1,-3)
        
//        planeNode.position = SCNVector3(0, -1,-3)
//        planeNode.eulerAngles = SCNVector3(x: GLKMathDegreesToRadians(-60), y: 0, z: 0)
        planeNode.eulerAngles = SCNVector3(x: GLKMathDegreesToRadians(-60), y: 0, z: 0)
//        planeNode.rotation = SCNVector4(1, 0, 0, Float(-M_PI / 5.0))
        
//        let sphereNode = SCNNode(geometry: sphere)
//        rootNode.addChildNode(floorNode)
//        rootNode.addChildNode(cubeNode)
        rootNode.addChildNode(planeNode)
        cameraNode.camera = SCNCamera()
        //cameraNode.camera!.usesOrthographicProjection = true
        cameraNode.position = SCNVector3(0, 0, 3)
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
        
        lightNode.light = SCNLight()
        lightNodeSpot2.light!.type = SCNLight.LightType.spot
        lightNode.position = SCNVector3(0,-1,0)
        
        rootNode.addChildNode(lightNodeSpot)
//        rootNode.addChildNode(lightNodeSpot)
        rootNode.addChildNode(lightNode)
        
        let emptyTarget = SCNNode()
        emptyTarget.position = SCNVector3(0,0,0)
        
        lightNodeSpot.constraints = [SCNLookAtConstraint(target: emptyTarget)]
        
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

