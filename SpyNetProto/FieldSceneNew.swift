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
//import MapKit
import Mapbox

protocol AddTargetProtocol: class {
    
    //    func addTarget(target: Target)
    //    func addTargetSprites(target: Target)
    func addTargetSpritesNew(target: TargetNew)
    
}



class FieldScene: SKScene {
    
    weak var delegateMainVC: GoToDetail?
    weak var delegateSceneKit: MoveSceneTargets?
    let center = CGPoint(x: 0, y: 0)
    let circlePath = UIBezierPath(arcCenter: CGPoint(x: 0, y: 0), radius: 10, startAngle: 0, endAngle: CGFloat(M_PI_2), clockwise: true)
    

    var cam: SKCameraNode!
 
    //    let background = SKSpriteNode(imageNamed: "horizonSpace")
    let background = SKSpriteNode()
    
    
    var centerNode = SKSpriteNode()
    var mapNode: SK3DNode!
    var profileNode = ProfileNode()   // should profileNode be a struct
 
    
    var targetSpritesByDistance: [TargetSpriteNew] {
        return Model.shared.targetSpriteNew.sorted(by: {$0.distance < $1.distance})
        
    }
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder) is not used in this app")
    }
 
    

    
    init(size: CGSize, map: MGLMapView) {
    
        mapNode = SK3DNode(viewportSize: CGSize(width: 900, height: 900) )
        mapNode.position = CGPoint(x: 0, y: -100)

        super.init(size: size)
        

        
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        
        background.size.width = size.width * 10
        background.size.height = size.height * 10
        background.name = "background"
        background.position = CGPoint(x: 0, y: 100)
        addChild(background)
        
        
        centerNode.size.width = 15
        centerNode.size.height = 15
        centerNode.color = UIColor.red
        background.position = CGPoint(x: 0, y: 0)
        addChild(centerNode)
        
//        addMapScene(map: map)
        let scn = GameScene(create: true, map: map)
        mapNode = SK3DNode(viewportSize: CGSize(width: 1150, height: 750) )
        mapNode.position = CGPoint(x: 0, y: -100)
        mapNode.scnScene = scn
        self.addChild(mapNode)

        self.isUserInteractionEnabled = true
        
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        
//        self.addChild(mapNode)
        
    }
    
    
    func addMapScene(map: MGLMapView) {
        let scn = GameScene(create: true, map: map)
        let node = SK3DNode(viewportSize: CGSize(width: 1150, height: 750) )
        node.position = CGPoint(x: 0, y: -100)
        node.scnScene = scn
        self.addChild(node)
      
        
        
    }
    
    
    func returnToCenter() {
        
        cam.position = CGPoint(x: 0, y: 0)
        centerNode.position = CGPoint(x: 0, y: 0)
        
    }
    
