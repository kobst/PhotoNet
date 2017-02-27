//
//  FieldSceneVer2.swift
//  SpyNetProto
//
//  Created by Edward Han on 2/21/17.
//  Copyright © 2017 Edward Han. All rights reserved.
//
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




protocol AddTargetProtocol: class {
    
    //    func addTarget(target: Target)
    func addTargetSprites(target: Target)
}



class FieldScene: SKScene, AddTargetProtocol {
    
    weak var delegateMainVC: GoToDetail?
    let center = CGPoint(x: 0, y: 0)
    let circlePath = UIBezierPath(arcCenter: CGPoint(x: 0, y: 0), radius: 10, startAngle: 0, endAngle: CGFloat(M_PI_2), clockwise: true)
    
    let gravityCategory: UInt32 = 1 << 30
    var cam: SKCameraNode!
    let gravField = SKFieldNode.springField()
    let background = SKSpriteNode(imageNamed: "horizonSpace")
    var profileNode: SKSpriteNode!
    
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder) is not used in this app")
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        
        
        Model.shared.addTargetDelegate = self
//        Modelv2.shared.addTweetDelegate = self
        Modelv2.shared.addTargetDelegate = self
        
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        
        background.size.width = size.width * 10
        background.size.height = size.height * 10
        addChild(background)
        
        //        let swipe = UIPanGestureRecognizer(target: self, action: Selector(("moveCenter")))
        //        self.addGestureRecognizer(swipe)
        self.isUserInteractionEnabled = true
        
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        
        
    }
    

    
    func addTargetSprites(target: Target) {
        
        let profileImageURL = target.user == nil ? target.tweet?.idImageURL : target.user?.avatar
        
        Model.shared.fetchImage(stringURL: profileImageURL!) { image in
            
            guard let returnedImage = image else  {
                return
            }
            
            target.profileImage = returnedImage
//            Model.shared.sceneTargets.append(target)

            let sprite = TargetSprite(target: target, image: returnedImage)
            print("\(sprite.target?.origPos)..-..\(sprite.position)")
            Model.shared.targetSprites.append(sprite)
            
            if sprite.distance < 125 {
//                self.addChild(sprite)
                
                self.background.addChild(sprite)
                
                if let validMask = Model.shared.assignBitMask2()  {
                    sprite.anchorGrav.categoryBitMask = validMask
                    sprite.physicsBody?.fieldBitMask = validMask
                    sprite.mask = validMask
                }
                
            }
            
            
            
        }
        
    }
    
    
    

    func makeProfileNode() -> SKSpriteNode {
        
        let profileImage = UIImage(named: "plus")?.circle
        let profileTexture = SKTexture(image: profileImage!)
        let profileNode = SKSpriteNode(texture: profileTexture)
        profileNode.size.width = 50
        profileNode.size.height = 50
        profileNode.name = "profileButtonXOXO"
        return profileNode
        
        
    }
    
    
    override func didMove(to view: SKView) {
        
        
        cam = SKCameraNode() //initialize and assign an instance of SKCameraNode to the cam variable.
        cam.setScale(1.0)  //the scale sets the zoom level of the camera on the given position
        
        self.camera = cam //set the scene's camera to reference cam
        self.addChild(cam) //make the cam a childElement of the scene itself.
        
        //position the camera on the gamescene.
        cam.position = CGPoint(x: 0, y: 0)
        Model.shared.myScreenOrigin = CGPoint(x: 0, y: 0)
        
        profileNode = makeProfileNode()
        profileNode.position = CGPoint(x: Model.shared.myScreenOrigin.x, y: Model.shared.myScreenOrigin.y - 200)
        self.addChild(profileNode)
        
        
        //        gravField.position = Model.shared.myScreenOrigin
        //        gravField.isEnabled = true
        //        gravField.categoryBitMask = gravityCategory
        //        gravField.strength = 1.0
        //        self.addChild(gravField)
        
        
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
        let touch = touches.first
        if let positionInScene = touch?.location(in: self) {
            
            
            let nodeAtPoint = atPoint(positionInScene)
            print(nodeAtPoint.name ?? "no name")

            if nodeAtPoint.name != nil {
                if nodeAtPoint.name == "profileButtonXOXO" {
                    print("profiel seleceted \n \n profile selected \n ")
                    delegateMainVC?.goToProfile()
                    
                }
                    
            
                else {
                    
                    let targetSprite = nodeAtPoint as! TargetSprite
                    //                    print("\(targetSprite.target?.user?.name)...\(target.mask)....")
                    print("\(targetSprite.position)...")
                    print("\(targetSprite.target?.lat)...\(targetSprite.target?.lon)")
                    
                    if let _ = targetSprite.target?.tweet {
                        delegateMainVC?.goToTweet(targetSprite: targetSprite)
                        
                    }
                    else {
                        delegateMainVC?.goToDetail(targetSprite: targetSprite)
                    }
                    
                    
                }
                
                
            }
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
    
    
    
    func updateTargetSprByDistance() {

//        for i in 0...index {
//            if parent == nil {
//                 self.addChild(Model.shared.targetSprByDistance[i])
//                
//            }
        
            let maxSpritesViewable = Model.shared.targetSprByDistance.count > 7 ? 7 : Model.shared.targetSprByDistance.count
            var count = 0
        
            for targetSprite in Model.shared.targetSprByDistance {
                if count < maxSpritesViewable {
                    if targetSprite.parent == nil {
//                        self.addChild(targetSprite)
                        self.background.addChild(targetSprite)
                        if let validMask = Model.shared.assignBitMask2()  {
                            targetSprite.anchorGrav.categoryBitMask = validMask
                            targetSprite.physicsBody?.fieldBitMask = validMask
                            targetSprite.mask = validMask
                            //                            print(Model.shared.bitMaskOccupied)
                            print(targetSprite.name ?? "no name add")
                        }
                    }
                    
                    targetSprite.applySize()
                    targetSprite.changePhysicsBody()
                    
                }
                else {
                    if targetSprite.parent != nil {
                        targetSprite.removeFromParent()
                        Model.shared.removeBitMask2(mask: targetSprite.mask!)
                        print(targetSprite.name ?? "no name")
                        
                    }
                    
                }
                
                count += 1
        }
    
        var i = 0
        for targetSprite in Model.shared.targetSprByDistance {
            if targetSprite.parent == self {
                print(i)
            }
            i += 1
        }
        
    }
    
    
    func updateTargetSpritesVer2() {
        for targetSprite in Model.shared.targetSprites {
            
            if targetSprite.distance < 125 && targetSprite.parent == nil {
                self.addChild(targetSprite)
                
                if let validMask = Model.shared.assignBitMask2()  {
                            targetSprite.anchorGrav.categoryBitMask = validMask
                            targetSprite.physicsBody?.fieldBitMask = validMask
                            targetSprite.mask = validMask
//                            print(Model.shared.bitMaskOccupied)
                    
                        }
    
            }
            
            if targetSprite.distance > 150 && targetSprite.parent == self {
//                targetSprite.anchorGrav.categoryBitMask = 
//                targetSprite.physicsBody?.fieldBitMask = nil
                print("\n removing \(targetSprite.name) \n ")
//                if let validMask = targetSprite.mask {
                    Model.shared.removeBitMask2(mask: targetSprite.mask!)
                    targetSprite.removeFromParent()
//                    print(Model.shared.bitMaskOccupied)
//                }
                
            }
            
//            if targetSprite.parent != nil {
//                targetSprite.applySize()
//                targetSprite.changePhysicsBody()
//                print("\n \(targetSprite.target!.lat)..\n \(targetSprite.target!.lon)")
//                print("\(targetSprite.target!.origPos)...\(targetSprite.name)....\n")
//            }
            
            
        }
    }
    

    
    func handlePanFrom(recognizer: UIPanGestureRecognizer) {
        if recognizer.state == .began {
            var touchLocation = recognizer.location(in: recognizer.view)
            touchLocation = self.convertPoint(fromView: touchLocation)
            
            //            self.selectNodeForTouch(touchLocation)
            
        } else if recognizer.state == .changed {
            var translation = recognizer.translation(in: recognizer.view!)
            translation = CGPoint(x: translation.x, y: -translation.y)
//            print("in handle pan changed.....\(translation)")
    
            Model.shared.myScreenOrigin = CGPoint(x: Model.shared.myScreenOrigin.x - translation.x, y: Model.shared.myScreenOrigin.y - translation.y)
            cam.position = Model.shared.myScreenOrigin
            gravField.position = Model.shared.myScreenOrigin
            
            profileNode.position = CGPoint(x: Model.shared.myScreenOrigin.x, y: Model.shared.myScreenOrigin.y - 200)
            
//            print("\(Model.shared.myScreenOrigin)....ORIGIN")
            
            
            //            updateSpotSizes()
            //            updateTargetSizes()
//            updateTargetSpritesVer2()
            updateTargetSprByDistance()
            

            
            recognizer.setTranslation(CGPoint(x: 0, y:0), in: recognizer.view)
            
            //            self.panForTranslation(translation)
            //            recognizer.setTranslation(CGPointZero, in: recognizer.view)
            
        }

    }
    
    
    
    
    
    override func update(_ currentTime: TimeInterval) {
        
        //        updateSpotSizes()
        cam.position = Model.shared.myScreenOrigin
        gravField.position = Model.shared.myScreenOrigin
        
        if let heading = Model.shared.myHeading {
           background.zRotation = CGFloat(M_PI * 2) * CGFloat(heading/360)
        }
       
    }
}



