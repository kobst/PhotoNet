//
//  TestScene.swift
//  SpyNetProto
//
//  Created by Edward Han on 1/26/17.
//  Copyright © 2017 Edward Han. All rights reserved.
//

//
//  GameScene.swift
//  SpyTestCircls
//
//  Created by Edward Han on 1/25/17.
//  Copyright © 2017 Edward Han. All rights reserved.
//

import SpriteKit
import GameplayKit
import QuartzCore
import Firebase
import CoreLocation


extension UIImage {
    var rounded: UIImage? {
        let imageView = UIImageView(image: self)
        imageView.layer.cornerRadius = min(size.height/4, size.width/4)
        imageView.layer.masksToBounds = true
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
    var circle: UIImage? {
        let square = CGSize(width: min(size.width, size.height), height: min(size.width, size.height))
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: square))
        imageView.contentMode = .scaleAspectFill
        imageView.image = self
        imageView.layer.cornerRadius = square.width/2
        imageView.layer.masksToBounds = true
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
}



func maskRoundedImage(image: UIImage, radius: Float) -> UIImage {
    let imageView: UIImageView = UIImageView(image: image)
    var layer: CALayer = CALayer()
    layer = imageView.layer
    
    layer.masksToBounds = true
    layer.cornerRadius = CGFloat(radius)
    
    UIGraphicsBeginImageContext(imageView.bounds.size)
    layer.render(in: UIGraphicsGetCurrentContext()!)
    let roundedImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return roundedImage!
}



class User {
    
    
    var uid: String
    var name: String
    var avatar: String
    var blurb: String
    var timeStamp: Double
    
    init(uid: String) {
        self.uid = uid
        name = ""
        avatar = ""
        blurb = ""
        timeStamp = 0.0
    }
    
    init(snapshot: FIRDataSnapshot) {
        let value = snapshot.value as! [String: Any]!
        uid = snapshot.key
        avatar = value?["avatar"] as? String ?? ""
        blurb = value?["blurb"] as? String ?? ""
        name = value?["name"] as? String ?? ""
        timeStamp = value?["timeStamp"] as? Double ?? 0.0
        
    }
    
}


class Target {
    var sprite: SKSpriteNode?
    var user: User?
    var scaleAdjust = CGFloat(10000)
    var lat: CLLocationDegrees
    var lon: CLLocationDegrees
    init(user: User, location: CLLocation) {
        self.user = user
        self.lat = (location.coordinate.latitude)
        self.lon = (location.coordinate.longitude)
    }
    
    
    func givePosition() -> CGPoint {
        let origin = Model.shared.myOrigin
        let originLat = CGFloat(lat - (origin!.coordinate.latitude))
        let originLon = CGFloat(lon - (origin!.coordinate.longitude))
        let scaledX = originLat * scaleAdjust
        let scaledY = originLon * scaleAdjust
        return CGPoint(x: scaledX, y: scaledY)
        
        
    }
    
}







protocol AddTargetProtocol: class {
    
    func addTarget(target: Target)
}




class FieldScene: SKScene, AddTargetProtocol {
    
    let center = CGPoint(x: 0, y: 0)
    let circlePath = UIBezierPath(arcCenter: CGPoint(x: 0, y: 0), radius: 10, startAngle: 0, endAngle: CGFloat(M_PI_2), clockwise: true)
    let gravityCategory: UInt32 = 0x1 << 0
    var cam: SKCameraNode!
    let gravField = SKFieldNode.springField()
    let background = SKSpriteNode(imageNamed: "horizonSpace")
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder) is not used in this app")
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        
        
        Model.shared.addTargetDelegate = self
        
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        
        background.size.width = size.width * 10
        background.size.height = size.height * 10
        addChild(background)
        
//        let swipe = UIPanGestureRecognizer(target: self, action: Selector(("moveCenter")))
//        self.addGestureRecognizer(swipe)
        self.isUserInteractionEnabled = true
        
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        
        
        //        let gravField = SKFieldNode.radialGravityField() // Create grav field
       
        //        gravField.position.x = size.width/2; // Center on X axis
        //        gravField.position.y = size.height/2; // Center on Y axis (Now at center of screen)
        gravField.position.x = 0
        gravField.position.y = 0
        gravField.isEnabled = true
        gravField.categoryBitMask = gravityCategory
        gravField.strength = 10.0
        
        
//        addChild(gravField);
        
//        let gravNode = SKSpriteNode(imageNamed: "Spaceship")
//        gravNode.position.x = 0
//        gravNode.position.y = 0
//        gravNode.size = CGSize(width: 10, height: 10)
//        
//        addChild(gravNode)
        
        
        
    }
    
    

    