//    func addTargetSpritesNew(target: TargetNew) {
//        
//        let sprite = TargetSpriteNew(target: target, pos: CGPoint(x: 0, y: 0))
//        
//        Model.shared.targetSpriteNew.append(sprite)
//        
//        
//        Model.shared.fetchImage(stringURL: sprite.profileImageURL) { returnedImage in
//            guard let validImage = returnedImage else {
//                return
//            }
//            let roundedImage = validImage.circle
//            let myTexture = SKTexture(image: roundedImage!)
//            sprite.texture = myTexture
//        }
//        
//        if sprite.distance < 75 {
//            self.background.addChild(sprite)
//            print(sprite.nameLabel.text ?? "mmmmmmmmm")
//            if let validMask = Model.shared.assignBitMask2()  {
//                sprite.anchorGrav.categoryBitMask = validMask
//                sprite.physicsBody?.fieldBitMask = validMask
//                sprite.mask = validMask
//                sprite.animateSize()
//                //                sprite.applySize()
//                sprite.changePhysicsBody()
//            }
//        }
//        
//    }
//    

    

    class ProfileNode: SKSpriteNode {
        init() {
            let profileImage = UIImage(named: "plus")?.circle
            let profileTexture = SKTexture(image: profileImage!)
            let size = CGSize(width: 50, height: 50)
            super.init(texture: profileTexture, color: UIColor(), size: size)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
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
        centerNode.position = CGPoint(x: 0, y: 0)
//        centerNode.position = CGPoint(x: 0, y: 0)
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
        let touch = touches.first
        if let positionInScene = touch?.location(in: self) {
            
            let nodeAtPoint = atPoint(positionInScene)
            print(nodeAtPoint.name ?? "no name X")
            
            
            switch nodeAtPoint {
                
      
            case is TargetSpriteNew:
                let targetSpriteNew = nodeAtPoint as! TargetSpriteNew
                delegateMainVC?.goToUserTarget(target: targetSpriteNew)
                

                
            default:
                return
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
    
    
    
    func updateTargetSpriteNewVersion() {

        let array2 = targetSpritesByDistance

        
        
        for targetSprite in array2 {
            

                targetSprite.applySize()
                
                targetSprite.changePhysicsBody()
                
                print("\(targetSprite.size.width)---\(targetSprite.distance)")
            

                
            }
        
            
        
    }

    
    
    
    
    
    // when you already have a set of sprites that are near enough each other.
    // if (max rad * 2) > distance btw sprites then in group.
    // or max rad * 4 > distance bc both sprites can be pushed to one rad length from another right next to it in the same vector. pushedRadLengthSprite2 + radLengthSprite2 + radLengthSprite1 + pushedradLengthSprite1
    
    
    
//    func seperateSprites(sprites: [TargetSpriteNew]) {
//        
//        for sprite in sprites {
//            var totalVector = CGPoint(x: 0, y: 0)
//            
//            for sprite2 in sprites {
//                
//                let deltaX = sprite.position.x - sprite2.position.x
//                let deltaY = sprite.position.y - sprite2.position.y
//                let vector = CGPoint(x: deltaX, y: deltaY)
//                
//                
//
//                
//            }
//        }
//        
//        
//    }


    
    func handlePanFrom(recognizer: UIPanGestureRecognizer) {
        
        
        if recognizer.state == .began {
            var touchLocation = recognizer.location(in: recognizer.view)
            touchLocation = self.convertPoint(fromView: touchLocation)
            
            //            self.selectNodeForTouch(touchLocation)
            
        }
            
        else if recognizer.state == .changed {
            var translation = recognizer.translation(in: recognizer.view!)
            translation = CGPoint(x: translation.x, y: -translation.y)
            //            print("in handle pan changed.....\(translation)")
            
            
            
            Model.shared.moveScnTargets(translation: translation)
            
            Model.shared.myScreenOrigin = CGPoint(x: Model.shared.myScreenOrigin.x - translation.x, y: Model.shared.myScreenOrigin.y - translation.y)
            cam.position = Model.shared.myScreenOrigin
            //            gravField.position = Model.shared.myScreenOrigin
            
            
//            
            mapNode.position = CGPoint(x: Model.shared.myScreenOrigin.x, y: Model.shared.myScreenOrigin.y - 100)
//
            
//            let scene = mapNode.scnScene as! GameScene
//            mapNode.pointOfView = scene.cameraNode
            
//            profileNode.position = CGPoint(x: Model.shared.myScreenOrigin.x, y: Model.shared.myScreenOrigin.y - 200)
            
            
            centerNode.position = Model.shared.myScreenOrigin
         
        
            updateTargetSpriteNewVersion()
            //            fade()
            recognizer.setTranslation(CGPoint(x: 0, y:0), in: recognizer.view)
            
            
            
        }
        
    }
    
    
    
    
    
    
    
    override func update(_ currentTime: TimeInterval) {
        cam.position = Model.shared.myScreenOrigin
        
        if let heading = Model.shared.myHeading {
            background.zRotation = CGFloat(M_PI * 2) * CGFloat(heading/360)
            for targetSprite in Model.shared.targetSpriteNew {
                targetSprite.zRotation = -1 * background.zRotation
            }
        }
        
    }
    
}



