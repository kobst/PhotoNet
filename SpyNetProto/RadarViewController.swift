//
//  RadarViewController.swift
//  SpyNetProto
//
//  Created by Edward Han on 3/22/17.
//  Copyright © 2017 Edward Han. All rights reserved.
//

import UIKit
import Mapbox
import INTULocationManager
import SpriteKit

class CustomAnnotationView: MGLAnnotationView {
    override func layoutSubviews() {
        super.layoutSubviews()

        // Force the annotation view to maintain a constant size when the map is tilted.
        scalesWithViewingDistance = false

        // Use CALayer’s corner radius to turn this view into a circle.
        layer.cornerRadius = frame.width / 2
        layer.borderWidth = 2
        layer.borderColor = UIColor.red.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Animate the border width in/out, creating an iris effect.
        let animation = CABasicAnimation(keyPath: "borderWidth")
        animation.duration = 0.1
        layer.borderWidth = selected ? frame.width / 4 : 2
        layer.add(animation, forKey: "borderWidth")
    }
}


protocol AddBlips: class {
    func addTargetBlips(target: UserTarget)
}

class RadarViewController: UIViewController, MGLMapViewDelegate, AddBlips {

    @IBOutlet weak var overlay: UIView!

    @IBOutlet weak var buttonView: UIView!

    var myLocation: CLLocationCoordinate2D!

    var annotations: [MGLAnnotation] = []

    var targets: [UserTarget] = []
    
    var genTargets: [UserTarget] = []
    
    var blips: [Blip] = []
    
    var blipStatus: Bool!
    
    var centerBlip = UIView()
    
    var cameraMap = MGLMapCamera()

    @IBOutlet weak var sceneView: SKView!
    
    var fieldScene: FieldScene!
    
    @IBOutlet weak var radarMap: MGLMapView!

    @IBAction func goPlayNew(_ sender: Any) {
        
        
        
        Model.shared.myLocation = CLLocation(latitude: radarMap.centerCoordinate.latitude, longitude: radarMap.centerCoordinate.longitude)
        
        Session.sharedSession.myLocation = CLLocationCoordinate2D(latitude: radarMap.centerCoordinate.latitude, longitude: radarMap.centerCoordinate.longitude)
        
         performSegue(withIdentifier: "toPlay", sender: nil)

        

        
        
        
        
//        performSegue(withIdentifier: "toPlay", sender: nil)
//        for blip in blips {
//            blip.removeFromSuperview()
//        }
//
//
//        if !blipStatus {
//            addOverlayBlips()
//            let camera = MGLMapCamera(lookingAtCenter: radarMap.centerCoordinate, fromDistance: 4500, pitch: 150, heading: 80)
//            
//            radarMap.setCamera(camera, withDuration: 5, animationTimingFunction: CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut))

//            cameraMap = MGLMapCamera(lookingAtCenter: radarMap.centerCoordinate, fromDistance: 275, pitch: 15, heading: 180)
//            radarMap.camera = cameraMap
//
//            zoomMap()
//
//            blipStatus = true
        
//            fieldScene = FieldScene(size: radarMap.bounds.size, map: radarMap)
//    //        scene.addMapScene(map: mapView)
////            fieldScene.delegateMainVC = self
//            fieldScene.scaleMode = .aspectFill
//            sceneView.presentScene(fieldScene)
            
//            for target in Model.shared.userTargets {
//
//                let pt = radarMap.convert(target.annotation.coordinate, toPointTo: sceneView)
//
//                let pt2 = sceneView.convert(pt, to: sceneView.scene!)
//
//                let node = TargetSpriteNew(target: target, pos: pt2)
//                Model.shared.targetSpriteNew.append(node)
//                fieldScene.addChild(node)
//
//                node.isHidden = false
//                node.animateSize()
//                node.changePhysicsBody()
//
//            }
//
//
//        }
//
//        else {
//
//            blipStatus = false
//
//

//
////            cameraMap = MGLMapCamera(lookingAtCenter: radarMap.centerCoordinate, fromDistance: 275, pitch: 88, heading: 180)
////            radarMap.camera = cameraMap
////
////            zoomMap()
//
//
//        }
        
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSceneKit" {
            let vc = segue.destination as! SceneKitViewController
            vc.map = radarMap
        }

        if segue.identifier == "toMain" {
            let vc = segue.destination as! MainViewController
            vc.mapView = radarMap
        }

        if segue.identifier == "toPlay" {
            let vc = segue.destination as! PlayViewController

            // zoom in/out to get to right annotation view? or zoom in the play view controller. 
            // or zoom in/out first then show the annotations....
            vc.mapView = radarMap
            vc.targets = targets

        }

    }

    func makeSprites() {
        for point in annotations {
            let overlayPoint = radarMap.convert(point.coordinate, toPointTo: self.overlay)
            let imageView = UIView()

            imageView.backgroundColor = UIColor.cyan

            imageView.frame.size.width = 20
            imageView.frame.size.height = 20
            imageView.layer.cornerRadius = 10
            imageView.center = overlayPoint
            overlay.addSubview(imageView)

        }

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        for view in overlay.subviews {
            view.removeFromSuperview()
        }
        
        addOverlayBlips()
        
    }
    
    
    func addOverlayBlips() {

        for target in Model.shared.userTargets {

            let overlayPoint = radarMap.convert(target.annotation.coordinate, toPointTo: self.overlay)
            
            let blip = Blip(pos: overlayPoint)
            
            blips.append(blip)

            overlay.addSubview(blip)
        }

    }

    func addTargetBlips(target: UserTarget) {
        //        annotations.append(target.annotation)
        targets.append(target)
        radarMap.addAnnotation(target.annotation)

    }



    func zoomMap() {

        var closestAnnotations: [MGLAnnotation] = []
        
        for target in Model.shared.userTargetsByDistance {
            radarMap.addAnnotation(target.annotation)
            
        }

        for i in 0...3 {
            closestAnnotations.append(Model.shared.userTargetsByDistance[i].annotation)
        }
        radarMap.showAnnotations(closestAnnotations, animated: true)
        //        radarMap.removeAnnotations(annotations)
        //        addOverlayBlips()

    }

    
