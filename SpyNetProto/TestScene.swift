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




class Spot {
    
    var sprite: SKNode?
    var spotData: TargetData
    
    init(spotData: TargetData) {
        
        self.spotData = spotData
        
        
    }
    
    
    
    class TargetData {
        
        
        var time: Double
        var profileURL: String
        var secondPro: String
        var descr: String
        var name: String
        
        
        
        init(time: Double, profile: String, secondPro: String, descr: String, name: String) {
            self.profileURL = profile
            self.secondPro = secondPro
            self.descr = descr
            self.name = name
            self.time = time
        }
        
    }
    
    
}





class FieldScene: SKScene {
    
    let center = CGPoint(x: 0, y: 0)
    let circlePath = UIBezierPath(arcCenter: CGPoint(x: 0, y: 0), radius: 10, startAngle: 0, endAngle: CGFloat(M_PI_2), clockwise: true)
    let gravityCategory: UInt32 = 0x1 << 0
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder) is not used in this app")
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        let background = SKSpriteNode(imageNamed: "horizonSpace")
        background.size = size
        addChild(background)
        
        
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        
        
        //        let gravField = SKFieldNode.radialGravityField() // Create grav field
        let gravField = SKFieldNode.springField()
        //        gravField.position.x = size.width/2; // Center on X axis
        //        gravField.position.y = size.height/2; // Center on Y axis (Now at center of screen)
        gravField.position.x = 0
        gravField.position.y = 0
        gravField.isEnabled = true
        gravField.categoryBitMask = gravityCategory
        gravField.strength = 0.25
        
        addChild(gravField);
        
        let gravNode = SKSpriteNode(imageNamed: "Spaceship")
        gravNode.position.x = 0
        gravNode.position.y = 0
        gravNode.size = CGSize(width: 10, height: 10)
        
        addChild(gravNode)
        
        
        
        let testData = Spot.TargetData(time: 2, profile: "beckett", secondPro: "beckett", descr: "writer", name: "sb")
        let testSpot = Spot(spotData: testData)
        let point = CGPoint(x: 0, y: 80)
        
        let testData2 = Spot.TargetData(time: 5, profile: "karina", secondPro: "karina", descr: "beautiful", name: "ak")
        let testSpot2 = Spot(spotData: testData2)
        let point2 = CGPoint(x: 100, y: 100)
        
        let testData3 = Spot.TargetData(time: 7, profile: "einstein", secondPro: "einstein", descr: "genius", name: "ae")
        let testSpot3 = Spot(spotData: testData3)
        let point3 = CGPoint(x: -100, y: 0)
        
        let testData4 = Spot.TargetData(time: 10, profile: "nietzsche", secondPro: "nietzsche", descr: "genius", name: "fn")
        let testSpot4 = Spot(spotData: testData4)
        let point4 = CGPoint(x: -100, y: -170)
        
        addSpot(spot: testSpot, position: point)
        addSpot(spot: testSpot2, position: point2)
        addSpot(spot: testSpot3, position: point3)
        addSpot(spot: testSpot4, position: point4)
        
        
    }
    
    
    
    
    func addSpot(spot: Spot, position: CGPoint) {
        let profileImage = spot.spotData.profileURL
        let sizeFactor = spot.spotData.time * 10
        //        let roundedImage = maskRoundedImage(image: UIImage(named: profileImage)!, radius: Float(sizeFactor))
        
        let roundedImage = UIImage(named: profileImage)!.circle
        //        let sprite = SKSpriteNode(imageNamed: profileImage)
        
        let texture = SKTexture(image: roundedImage!)
        let sprite  = SKSpriteNode(texture: texture)
        //        sprite.size = CGSize(width: 0.1, height: 0.1)
        sprite.position = position
        sprite.zPosition = 10
        sprite.size = CGSize(width: sizeFactor, height: sizeFactor)
        sprite.physicsBody = SKPhysicsBody(circleOfRadius: sprite.size.width / 2)
        sprite.physicsBody?.affectedByGravity = true
        sprite.physicsBody?.isDynamic = true
        sprite.physicsBody?.density = 0.01
        sprite.physicsBody?.friction = 100.01
        sprite.physicsBody?.restitution = 0.05
        sprite.physicsBody?.fieldBitMask = gravityCategory
        self.addChild(sprite)
        spot.sprite = sprite
        
    }
    
    
    
    
    
    override func didMove(to view: SKView) {
        
        // Get label node from scene and store it for use later
        //        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
        //        if let label = self.label {
        //            label.alpha = 0.0
        //            label.run(SKAction.fadeIn(withDuration: 2.0))
        //
        // Create shape node to use during mouse interaction
        //        let w = (self.size.width + self.size.height) * 0.05
        //        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
        //
        //        if let spinnyNode = self.spinnyNode {
        //            spinnyNode.lineWidth = 2.5
        //
        //            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(M_PI), duration: 1)))
        //            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
        //                                              SKAction.fadeOut(withDuration: 0.5),
        //                                              SKAction.removeFromParent()]))
        //        }
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        //        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
        //            n.position = pos
        //            n.strokeColor = SKColor.green
        //            self.addChild(n)
        //        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        
    }
    
    func touchUp(atPoint pos : CGPoint) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}

