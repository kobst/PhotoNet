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
//    func addTargetSprites(target: Target)
    func addTargetSpritesNew(target: TargetNew)
    
}



class FieldScene: SKScene, AddTargetProtocol {
    
    weak var delegateMainVC: GoToDetail?
    let center = CGPoint(x: 0, y: 0)
    let circlePath = UIBezierPath(arcCenter: CGPoint(x: 0, y: 0), radius: 10, startAngle: 0, endAngle: CGFloat(M_PI_2), clockwise: true)
    
    let gravityCategory: UInt32 = 1 << 30
    var cam: SKCameraNode!
    let gravField = SKFieldNode.springField()
    let background = SKSpriteNode(imageNamed: "horizonSpace")
    var profileNode = ProfileNode()   // should profileNode be a struct
    var catsOpen: Bool  // switch this to a class method for profileNode class...
    
//    var categoryNodes = [ButtonCategoryNode]()
//    let allCategories: [TargetSpriteNew.Category]
   
    var allCategoryNodes: [ButtonCategoryNode] = []
    
//    {
//        let radius = CGFloat(50)
//        var i = 0
//        var categoryNodes = [ButtonCategoryNode]()
//        for cat in allCategories {
//            let buttonNode = ButtonCategoryNode(categoryInit: cat)
//            
//            let angle = 2 * M_PI / Double(categories.count) * Double(i)
//            let coinX = radius * cos(CGFloat(angle))
//            let coinY = radius * sin(CGFloat(angle))
//            buttonNode.position = CGPoint(x:coinX + profileNode.position.x, y:coinY + profileNode.position.y)
//            categoryNodes.append(buttonNode)
//            i += 1
//        }
//        return categoryNodes
//        
//    }
    
    
    
    
    
    
    var categories: [TargetSpriteNew.Category]
    
    var targetSpritesByDistance: [TargetSpriteNew] {
        return Model.shared.targetSpriteNew.sorted(by: {$0.distance < $1.distance})
        
    }
    
