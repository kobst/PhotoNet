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


//class Blip: UIView {
//    
//    var distance: Double
//    
//    var coordinates: CLLocationCoordinate2D
//    
//    init(point: CGPoint, distance: Double, coordinates: CLLocationCoordinate2D) {
//        self.coordinates = coordinates
//        self.distance = distance
//        
//        //        distance = CLLocationDistance[location distanceFromLocation:radarMap.centerCoordinate]
//        
//        let blipFrame = CGRect(x: 0, y: 0, width: 12, height: 12)
//        
//        //            let centerScreenPoint = radarMap.convert(point, toPointTo: self.overlay)
//        //why doesn't this work above?
//        super.init(frame: blipFrame)
//        
//        backgroundColor = UIColor.cyan
//        center = point
//        layer.cornerRadius = frame.width / 2
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//}
//func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
//    // This example is only concerned with point annotations.
//    guard annotation is MGLPointAnnotation else {
//        return nil
//    }
//    
//    // Use the point annotation’s longitude value (as a string) as the reuse identifier for its view.
//    let reuseIdentifier = "\(annotation.coordinate.longitude)"
//    
//    // For better performance, always try to reuse existing annotations.
//    var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
//    
//    // If there’s no reusable annotation view available, initialize a new one.
//    if annotationView == nil {
//        annotationView = MyAnnotationView(reuseIdentifier: reuseIdentifier)
//        annotationView!.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
//        
//        // Set the annotation view’s background color to a value determined by its longitude.
//        let hue = CGFloat(annotation.coordinate.longitude) / 100
//        annotationView!.backgroundColor = UIColor(hue: hue, saturation: 0.5, brightness: 1, alpha: 1)
//    }
//    
//    return annotationView
//}
//
//func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
//    return true
//}
//
//
//
//class MyAnnotationView: MGLAnnotationView {
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        
//        // Force the annotation view to maintain a constant size when the map is tilted.
//        scalesWithViewingDistance = false
//        
//        // Use CALayer’s corner radius to turn this view into a circle.
//        layer.cornerRadius = frame.width / 2
//        layer.borderWidth = 2
//        layer.borderColor = UIColor.cyan.cgColor
//    }


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

   
    @IBOutlet weak var sceneView: SKView!
    
    
    var myLocation: CLLocationCoordinate2D!
    
    var annotations: [MGLAnnotation] = []
    
    var targets: [UserTarget] = []
    
    @IBOutlet weak var radarMap: MGLMapView!
  
    
    @IBAction func goPlay(_ sender: Any) {
//        performSegue(withIdentifier: "toMain", sender: nil)
//        performSegue(withIdentifier: "toSceneKit", sender: nil)
        
//        if radarMap.alpha == 0 {
//            radarMap.alpha = 1
//        }
//        else {
//            radarMap.alpha = 0
//        }
// 
//        addOverlayBlips()
//        radarMap.alpha = radarMap.alpha == 0 ? 1 : 0
        sceneView.alpha = 1
        view.bringSubview(toFront: sceneView)
        var scene: FieldScene!
        
        sceneView.isMultipleTouchEnabled = false
        
        // Create and configure the scene.
        scene = FieldScene(size: sceneView.bounds.size)
        scene.addMapScene(map: radarMap)
//        scene.delegateMainVC = self
        scene.scaleMode = .aspectFill
        sceneView.presentScene(scene)
        
        for target in targets {
            
            let pt = radarMap.convert(target.annotation.coordinate, toPointTo: sceneView)
            let pt2 = sceneView.convert(pt, to: sceneView.scene!)
            let node = TargetSpriteNew(target: target)
            node.position = pt2
            scene.addChild(node)
         
        }
        
        
        
        
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
        
        
    }
    
//    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
//        
//        addOverlayBlips()
//        
//        
//    }
    
    
    
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
    
    
    func addOverlayBlips() {
        
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
    
    func addTargetBlips(target: UserTarget) {
//        annotations.append(target.annotation)
        targets.append(target)
        radarMap.addAnnotation(target.annotation)
        
//        let point = MGLPointAnnotation()
//        let point = MyAnnotationView()
        
//        point.coordinate = CLLocationCoordinate2D(latitude: target.lat, longitude: target.lon)
//  
//        radarMap.addAnnotation(point)
//        
//        annotations.append(point)
//        
//        let overlayPoint = radarMap.convert(point.coordinate, toPointTo: self.overlay)
//        let imageView = UIView()
////        let blip = Blip(point: overlayPoint, distance: 5.0, coordinates: point.coordinate)
//        
//        imageView.backgroundColor = UIColor.cyan
//    
//        imageView.frame.size.width = 20
//        imageView.frame.size.height = 20
//        imageView.layer.cornerRadius = 10
//        imageView.center = overlayPoint
//        overlay.addSubview(imageView)
        

    }
    
    
    
    func zoomMap() {
        
        var closestAnnotations: [MGLAnnotation] = []
        
        for i in 0...7 {
            closestAnnotations.append(Model.shared.userTargetsByDistance[i].annotation)
        }

        radarMap.showAnnotations(closestAnnotations, animated: true)
//        radarMap.removeAnnotations(annotations)
//        addOverlayBlips()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    
        sceneView.alpha = 0
        
        
        myLocation = CLLocationCoordinate2D(latitude: (Model.shared.myLocation?.coordinate.latitude)!, longitude: (Model.shared.myLocation?.coordinate.longitude)!)
        
        
        radarMap.delegate = self
        
        radarMap.isZoomEnabled = true
        
        radarMap.latitude = myLocation.latitude
        radarMap.longitude = myLocation.longitude
        radarMap.setZoomLevel(9 , animated: true)
        
        radarMap.camera.pitch = 180
        
        view.addSubview(radarMap)
//        view.bringSubview(toFront: overlay)

        let centerScreenPoint: CGPoint = radarMap.convert(radarMap.centerCoordinate, toPointTo: self.overlay)


        print("Screen center: \(centerScreenPoint) = \(radarMap.center)")
        
        let imageView = UIView()
        imageView.backgroundColor = UIColor.red

        imageView.frame.size.width = 20
        imageView.frame.size.height = 20
        imageView.layer.cornerRadius = 10
        imageView.center = centerScreenPoint
        overlay.addSubview(imageView)
        view.bringSubview(toFront: overlay)
        
        
        Model.shared.addBlipDelegate = self
        
        Model.shared.getTargetsNewVerComp2(myLocation: Model.shared.myLocation!) {
            print("done in closure")
     
            print(Model.shared.userTargets.count)
            
            self.zoomMap()
            
//            var farthest: Double = 0.0           
//            for target in Model.shared.userTargets {
//                if target.distance > farthest {
//                    farthest = target.distance
//                }
//            }
//            
//            print(farthest)
        

//            self.addOverlayBlips()
        }
    
//        Model.shared.getTargetsNewVerComp(myLocation: Model.shared.myLocation!) {
//            
//            print("done in closure")
//            var farthest: Double = 0.0
//            
//            for target in Model.shared.userTargets {
//                if target.distance > farthest {
//                    farthest = target.distance
//                }
//            }
//            
//            print(farthest)
//            
//        }
    
        
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