//       override func viewDidAppear(_ animated: Bool)  {
//        for blip in blips {
//            blip.removeFromSuperview()
//        }
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        blipStatus = false

        Model.shared.myDraggedLocation =  CLLocationCoordinate2D(latitude: (Model.shared.myLocation?.coordinate.latitude)!, longitude: (Model.shared.myLocation?.coordinate.longitude)!)
        

        myLocation = CLLocationCoordinate2D(latitude: (Model.shared.myLocation?.coordinate.latitude)!, longitude: (Model.shared.myLocation?.coordinate.longitude)!)


        
        radarMap.delegate = self
        radarMap.isZoomEnabled = true
        radarMap.isPitchEnabled = true
        radarMap.latitude = myLocation.latitude
        radarMap.longitude = myLocation.longitude
     
        
        cameraMap = MGLMapCamera(lookingAtCenter: radarMap.centerCoordinate, fromDistance: 75, pitch: 85, heading: 180)
        radarMap.camera = cameraMap
        radarMap.setZoomLevel(15 , animated: true)
        radarMap.isUserInteractionEnabled = true
        view.addSubview(radarMap)
//        sceneView.isHidden = true
//        view.bringSubview(toFront: overlay)

//        let centerScreenPoint: CGPoint = radarMap.convert(radarMap.centerCoordinate, toPointTo: self.overlay)
        
        let myLoc = CLLocationCoordinate2D(latitude: (Model.shared.myLocation?.coordinate.latitude)!, longitude: (Model.shared.myLocation?.coordinate.longitude)!)

        let centerScreenPoint: CGPoint = radarMap.convert(myLoc, toPointTo: self.overlay)

        print("Screen center: \(centerScreenPoint) = \(radarMap.center)")

//        let imageView = UIView()
        centerBlip.backgroundColor = UIColor.green

        centerBlip.frame.size.width = 20
        centerBlip.frame.size.height = 20
        centerBlip.layer.cornerRadius = 10
        centerBlip.center = CGPoint(x: centerScreenPoint.x, y: centerScreenPoint.y)
        overlay.addSubview(centerBlip)
        view.bringSubview(toFront: overlay)
        view.bringSubview(toFront: buttonView)
        overlay.isUserInteractionEnabled = false
        

        Model.shared.addBlipDelegate = self


        view.backgroundColor = UIColor.black

        
        fieldScene = FieldScene(size: radarMap.bounds.size, map: radarMap)
        //        scene.addMapScene(map: mapView)
        //            fieldScene.delegateMainVC = self
        fieldScene.scaleMode = .aspectFill
        sceneView.presentScene(fieldScene)
        
        view.bringSubview(toFront: sceneView)
        sceneView.isHidden = false
        
        Model.shared.getTargetsNewVerComp2(myLocation: Model.shared.myLocation!) {
            print("done in closure")

            print(Model.shared.userTargets.count)

            

            self.zoomMap()
            
            
            for target in Model.shared.userTargets {
            
            
                let pt = self.radarMap.convert(target.annotation.coordinate, toPointTo: self.sceneView)
            
                let pt2 = self.sceneView.convert(pt, to: self.sceneView.scene!)
            
            
                let node = TargetSpriteNew(target: target, pos: pt2)
                Model.shared.targetSpriteNew.append(node)
            
                self.fieldScene.addChild(node)
                print(node.position)
                node.isHidden = false
                node.animateSize()
                node.changePhysicsBody()
            
                    }
            
            
        }


    }


    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView?  {
        guard annotation is MGLPointAnnotation else {
            return nil
        }

        let reuseIdentifier = "\(annotation.coordinate.longitude)"

        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)

        // If there’s no reusable annotation view available, initialize a new one.
        if annotationView == nil {
            annotationView = CustomAnnotationView(reuseIdentifier: reuseIdentifier)
            annotationView!.frame = CGRect(x: 0, y: 0, width: 30, height: 30)

            // Set the annotation view’s background color to a value determined by its longitude.
            let hue = CGFloat(annotation.coordinate.longitude) / 100
            annotationView!.backgroundColor = UIColor(hue: hue, saturation: 0.5, brightness: 1, alpha: 1)
        }

        return annotationView

    }

    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }


    
    func mapViewRegionIsChanging(_ mapView: MGLMapView) {
        
     
//        Model.shared.moveSprites(translation: tra)
        
//        for view in overlay.subviews {
//
//            view.removeFromSuperview()
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