    var filteredTargetSprites: [TargetSpriteNew] {
        
        var filteredOut = [TargetSpriteNew]()
//        for category in categories {
//                    let validCatSprites = targetSpritesByDistance.filter({ $0.category == category })
//                    filteredOut = filteredOut + validCatSprites
//                }
        
        let sortedTargets = targetSpritesByDistance
        for sprite in sortedTargets {
            
            if categories.contains(sprite.category!) {
                filteredOut.append(sprite)
            }
        }
        
    
        return filteredOut
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder) is not used in this app")
    }
    
    override init(size: CGSize) {
        
        self.categories = Model.shared.allCategories
        
        for cat in Model.shared.allCategories {
            let buttonNode = ButtonCategoryNode(categoryInit: cat)
            allCategoryNodes.append(buttonNode)
        }
        
        catsOpen = true
        
        super.init(size: size)
        
        
        Model.shared.addTargetDelegate = self
//        Modelv2.shared.addTweetDelegate = self
//        Modelv2.shared.addTargetDelegate = self
        
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        
        background.size.width = size.width * 10
        background.size.height = size.height * 10
        background.name = "background"
        background.position = CGPoint(x: 0, y: 100)
        addChild(background)
        
        
        
        
        //        let swipe = UIPanGestureRecognizer(target: self, action: Selector(("moveCenter")))
        //        self.addGestureRecognizer(swipe)
        self.isUserInteractionEnabled = true
        
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        
        
    }
    

    func addTargetSpritesNew(target: TargetNew) {
        
            let sprite = TargetSpriteNew(target: target)
            
            Model.shared.targetSpriteNew.append(sprite)
        
        
//        if sprite.category == .spyGame {
//            
//            let roundedImage = UIImage(named: "spyIcon")
//            let myTexture = SKTexture(image: roundedImage!)
//            sprite.texture = myTexture
//        }
        
        
        if sprite.category == .tweet {
            Model.shared.fetchImage(stringURL: sprite.profileImageURL) { returnedImage in
                guard let validImage = returnedImage else {
                    return
                }
                let roundedImage = validImage.circle
                let myTexture = SKTexture(image: roundedImage!)
                sprite.texture = myTexture
            
        }
//                if sprite.distance < 75 {
//
//                self.background.addChild(sprite)
//                print(sprite.nameLabel.text ?? "mmmmmmmmm")
//                if let validMask = Model.shared.assignBitMask2()  {
//                    sprite.anchorGrav.categoryBitMask = validMask
//                    sprite.physicsBody?.fieldBitMask = validMask
//                    sprite.mask = validMask
//                    sprite.applySize()
//                    sprite.changePhysicsBody()
//                }
//                
//                }
            
            }
    }
    

    
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
    
    
//    func makeCategoryNodes() {
//        
//        let radius = CGFloat(50)
//       
//        
//        var i = 0
//            for cat in allCategories {
//                let buttonNode = ButtonCategoryNode(categoryInit: cat)
//                
//                let angle = 2 * M_PI / Double(categories.count) * Double(i)
//                let coinX = radius * cos(CGFloat(angle))
//                let coinY = radius * sin(CGFloat(angle))
//                buttonNode.position = CGPoint(x:coinX + profileNode.position.x, y:coinY + profileNode.position.y)
//                allCategoryNodes.append(buttonNode)
//                i += 1
//            }
//            
////            self.addChild(buttonNode)
//        }
    

    
    func adjustCatNodes(point: CGPoint) {
        let count = allCategoryNodes.count - 1
        let radius = CGFloat(50)
        for i in 0...count {
        
            let angle = 2 * M_PI / Double(allCategoryNodes.count) * Double(i)
            let coinX = radius * cos(CGFloat(angle))
            let coinY = radius * sin(CGFloat(angle))
            allCategoryNodes[i].position = CGPoint(x:coinX + point.x, y:coinY + point.y)
            
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
        
        
        profileNode.position = CGPoint(x: Model.shared.myScreenOrigin.x, y: Model.shared.myScreenOrigin.y - 200)
        self.addChild(profileNode)
        
        adjustCatNodes(point: profileNode.position)
        for node in allCategoryNodes {
            self.addChild(node)
        }
//        categories = [.tweet, .eater38, .spyGame]
        
//        makeCategoryNodes()
        
        gravField.position = Model.shared.myScreenOrigin
        //                gravField.isEnabled = true
        gravField.categoryBitMask = gravityCategory
        gravField.strength = 1.0
        self.background.addChild(gravField)
        

        
        
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
                
            case is ButtonCategoryNode:
                let button = nodeAtPoint as! ButtonCategoryNode
                modifyCategories(category: button.category)
            
            case is ProfileNode:
                if catsOpen {
                    for node in allCategoryNodes {
                        node.removeFromParent()
                    }
                    catsOpen = false
                }
                else {
                    for node in allCategoryNodes {
                        self.addChild(node)
                    }
                    
                    catsOpen = true
                }
            case is TargetSpriteNew:
                let targetSpriteNew = nodeAtPoint as! TargetSpriteNew
            
                switch targetSpriteNew.target {
                
                    case is TweetTarget:
                //                        let tweetTargetSprite = targetSpriteNew as! TweetTarget
                        delegateMainVC?.goToTweetTarget(target: targetSpriteNew)
                
                    case is UserTarget:
                //                        let userTarget = targetSpriteNew as! UserTarget
                            delegateMainVC?.goToUserTarget(target: targetSpriteNew)
                    default:
                        return
                }
        
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
    
    

    func modifyCategories(category: TargetSpriteNew.Category) {
    
           
        if let index = categories.index(of: category) {
            categories.remove(at: index)
        }
        
            
        else {
            categories.append(category)
        }
        
        updateTargetSpriteNewVersion()
        

        
    
    }
    
    
    func updateTargetSpriteNewVersion() {
        
        let array = filteredTargetSprites
        let array2 = targetSpritesByDistance
        let maxSpritesViewable = array.count > 7 ? 7 : array.count
        
        var count = 0
        
        for targetSprite in array2 {
            
            if categories.contains(targetSprite.category!) {
                if count < maxSpritesViewable {
                    
                    if targetSprite.parent == nil {
                        self.background.addChild(targetSprite)
                        if let validMask = Model.shared.assignBitMask2()  {
                            targetSprite.anchorGrav.isEnabled = false
                            targetSprite.anchorGrav.strength = 1.0
                            targetSprite.anchorGrav.categoryBitMask = validMask
                            targetSprite.physicsBody?.fieldBitMask = validMask | gravityCategory
                            targetSprite.mask = validMask
                            //                            print(Model.shared.bitMaskOccupied)
                        }
                    }
                    
                    if let iconNode = targetSprite.iconNode {
                        targetSprite.addChild(iconNode)
                    }
                    
                    targetSprite.applySize()
                    targetSprite.changePhysicsBody()
    
                    count += 1
                }
                else {
                    if targetSprite.parent != nil {
                        
                        targetSprite.removeFromParent()
                        targetSprite.anchorGrav.isEnabled = false
                        Model.shared.removeBitMask2(mask: targetSprite.mask!)
                    }
                    
                }
            }

            
            else {
                if targetSprite.parent != nil {
                    targetSprite.removeFromParent()
                    Model.shared.removeBitMask2(mask: targetSprite.mask!)
                }
                
            }
            
 

        }
        
        
    }
    
    
    
    

    

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
    
            Model.shared.myScreenOrigin = CGPoint(x: Model.shared.myScreenOrigin.x - translation.x, y: Model.shared.myScreenOrigin.y - translation.y)
            cam.position = Model.shared.myScreenOrigin
            gravField.position = Model.shared.myScreenOrigin
            
            profileNode.position = CGPoint(x: Model.shared.myScreenOrigin.x, y: Model.shared.myScreenOrigin.y - 200)

            adjustCatNodes(point: CGPoint(x: Model.shared.myScreenOrigin.x, y: Model.shared.myScreenOrigin.y - 200))
            
            

            //            updateSpotSizes()
            //            updateTargetSizes()
//            updateTargetSpritesVer2()
//            updateTargetSprByDistance()
            
//            updateTargetSprNew()
            updateTargetSpriteNewVersion()
//            fade()
            recognizer.setTranslation(CGPoint(x: 0, y:0), in: recognizer.view)
            
            //            self.panForTranslation(translation)
            //            recognizer.setTranslation(CGPointZero, in: recognizer.view)
            

        }

    }
    
    

    
//    func fade() {
//    
//        let fadeOut = SKAction.fadeOut(withDuration: 0.5)
//        let fadeIn = SKAction.fadeIn(withDuration: 1.5)
//        let fadeSequence: [SKAction] = [fadeOut, fadeIn]
//        
//        for targetSprite in Model.shared.targetSprNewByDistance {
//            targetSprite.alpha = 0
//      
//        }
// 
//    }
//    
    
    
    
    
    
    
    override func update(_ currentTime: TimeInterval) {
        
        //        updateSpotSizes()
        cam.position = Model.shared.myScreenOrigin
        gravField.position = Model.shared.myScreenOrigin
        
        if let heading = Model.shared.myHeading {
           background.zRotation = CGFloat(M_PI * 2) * CGFloat(heading/360)
            for targetSprite in Model.shared.targetSpriteNew {
                targetSprite.zRotation = -1 * background.zRotation
            }
        }
       
    }

}



