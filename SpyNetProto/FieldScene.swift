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


class TargetSprite: SKSpriteNode {
    

    func applySize(position: CGPoint) -> CGFloat {
     
        let newX = position.x - (Model.shared.myScreenOrigin.x)
        let newY = position.y - (Model.shared.myScreenOrigin.y)
        
        let distance = sqrt((newX * newX) + (newY * newY))
        var adjustedDist = CGFloat(3000 / distance)
        
        if adjustedDist < 50 {
            adjustedDist = 50
        }
        if adjustedDist > 200 {
            adjustedDist = 200
        }
        
        let spriteSize = adjustedDist
        return spriteSize
        
    }
    
    
    
    
    func getPhysicsBody(position: CGPoint) -> SKPhysicsBody {
        let size = applySize(position: position)
        let body = SKPhysicsBody(circleOfRadius: size / 2.0)
      
        body.affectedByGravity = true
        body.isDynamic = true
        body.density = 0.25
        body.friction = 0.1
        body.restitution = 0.95
        body.allowsRotation = false
        body.angularVelocity = 0
        body.linearDamping = 1
        body.angularDamping = 1
//        body.categoryBitMask = mask
    
        return body
        
    }
    
    var target: Target?
    var anchorGrav: SKFieldNode?
    var mask: UInt32?
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(texture: SKTexture!, color: SKColor, size: CGSize) {
        self.target = nil
        super.init(texture: texture, color: color, size: size)
    }
    
   
    convenience init(target: Target, image: UIImage) {
    
            
            let roundedImage = image.circle
            let myTexture = SKTexture(image: roundedImage!)

            self.init(texture: myTexture, color: UIColor(), size: myTexture.size())
            self.target = target
            self.texture = myTexture
            self.position = target.origPos
            self.size = CGSize(width: 100, height: 100)
            self.name = target.user!.name
            let sizeFactor = applySize(position: target.origPos)
            self.zPosition = 1 * sizeFactor
            self.size = CGSize(width: sizeFactor, height: sizeFactor)
        let body = getPhysicsBody(position: target.origPos)
            self.physicsBody = body
            self.physicsBody!.affectedByGravity = true
            self.isUserInteractionEnabled = false
            self.physicsBody!.isDynamic = true
            self.physicsBody!.density = 0.25 * sizeFactor
            self.physicsBody!.friction = 0.1 * sizeFactor
            self.physicsBody!.restitution = 0.95
            self.physicsBody!.allowsRotation = false
            self.physicsBody!.angularVelocity = 0
            self.physicsBody!.linearDamping = 1
            self.physicsBody!.angularDamping = 1
        
        
        
        let gravMask = Model.shared.assignBitMask()
        
        self.anchorGrav = SKFieldNode.springField()
        self.anchorGrav?.position = target.origPos
        self.anchorGrav?.isEnabled = true
        self.anchorGrav?.strength = 1.0
        self.anchorGrav?.name = "anchor\(target.user?.name)"
        
        if let validMask = gravMask {
            print("\(validMask)..\(anchorGrav?.position)...VALIDMASK")
            physicsBody!.fieldBitMask = validMask
            anchorGrav?.categoryBitMask = validMask
            self.mask = validMask
            
        }
        


    
        }


    }



    






class Target {
    var sprite: SKSpriteNode?
    var user: User? // make this a UID...
    var scaleAdjust = CGFloat(15000)
    var lat: CLLocationDegrees
    var lon: CLLocationDegrees
    var origPos: CGPoint
//    var position: CGPoint {
//        let origin = Model.shared.myOrigin
//        let originLat = CGFloat(lat - (origin!.coordinate.latitude))
//        let originLon = CGFloat(lon - (origin!.coordinate.longitude))
//        let scaledX = originLat * scaleAdjust
//        let scaledY = originLon * scaleAdjust
//        //        print("\(scaledX)..\(scaledY).......InitialPosition******")
//        return CGPoint(x: scaledX, y: scaledY)
//        
//    }
    init(user: User, location: CLLocation) {
        self.user = user
        self.lat = (location.coordinate.latitude)
        self.lon = (location.coordinate.longitude)
        let origin = Model.shared.myOrigin
        let originLat = CGFloat(lat - (origin!.coordinate.latitude))
        let originLon = CGFloat(lon - (origin!.coordinate.longitude))
        let scaledX = originLat * scaleAdjust
        let scaledY = originLon * scaleAdjust
        self.origPos = CGPoint(x: scaledX, y: scaledY)
    }
    
    
    
    
//        let origin = Model.shared.myOrigin
//        let originLat = CGFloat(lat - (origin!.coordinate.latitude))
//        let originLon = CGFloat(lon - (origin!.coordinate.longitude))
//        let scaledX = originLat * scaleAdjust
//        let scaledY = originLon * scaleAdjust
////        print("\(scaledX)..\(scaledY).......InitialPosition******")
//        return CGPoint(x: scaledX, y: scaledY)
//        
//        
//    }
    
}







protocol AddTargetProtocol: class {
    
    func addTarget(target: Target)
    func addTargetSprites(target: Target)
}




class FieldScene: SKScene, AddTargetProtocol {
    
    let center = CGPoint(x: 0, y: 0)
    let circlePath = UIBezierPath(arcCenter: CGPoint(x: 0, y: 0), radius: 10, startAngle: 0, endAngle: CGFloat(M_PI_2), clockwise: true)
    let gravityCategory: UInt32 = 1 << 30
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
        
        
  // Create grav field
       