//    func moveCenter(_ sender: UIPanGestureRecognizer) {
//
//        var point = sender.translation(in: view)
//        print("\(point).....translation..")
//        
//    }
    
    
    
    func handlePanFrom(recognizer: UIPanGestureRecognizer) {
        if recognizer.state == .began {
            var touchLocation = recognizer.location(in: recognizer.view)
            touchLocation = self.convertPoint(fromView: touchLocation)
            
//            self.selectNodeForTouch(touchLocation)
            
        } else if recognizer.state == .changed {
            var translation = recognizer.translation(in: recognizer.view!)
            translation = CGPoint(x: translation.x, y: -translation.y)
            print("in handle pan changed.....\(translation)")
          
//            let x = translation.x * -1.0
//            let y = translation.y * -1.0
            
            Model.shared.myScreenOrigin = CGPoint(x: cam.position.x - translation.x, y: cam.position.y - translation.y)
            print(cam.position)
            updateSpotSizes()
            
            recognizer.setTranslation(CGPoint(x: 0, y:0), in: recognizer.view)
            
//            self.panForTranslation(translation)
//            recognizer.setTranslation(CGPointZero, in: recognizer.view)
            
        }
//        else if recognizer.state == .ended {
//            var translation = recognizer.translation(in: recognizer.view!)
//            translation = CGPoint(x: translation.x, y: -translation.y)
//            print("in handle pan.....\(translation)")
//
//        }
    }
    
    
    
    
    
    func applySize(position: CGPoint) -> CGFloat {
        let newX = position.x - (Model.shared.myScreenOrigin.x)
        let newY = position.y - (Model.shared.myScreenOrigin.y)
        
        var distance = sqrt((newX * newX) + (newY * newY))

        if distance < 50 {
            distance = 50
        }
        if distance > 300 {
            distance = 300
        }
        
        let spriteSize = CGFloat(10000 / distance)
        return spriteSize
        
    }
    
    

    
    func addTarget(target: Target) {
        let profileImageURL = target.user!.avatar
        //        let sizeFactor = spot.spotData.time * 10
        //        let roundedImage = maskRoundedImage(image: UIImage(named: profileImage)!, radius: Float(sizeFactor))
        
        Model.shared.fetchImage(stringURL: profileImageURL) { image in
            
            guard let returnedImage = image else  {
                return
            }
            
            let roundedImage = returnedImage.circle
            let texture = SKTexture(image: roundedImage!)
            let sprite  = SKSpriteNode(texture: texture)
            
//            let sizeFactor = self.applySize(position: target.position)
//            sprite.position = target.position
//            
            
            sprite.position = target.givePosition()
            let sizeFactor = self.applySize(position: sprite.position)
            print("\(sizeFactor).....sizeFactor")
            sprite.zPosition = 10
            sprite.size = CGSize(width: sizeFactor, height: sizeFactor)
            sprite.physicsBody = SKPhysicsBody(circleOfRadius: sprite.size.width / 2.0)
            sprite.physicsBody?.affectedByGravity = false
            sprite.physicsBody?.isDynamic = true
            sprite.physicsBody?.density = 0.1 * sizeFactor
            sprite.physicsBody?.friction = 0.1 * sizeFactor
            sprite.physicsBody?.restitution = 0.95
            sprite.physicsBody?.allowsRotation = false
            sprite.physicsBody?.linearDamping = 1
            sprite.physicsBody?.angularDamping = 1
            sprite.physicsBody?.fieldBitMask = self.gravityCategory
            target.sprite = sprite
            print("\(sprite.position)......\(target.user!.name).....")
            self.addChild(sprite)
           
            
        }
    }
    
    
    
    override func didMove(to view: SKView) {
        
        
        cam = SKCameraNode() //initialize and assign an instance of SKCameraNode to the cam variable.
        cam.setScale(1.0)  //the scale sets the zoom level of the camera on the given position
        
        self.camera = cam //set the scene's camera to reference cam
        self.addChild(cam) //make the cam a childElement of the scene itself.
        
        //position the camera on the gamescene.
        cam.position = CGPoint(x: 0, y: 0)
        Model.shared.myScreenOrigin = CGPoint(x: 0, y: 0)
        
        
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanFrom))
        self.view!.addGestureRecognizer(gestureRecognizer)
        
        
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
 
        
        
    }
    
    func touchMoved(toPoint pos : CGPoint) {

        
    }
    
    func touchUp(atPoint pos : CGPoint) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let initial = touches.first?.location(in: self)
        print("\(initial)....")
        
//        for touch in touches {
//            let location = touch.location(in: self)
//            print(location)
//        }
        

       
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    
    
    func updateSpotSizes() {
        
        
        
        for target in Model.shared.queryTargets {
            
            let sizeFactor = applySize(position: (target.sprite?.position)!)
            
            target.sprite?.size = CGSize(width: sizeFactor, height: sizeFactor)
            
            target.sprite?.physicsBody = SKPhysicsBody(circleOfRadius: sizeFactor / 2)
        }
        
    }
    
    
    override func update(_ currentTime: TimeInterval) {
    
//        updateSpotSizes()
        cam.position = Model.shared.myScreenOrigin
        gravField.position = Model.shared.myScreenOrigin
        
       
    }
}