        //        gravField.position.x = size.width/2; // Center on X axis
        //        gravField.position.y = size.height/2; // Center on Y axis (Now at center of screen)
        gravField.position.x = 0
        gravField.position.y = 0
        gravField.isEnabled = true
        gravField.categoryBitMask = gravityCategory
        gravField.strength = 8.0

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
            
            Model.shared.myScreenOrigin = CGPoint(x: Model.shared.myScreenOrigin.x - translation.x, y: Model.shared.myScreenOrigin.y - translation.y)
            cam.position = Model.shared.myScreenOrigin
            gravField.position = Model.shared.myScreenOrigin
            print("\(Model.shared.myScreenOrigin)....ORIGIN")
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
        print(".......\n...\(Model.shared.myScreenOrigin).....")
        let newX = position.x - (Model.shared.myScreenOrigin.x)
        let newY = position.y - (Model.shared.myScreenOrigin.y)
        
        let distance = sqrt((newX * newX) + (newY * newY))
        var adjustedDist = CGFloat(3000 / distance)
        
        
        if adjustedDist < 50 {
            adjustedDist = 50
        }
        if adjustedDist > 200 {
            adjustedDist = 200
        }
        
//        if distance < 2 {
//            distance = 2
//        }
//        if distance > 20 {
//            distance = 20
//        }
        
        let spriteSize = adjustedDist
//        print("\(spriteSize)...\(distance).......ss")
        
//        let spriteSize = CGFloat(distance * 10)
        return spriteSize
        
    }
    
    
    
    func addTargetSprites(target: Target) {
        
        let profileImageURL = target.user!.avatar
        
        Model.shared.fetchImage(stringURL: profileImageURL) { image in
            
            guard let returnedImage = image else  {
                return
            }
            
            let sprite = TargetSprite(target: target, image: returnedImage)
            Model.shared.queryTargets.append(sprite)
            self.addChild(sprite)
            self.addChild(sprite.anchorGrav!)
        }
        
        
        
        
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
            
            sprite.position = target.origPos
            
            let sizeFactor = self.applySize(position: target.origPos)
          
            sprite.zPosition = 1 * sizeFactor
            sprite.size = CGSize(width: sizeFactor, height: sizeFactor)
            
            print("\(sprite.position)..\n.\(target.origPos).\n.\(sprite.size.width)...\n.\(target.lat).\(target.lon)...\n.")
            
            sprite.physicsBody = SKPhysicsBody(circleOfRadius: sprite.size.width / 2.0)
            sprite.physicsBody!.affectedByGravity = true
            sprite.physicsBody!.isDynamic = true
            sprite.physicsBody!.density = 0.25 * sizeFactor
            sprite.physicsBody!.friction = 0.1 * sizeFactor
            sprite.physicsBody!.restitution = 0.95
            sprite.physicsBody!.allowsRotation = false
            sprite.physicsBody!.angularVelocity = 0
            sprite.physicsBody!.linearDamping = 1
            sprite.physicsBody!.angularDamping = 1
            sprite.isUserInteractionEnabled = false

//            sprite.physicsBody!.charge = -0.1 * sizeFactor

//            print("\(sprite.position)......\(target.user!.name).....")
            
            
            let gravMask = Model.shared.assignBitMask()
            
            let anchorGrav = SKFieldNode.springField()
            anchorGrav.position = target.origPos
            anchorGrav.isEnabled = true
            anchorGrav.strength = 1.0
            anchorGrav.name = "anchor\(target.user?.name)"
            
            if let validMask = gravMask {
                print("\(validMask)..\(anchorGrav.position)...VALIDMASK")
                sprite.physicsBody!.fieldBitMask = validMask | self.gravityCategory
                anchorGrav.categoryBitMask = validMask
            }
            
            sprite.name = target.user!.name
            target.sprite = sprite
            
            self.addChild(anchorGrav)
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
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        
//        for touch in touches {
//            
//            let positionInScene = touch.location(in: self)
//            let touchedNode = self.atPoint(positionInScene)
//            
//            if let name = touchedNode.name
//            {
//                print(name)
//                
//            }
//            
//        }
//    
//
//    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if let positionInScene = touch?.location(in: self) {
            let nodeAtPoint = atPoint(positionInScene)
            print(nodeAtPoint.name ?? "no name")
        }
    
    
    }
    
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {



       
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    
    
    func updateSpotSizes() {
        
        
        
        for targetSprite in Model.shared.queryTargets {
            
//            print("\(target.sprite!.position)..\n \(target.origPos)...\(target.sprite!.size.width)\n POS in UPDATESPOTSIZES")
            
            let sizeFactor = applySize(position: (targetSprite.target?.origPos)!)
            
            targetSprite.size = CGSize(width: sizeFactor, height: sizeFactor)
            
            targetSprite.physicsBody = targetSprite.getPhysicsBody(position: (targetSprite.target?.origPos)!)
//
            targetSprite.physicsBody!.fieldBitMask = targetSprite.mask! | gravityCategory
            print("\(targetSprite.mask)...MASK")
//            targetSprite.zPosition = 1 * sizeFactor
        }
        
    }
    
    
    override func update(_ currentTime: TimeInterval) {
    
//        updateSpotSizes()
        cam.position = Model.shared.myScreenOrigin
        gravField.position = Model.shared.myScreenOrigin
 
        
       
    }
}

