////
////  TestScene.swift
////  SpyNetProto
////
////  Created by Edward Han on 1/26/17.
////  Copyright © 2017 Edward Han. All rights reserved.
////
//
////
////  GameScene.swift
////  SpyTestCircls
////
////  Created by Edward Han on 1/25/17.
////  Copyright © 2017 Edward Han. All rights reserved.
////
//
//import SpriteKit
//import GameplayKit
//import QuartzCore
//import Firebase
//import CoreLocation
//
//
//extension UIImage {
//    var rounded: UIImage? {
//        let imageView = UIImageView(image: self)
//        imageView.layer.cornerRadius = min(size.height/4, size.width/4)
//        imageView.layer.masksToBounds = true
//        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
//        guard let context = UIGraphicsGetCurrentContext() else { return nil }
//        imageView.layer.render(in: context)
//        let result = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        return result
//    }
//    var circle: UIImage? {
//        let square = CGSize(width: min(size.width, size.height), height: min(size.width, size.height))
//        let imageView = UIImageView(frame: CGRect(origin: .zero, size: square))
//        imageView.contentMode = .scaleAspectFill
//        imageView.image = self
//        imageView.layer.cornerRadius = square.width/2
//        imageView.layer.masksToBounds = true
//        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
//        guard let context = UIGraphicsGetCurrentContext() else { return nil }
//        imageView.layer.render(in: context)
//        let result = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        return result
//    }
//}
//
//
//
//func maskRoundedImage(image: UIImage, radius: Float) -> UIImage {
//    let imageView: UIImageView = UIImageView(image: image)
//    var layer: CALayer = CALayer()
//    layer = imageView.layer
//    
//    layer.masksToBounds = true
//    layer.cornerRadius = CGFloat(radius)
//    
//    UIGraphicsBeginImageContext(imageView.bounds.size)
//    layer.render(in: UIGraphicsGetCurrentContext()!)
//    let roundedImage = UIGraphicsGetImageFromCurrentImageContext()
//    UIGraphicsEndImageContext()
//    
//    return roundedImage!
//}
//
//
//
//class User {
//    
//    
//    var uid: String
//    var name: String
//    var avatar: String
//    var blurb: String
//    var timeStamp: Double
//    
//    init(uid: String) {
//        self.uid = uid
//        name = ""
//        avatar = ""
//        blurb = ""
//        timeStamp = 0.0
//    }
//    
//    init(snapshot: FIRDataSnapshot) {
//        let value = snapshot.value as! [String: Any]!
//        uid = snapshot.key
//        avatar = value?["avatar"] as? String ?? ""
//        blurb = value?["blurb"] as? String ?? ""
//        name = value?["name"] as? String ?? ""
//        timeStamp = value?["timeStamp"] as? Double ?? 0.0
//        
//    }
//    
//}
//
//class TargetSpriteVar: SKSpriteNode {
//    
//    
//    func applySize() {
//        
//        let adjSize = (distance / -2.0) + 150
//        
//        self.nameLabel?.isHidden = adjSize > 100 ? false : true
//        self.size.height = adjSize
//        self.size.width = adjSize
//        
//    }
//    
//    
//    //        print("\(adjSize)..adjSize \n")
//    
//    //        if adjSize < 75 {
//    //
//    //            self.alpha = 0
//    //        }
//    
//    //        if adjSize > 75 {
//    //            self.alpha = ((adjSize - 75) / 50.0) + 0.5
//    //        }
//    
//    
//    func changePhysicsBody() {
//        
//        self.physicsBody = nil
//        
//        let size = self.size.width > 1 ? self.size.width : 1
//        
//        let body = SKPhysicsBody(circleOfRadius: size / 2.0)
//        
//        body.affectedByGravity = true
//        body.isDynamic = true
//        body.density = 0.25
//        body.friction = 0.85
//        body.restitution = 0.95
//        body.allowsRotation = false
//        body.angularVelocity = 0
//        body.linearDamping = 1
//        body.angularDamping = 1
//        //            body.fieldBitMask = self.mask!
//        
//        self.physicsBody = body
//        
//        
//    }
//    
//    
//    
////    enum OnView {
////        case offScreen
////        case onScreen
////    }
//    
////    var target: Target?
//    //    var tweetData: TweetData?
//    var anchorGrav = SKFieldNode()
//    var mask: UInt32?
//    var nameLabel: SKLabelNode?
////    var status: OnView = .offScreen
//    
//    var distance: CGFloat {
//        
//        let newX = position.x - (Model.shared.myScreenOrigin.x)
//        let newY = position.y - (Model.shared.myScreenOrigin.y)
//        
//        return sqrt((newX * newX) + (newY * newY))
//        
//    }
//    
//    
//    
//    
//    required init(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    override init(texture: SKTexture!, color: SKColor, size: CGSize) {
////        self.target = nil
//        super.init(texture: texture, color: color, size: size)
//    }
//    
//    
//    convenience init(target: Target, image: UIImage) {
//        
//        
//        let roundedImage = image.circle
//        let myTexture = SKTexture(image: roundedImage!)
//        
//        self.init(texture: myTexture, color: UIColor(), size: myTexture.size())
////        self.target = target
//        self.texture = myTexture
//        self.position = target.origPos
//        self.size = CGSize(width: 50, height: 50)
//        if let goodUserName = target.user?.name {
//            self.name = goodUserName
//        }
//        if let tweetUserName = target.tweet?.senderID {
//            self.name = tweetUserName
//        }
//        
//        
//        
////        let gravMask = Model.shared.assignBitMask()
//        
//        self.anchorGrav = SKFieldNode.springField()
//        self.anchorGrav.position = target.origPos
//        self.anchorGrav.isEnabled = true
//        self.anchorGrav.strength = 1.0
//        //        self.anchorGrav.name = "anchor\(target.user?.name)"
//        
////        if let validMask = gravMask {
////            print("\(validMask)..\(anchorGrav.position)...VALIDMASK")
////            //            physicsBody!.fieldBitMask = validMask
////            anchorGrav.categoryBitMask = validMask
////            self.mask = validMask
////            
////        }
//        
//        nameLabel = SKLabelNode()
//        nameLabel = SKLabelNode(fontNamed: "Chalkduster")
//        nameLabel?.text = name
//        nameLabel?.horizontalAlignmentMode = .center
//        nameLabel?.position = CGPoint(x: 0, y: 0)
//        nameLabel?.isHidden = true
//        self.addChild(nameLabel!)
//        
//        
//    }
//}
//    
//
//
//
////
////class TargetSprite: SKSpriteNode {
////    
////
////    func applySize() {
////        
////        var adjSize = (distance / -2.0) + 150
////        
//////        print("\(adjSize)..adjSize \n \(distance)..dist \n")
////    
////        
////        if adjSize < 75 {
////
////            self.alpha = 0
////            
////        }
////    
////        
////        if adjSize > 75 {
////
////            self.alpha = ((adjSize - 75) / 50.0) + 0.5
////        }
////    
////        self.nameLabel?.isHidden = adjSize > 100 ? false : true
////        self.size.height = adjSize
////        self.size.width = adjSize
////        
////    }
////    
////    
////    
////    func changePhysicsBody() {
////        
////        self.physicsBody = nil
////        
////        let size = self.size.width > 1 ? self.size.width : 1
////        
////        let body = SKPhysicsBody(circleOfRadius: size / 2.0)
////            
////            body.affectedByGravity = true
////            body.isDynamic = true
////            body.density = 0.25
////            body.friction = 0.85
////            body.restitution = 0.95
////            body.allowsRotation = false
////            body.angularVelocity = 0
////            body.linearDamping = 1
////            body.angularDamping = 1
//////            body.fieldBitMask = self.mask!
////        
////            self.physicsBody = body
////            
////    
////    }
////    
////    
////    
////    enum OnView {
////        case offScreen
////        case onScreen
////    }
////    
////    var target: Target?
//////    var tweetData: TweetData?
////    var anchorGrav = SKFieldNode()
////    var mask: UInt32?
////    var nameLabel: SKLabelNode?
////    var status: OnView = .offScreen
////    
////    var distance: CGFloat {
////        
////        let newX = position.x - (Model.shared.myScreenOrigin.x)
////        let newY = position.y - (Model.shared.myScreenOrigin.y)
////        
////        return sqrt((newX * newX) + (newY * newY))
////        
////    }
////    
////
////  
////    
////    required init(coder aDecoder: NSCoder) {
////        fatalError("init(coder:) has not been implemented")
////    }
////    
////    override init(texture: SKTexture!, color: SKColor, size: CGSize) {
////        self.target = nil
////        super.init(texture: texture, color: color, size: size)
////    }
////    
////   
////    convenience init(target: Target, image: UIImage) {
////    
////            
////            let roundedImage = image.circle
////            let myTexture = SKTexture(image: roundedImage!)
////
////            self.init(texture: myTexture, color: UIColor(), size: myTexture.size())
////            self.target = target
////            self.texture = myTexture
////            self.position = target.origPos
////            self.size = CGSize(width: 50, height: 50)
////        if let goodUserName = target.user?.name {
////             self.name = goodUserName
////        }
////        if let tweetUserName = target.tweet?.senderID {
////            self.name = tweetUserName
////        }
////        
////            self.zPosition = CGFloat(arc4random()%500)
////
////        
////        let gravMask = Model.shared.assignBitMask()
////        
////        self.anchorGrav = SKFieldNode.springField()
////        self.anchorGrav.position = target.origPos
////        self.anchorGrav.isEnabled = true
////        self.anchorGrav.strength = 1.0
//////        self.anchorGrav.name = "anchor\(target.user?.name)"
////        
////        if let validMask = gravMask {
////            print("\(validMask)..\(anchorGrav.position)...VALIDMASK")
//////            physicsBody!.fieldBitMask = validMask
////            anchorGrav.categoryBitMask = validMask
////            self.mask = validMask
////            
////        }
////        
////        nameLabel = SKLabelNode()
////        nameLabel = SKLabelNode(fontNamed: "Chalkduster")
////        nameLabel?.text = name
////        nameLabel?.horizontalAlignmentMode = .center
////        nameLabel?.position = CGPoint(x: 0, y: 0)
////        nameLabel?.isHidden = true
////        self.addChild(nameLabel!)
////
////    
////        }
//
//
////    
////    convenience init(tweetData: TweetData, textureImage: UIImage) {
////        
////        
//////        let roundedImage = tweetData.idImage.circle
////        let roundedImage = textureImage.circle
////        let myTexture = SKTexture(image: roundedImage!)
////        
////        self.init(texture: myTexture, color: UIColor(), size: myTexture.size())
////        self.tweetData = tweetData
////        self.texture = myTexture
////        self.position = tweetData.origPos
////        self.size = CGSize(width: 50, height: 50)
////        self.name = tweetData.senderID
////        
////        
////        let gravMask = Model.shared.assignBitMask()
////        
////        self.anchorGrav = SKFieldNode.springField()
////        self.anchorGrav.position = tweetData.origPos
////        self.anchorGrav.isEnabled = true
////        self.anchorGrav.strength = 1.0
////        self.anchorGrav.name = "anchor\(tweetData.senderID)"
////        
////        if let validMask = gravMask {
////            print("\(validMask)..\(anchorGrav.position)...VALIDMASK")
////            //            physicsBody!.fieldBitMask = validMask
////            anchorGrav.categoryBitMask = validMask
////            self.mask = validMask
////            
////        }
////        
////        nameLabel = SKLabelNode()
////        nameLabel = SKLabelNode(fontNamed: "Chalkduster")
////        nameLabel?.text = tweetData.senderID
////        nameLabel?.horizontalAlignmentMode = .center
////        nameLabel?.position = CGPoint(x: 0, y: 0)
////        nameLabel?.isHidden = true
////        self.addChild(nameLabel!)
////        
////        
////    }
//    
//    
//    
//
//
//
//    
//
//
//
//
//
////
////class Target {
//////    var sprite: SKSpriteNode?
////    
////    enum OnView {
////        case offScreen
////        case onScreen
////    }
////    
////    var user: User? // make this a UID...
////    var tweet: TweetData?
////    var scaleAdjust = CGFloat(12500)  // was at 9500
////    var lat: CLLocationDegrees  // prob dont need. keep in user/tweet....
////    var lon: CLLocationDegrees
////    var origPos: CGPoint
////    var profileImage: UIImage
////    var sceneStatus: OnView = .offScreen
////    var sprite: TargetSpriteVar?
//////    {
//////        return TargetSpriteVar(target: self, image: profileImage)
//////    }
////
////    init(user: User, location: CLLocation) {
////        self.user = user
////        self.lat = (location.coordinate.latitude)
////        self.lon = (location.coordinate.longitude)
////        let origin = Model.shared.myLocation
////        let originLat = CGFloat(lat - (origin!.coordinate.latitude))
////        let originLon = CGFloat(lon - (origin!.coordinate.longitude))
////        let scaledX = originLat * scaleAdjust
////        let scaledY = originLon * scaleAdjust
////        self.origPos = CGPoint(x: scaledX, y: scaledY)
////        profileImage = (UIImage(named: "plus")?.circle!)!
////        self.tweet = nil
//////        sprite = TargetSpriteVar(target: self, image: self.profileImage)
////    }
////    
////    init(tweet: TweetData, location: CLLocation) {
////        self.tweet = tweet
////        self.lat = (location.coordinate.latitude)
////        self.lon = (location.coordinate.longitude)
////        let origin = Model.shared.myLocation
////        let originLat = CGFloat(lat - (origin!.coordinate.latitude))
////        let originLon = CGFloat(lon - (origin!.coordinate.longitude))
////        let scaledX = originLat * scaleAdjust
////        let scaledY = originLon * scaleAdjust
////        self.origPos = CGPoint(x: scaledX, y: scaledY)
////        self.profileImage = tweet.profileImage
////        self.user = nil
////        
////        
////    }
////    
////    
////}
////    
////        let origin = Model.shared.myOrigin
////        let originLat = CGFloat(lat - (origin!.coordinate.latitude))
////        let originLon = CGFloat(lon - (origin!.coordinate.longitude))
////        let scaledX = originLat * scaleAdjust
////        let scaledY = originLon * scaleAdjust
//////        print("\(scaledX)..\(scaledY).......InitialPosition******")
////        return CGPoint(x: scaledX, y: scaledY)
////        
////        
////    }
//    
//
//
//
//
//
//
//
//
////protocol AddTargetProtocol: class {
////    
//////    func addTarget(target: Target)
////    func addTargetSprites(target: Target)
////}
////
////
////
////
////protocol AddTweetProtocol: class {
////    
////    //    func addTarget(target: Target)
////    func addTweet(tweetData: TweetData)
////}
////
//
//
//class FieldSceneOldVersion: SKScene, AddTargetProtocol/* AddTweetProtocol */{
//    
//    weak var delegateMainVC: GoToDetail?
//    let center = CGPoint(x: 0, y: 0)
//    let circlePath = UIBezierPath(arcCenter: CGPoint(x: 0, y: 0), radius: 10, startAngle: 0, endAngle: CGFloat(M_PI_2), clockwise: true)
//    let gravityCategory: UInt32 = 1 << 30
//    var cam: SKCameraNode!
//    let gravField = SKFieldNode.springField()
//    let background = SKSpriteNode(imageNamed: "horizonSpace")
//    var profileNode: SKSpriteNode!
//
//    
//    
//  
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder) is not used in this app")
//    }
//    
//    override init(size: CGSize) {
//        super.init(size: size)
//        
//        
//        Model.shared.addTargetDelegate = self
////        Modelv2.shared.addTweetDelegate = self
//        Modelv2.shared.addTargetDelegate = self
//        
//        anchorPoint = CGPoint(x: 0.5, y: 0.5)
//        
//        
//        background.size.width = size.width * 10
//        background.size.height = size.height * 10
//        addChild(background)
//        
////        let swipe = UIPanGestureRecognizer(target: self, action: Selector(("moveCenter")))
////        self.addGestureRecognizer(swipe)
//        self.isUserInteractionEnabled = true
//        
//        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
//        
//        
//  // Create grav field
//       
//        //        gravField.position.x = size.width/2; // Center on X axis
//        //        gravField.position.y = size.height/2; // Center on Y axis (Now at center of screen)
//
//
////        addChild(gravField);
//        
////        let gravNode = SKSpriteNode(imageNamed: "Spaceship")
////        gravNode.position.x = 0
////        gravNode.position.y = 0
////        gravNode.size = CGSize(width: 10, height: 10)
////        
////        addChild(gravNode)
//        
//        
//        
//    }
//    
//    
//
//    
////    func moveCenter(_ sender: UIPanGestureRecognizer) {
////
////        var point = sender.translation(in: view)
////        print("\(point).....translation..")
////        
////    }
//    
//    
//
//    
//
//    
//    
//    
////    func sizeSprites() {
////        
////        for sprite in Model.shared.queryTargets {
////            sprite.applySize()
////           
////            if sprite.size.width > 60 && sprite.status == .offScreen {
////                
////                let gravMask = Model.shared.assignBitMask()
////                if let validMask = gravMask {
////                    sprite.anchorGrav.categoryBitMask = validMask
////                    sprite.mask = validMask
////                }
////                
////                sprite.changePhysicsBody()
////                
////                self.addChild(sprite)
////                self.addChild(sprite.anchorGrav)
////                sprite.status = .onScreen
////            }
////            
//////            if sprite.size.width < 60 && sprite.status == .onScreen {
//////                sprite.removeFromParent()
//////                sprite.anchorGrav.removeFromParent()
//////                Model.shared.makeBitMaskAvailable(maskNum: sprite.mask!)
//////                
//////
//////            }
////            
////
////
////        }
////        
////
////    }
//    
//    
//    
//    
//    func sizeSpritesSingle(sprite: TargetSprite) {
//        
//     
//            sprite.applySize()
//
////            if sprite.distance > 75 && sprite.target?.sceneStatus == .onScreen {
//////                (print("\n removing \n \n"))
////                sprite.removeFromParent()
////                sprite.anchorGrav.removeFromParent()
////                if let validMask = sprite.mask {
////                         Model.shared.makeBitMaskAvailable(maskNum: validMask)
////                }
////           
////            }
//        
//            sprite.changePhysicsBody()
//            
//    
//    }
//    
//    
//    
//    
//    func addTweet(tweetData: TweetData) {
//        
//    
//        let profileImageURL = tweetData.idImageURL
//
//        Model.shared.fetchImage(stringURL: profileImageURL) { image in
//            
//            guard let returnedImage = image else  {
//                return
//            }
//            
//            tweetData.profileImage = returnedImage
//            
//            let target = Target(tweet: tweetData, location: CLLocation(latitude: tweetData.lat, longitude: tweetData.lon))
//            
//            Model.shared.sceneTargets.append(target)
//            
//            Model.shared.sceneTweets.append(tweetData)
//            
////            
////            let sprite = TargetSprite(tweetData: tweetData, textureImage: returnedImage)
////            Model.shared.queryTargets.append(sprite)
//////            self.addChild(sprite)
//////            self.addChild(sprite.anchorGrav!)
//////            sprite.applySize()
//////            sprite.changePhysicsBody()
////            self.sizeSpritesSingle(sprite: sprite)
//            
//            
//        }
//
//        
//        
//    }
//    
//    
//    func addTargetSprites(target: Target) {
//        
//        let profileImageURL = target.user == nil ? target.tweet?.idImageURL : target.user?.avatar
//        
//        Model.shared.fetchImage(stringURL: profileImageURL!) { image in
//            
//            guard let returnedImage = image else  {
//                return
//            }
//            
//            target.profileImage = returnedImage
//            Model.shared.sceneTargets.append(target)
//            
//            
//           let sprite = TargetSprite(target: target, image: returnedImage)
//            Model.shared.targetSprites.append(sprite)
//        
//            
////            let sprite = TargetSpriteVar(target: target, image: target.profileImage)
////            target.sprite = sprite
////            Model.shared.sceneTargetSprites.append(sprite!)
////            Model.shared.sceneTargetSprites.append(target.sprite)
//            
//            
//            
////            sprite.applySize()
////            sprite.changePhysicsBody()
//
////            self.addChild(sprite)
////            self.addChild(sprite.anchorGrav!)
////            sprite.applySize()
////            sprite.changePhysicsBody()
////            self.sizeSpritesSingle(sprite: sprite)
//            
//            
//        }
//        
//        
//        
//        
//    }
//
//    
//    
//    
//    
////    func addTarget(target: Target) {
////        let profileImageURL = target.user!.avatar
////        //        let sizeFactor = spot.spotData.time * 10
////        //        let roundedImage = maskRoundedImage(image: UIImage(named: profileImage)!, radius: Float(sizeFactor))
////    
////        
////        
////        Model.shared.fetchImage(stringURL: profileImageURL) { image in
////            
////            guard let returnedImage = image else  {
////                return
////            }
////            
////            let roundedImage = returnedImage.circle
////            let texture = SKTexture(image: roundedImage!)
////            let sprite  = SKSpriteNode(texture: texture)
////            
////            sprite.position = target.origPos
//////            
//////            let sizeFactor = self.applySize(position: target.origPos)
////          
//////            sprite.zPosition = 1 * sizeFactor
////            sprite.size = CGSize(width: 50, height: 50)
////            
////            print("\(sprite.position)..\n.\(target.origPos).\n.\(sprite.size.width)...\n.\(target.lat).\(target.lon)...\n.")
////            
////            sprite.physicsBody = SKPhysicsBody(circleOfRadius: sprite.size.width / 2.0)
////            sprite.physicsBody!.affectedByGravity = true
////            sprite.physicsBody!.isDynamic = true
////            sprite.physicsBody!.density = 10.0
////            sprite.physicsBody!.friction = 10.0
////            sprite.physicsBody!.restitution = 0.95
////            sprite.physicsBody!.allowsRotation = false
////            sprite.physicsBody!.angularVelocity = 0
////            sprite.physicsBody!.linearDamping = 1
////            sprite.physicsBody!.angularDamping = 1
////            sprite.isUserInteractionEnabled = false
////
//////            sprite.physicsBody!.charge = -0.1 * sizeFactor
////
//////            print("\(sprite.position)......\(target.user!.name).....")
////            
////            
////            let gravMask = Model.shared.assignBitMask()
////            
////            let anchorGrav = SKFieldNode.springField()
////            anchorGrav.position = target.origPos
////            anchorGrav.isEnabled = true
////            anchorGrav.strength = 1.0
////            anchorGrav.name = "anchor\(target.user?.name)"
////            
////            if let validMask = gravMask {
////                print("\(validMask)..\(anchorGrav.position)...VALIDMASK")
////                sprite.physicsBody!.fieldBitMask = validMask | self.gravityCategory
////                anchorGrav.categoryBitMask = validMask
////            }
////            
////            sprite.name = target.user!.name
////            target.sprite = sprite
////            
////            self.addChild(anchorGrav)
////            self.addChild(sprite)
////            
////           
////        }
////        
////
////        
////        
////    }
//    
//    func makeProfileNode() -> SKSpriteNode {
//        
//        let profileImage = UIImage(named: "plus")?.circle
//        let profileTexture = SKTexture(image: profileImage!)
//        let profileNode = SKSpriteNode(texture: profileTexture)
//        profileNode.size.width = 50
//        profileNode.size.height = 50
//        profileNode.name = "profileButtonXOXO"
//        return profileNode
//        
//        
//    }
//    
//    
//    override func didMove(to view: SKView) {
//        
//        
//        cam = SKCameraNode() //initialize and assign an instance of SKCameraNode to the cam variable.
//        cam.setScale(1.0)  //the scale sets the zoom level of the camera on the given position
//        
//        self.camera = cam //set the scene's camera to reference cam
//        self.addChild(cam) //make the cam a childElement of the scene itself.
//        
//        //position the camera on the gamescene.
//        cam.position = CGPoint(x: 0, y: 0)
//        Model.shared.myScreenOrigin = CGPoint(x: 0, y: 0)
//        
//        profileNode = makeProfileNode()
//        profileNode.position = CGPoint(x: Model.shared.myScreenOrigin.x, y: Model.shared.myScreenOrigin.y - 200)
//        self.addChild(profileNode)
//        
//        
////        gravField.position = Model.shared.myScreenOrigin
////        gravField.isEnabled = true
////        gravField.categoryBitMask = gravityCategory
////        gravField.strength = 1.0
////        self.addChild(gravField)
//        
////        
////        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanFrom))
////        self.view!.addGestureRecognizer(gestureRecognizer)
////        
////        
//    }
//    
//    
//    func touchDown(atPoint pos : CGPoint) {
// 
//        
//        
//    }
//    
//    func touchMoved(toPoint pos : CGPoint) {
//
//        
//    }
//    
//    func touchUp(atPoint pos : CGPoint) {
//        
//        
//        
//        
//    }
//    
////    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
////        
////        for touch in touches {
////            
////            let positionInScene = touch.location(in: self)
////            let touchedNode = self.atPoint(positionInScene)
////            
////            if let name = touchedNode.name
////            {
////                print(name)
////                
////            }
////            
////        }
////    
////
////    }
//    
//    
//    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        let touch = touches.first
//        if let positionInScene = touch?.location(in: self) {
//            
//            
//            let nodeAtPoint = atPoint(positionInScene)
//            print(nodeAtPoint.name ?? "no name")
//            
//            if nodeAtPoint.name != nil {
//                if nodeAtPoint.name == "profileButtonXOXO" {
//                    print("profiel seleceted \n \n profile selected \n ")
//                    delegateMainVC?.goToProfile()
//                    
//                }
//                    
//                    
//                
//                    
//                
//                else {
//                    
//                    let targetSprite = nodeAtPoint as! TargetSprite
////                    print("\(targetSprite.target?.user?.name)...\(target.mask)....")
//                    
//                    if let _ = targetSprite.target?.tweet {
//                        delegateMainVC?.goToTweet(targetSprite: targetSprite)
//                        
//                    }
//                    else {
//                       delegateMainVC?.goToDetail(targetSprite: targetSprite)
//                    }
//                    
//                    
//                }
//
//                
//            }
//        }
//    
//    
//    }
//    
//    
//    
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//
//
//
//       
//    }
//    
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
//    }
//    
//    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
//    }
//    
//    
//    func updateTargetSpritesVer2() {
//        for targetSprite in Model.shared.targetSprites {
//            
//            if targetSprite.distance < 125 && targetSprite.parent == nil {
//                self.addChild(targetSprite)
//                targetSprite.applySize()
//                targetSprite.changePhysicsBody()
//            
//            }
//            
//            if targetSprite.distance > 125 && targetSprite.parent == self {
//                targetSprite.removeFromParent()
//                
//            }
//            
//            
//            
//        }
//        
//        
//    }
////    func updateTargetSizes() {
////        
////        for target in Model.shared.sceneTargets {
////            
////            //            if targetSprite.parent == nil {
////            //                self.addChild(targetSprite)
////            
////            if let _ = target.sprite {
////                target.sprite?.applySize()
////                target.sprite?.changePhysicsBody()
////                
////            }
////            //
//////            print("\(target.sprite.size)")
//////            target.sprite.applySize()
//////            target.sprite.changePhysicsBody()
////            
////            //            sizeSpritesSingle(sprite: targetSprite)
////            //            targetSprite.physicsBody!.fieldBitMask = targetSprite.mask! | gravityCategory
////            //            if  let validMask = targetSprite.mask {
////            //                targetSprite.physicsBody?.fieldBitMask = validMask
////            //            }
////            
////            
////            
////        }
////        
////    }
////    
//    
//    
//    
//    func updateSpotSizes() {
//        
//        for targetSprite in Model.shared.sceneTargetSprites {
//    
////            if targetSprite.parent == nil {
////                self.addChild(targetSprite)
////           
//            print("\(targetSprite.size)")
//            targetSprite.applySize()
//            targetSprite.changePhysicsBody()
//            
////            sizeSpritesSingle(sprite: targetSprite)
////            targetSprite.physicsBody!.fieldBitMask = targetSprite.mask! | gravityCategory
////            if  let validMask = targetSprite.mask {
////                targetSprite.physicsBody?.fieldBitMask = validMask
////            }
//            
//
//
//        }
//        
//    }
//    
//    
//    func sorterForDisAsc(this:TargetSpriteVar, that:TargetSpriteVar) -> Bool {
//        return this.distance > that.distance
//    }
////    
////    func addSpritesTwo() {
////        
////        // go through sorted Array of targets, give them a mask...
////        let sortedSprites = Model.shared.queryTargets.sort{$0.distance < $1.distance}
////        
////        
////        for i in 0...16  {
////            
////            if sortedSprites[i].sceneStatus == .offScreen {
////                // add
////                let sprite = TargetSprite(target: target, image: target.profileImage)
////                let gravMask = Model.shared.assignBitMask()
////                if let validMask = gravMask {
////                    sprite.anchorGrav.categoryBitMask = validMask
////                    sprite.mask = validMask
////                    sprite.physicsBody?.fieldBitMask = validMask
////                }
////                
////                self.addChild(sprite)
////                self.addChild(sprite.anchorGrav)
////                sizeSpritesSingle(sprite: sprite)
////                target.sceneStatus = .onScreen
////                
////            }
////            
////            
////        }
////        
////    }
//    
//    
//    
//    
//    
//    func addSprites() {
//        
//        for target in Model.shared.sceneTargets {
//            
//            var distance: CGFloat {
//                
//                let newX = target.origPos.x - (Model.shared.myScreenOrigin.x)
//                let newY = target.origPos.y - (Model.shared.myScreenOrigin.y)
//                
//                return sqrt((newX * newX) + (newY * newY))
//                
//            }
//            
//            
//            if distance < 75 && target.sceneStatus == .offScreen {
//                // add
//                
//                
////                target.sprite = TargetSpriteVar(target: target, image: target.profileImage)
////                self.addChild(target.sprite!)
////                target.sceneStatus = .onScreen
////                print(".....adding \n \n ")
////                let gravMask = Model.shared.assignBitMask()
////                if let validMask = gravMask {
////                    target.sprite?.anchorGrav.categoryBitMask = validMask
////                    target.sprite?.mask = validMask
////                    target.sprite?.physicsBody?.fieldBitMask = validMask
//                }
//                
//            }
//            
//            
////            if distance > 75 && target.sceneStatus == .onScreen {
////                // add
////                print("\n.....removing......\n ")
//////                target.sprite?.removeFromParent()
////                target.sceneStatus = .offScreen
////                
//////                let gravMask = Model.shared.assignBitMask()
////       
////            }
////            
////            if target.sceneStatus == .onScreen {
////                
//////                target.sprite?.applySize()
//////                target.sprite?.changePhysicsBody()
////            }
////            
////
//
//
//            
//        }
//        
//    
//    
//    
////
////    
////    func handlePanFrom(recognizer: UIPanGestureRecognizer) {
////        if recognizer.state == .began {
////            var touchLocation = recognizer.location(in: recognizer.view)
////            touchLocation = self.convertPoint(fromView: touchLocation)
////            
////            //            self.selectNodeForTouch(touchLocation)
////            
////        } else if recognizer.state == .changed {
////            var translation = recognizer.translation(in: recognizer.view!)
////            translation = CGPoint(x: translation.x, y: -translation.y)
////            print("in handle pan changed.....\(translation)")
////            
////            //            let x = translation.x * -1.0
////            //            let y = translation.y * -1.0
////            
////            Model.shared.myScreenOrigin = CGPoint(x: Model.shared.myScreenOrigin.x - translation.x, y: Model.shared.myScreenOrigin.y - translation.y)
////            cam.position = Model.shared.myScreenOrigin
////            gravField.position = Model.shared.myScreenOrigin
////            
////            profileNode.position = CGPoint(x: Model.shared.myScreenOrigin.x, y: Model.shared.myScreenOrigin.y - 200)
////            
////            print("\(Model.shared.myScreenOrigin)....ORIGIN")
////            
////            
////            //            updateSpotSizes()
////            //            updateTargetSizes()
////            updateTargetSpritesVer2()
////            
////            recognizer.setTranslation(CGPoint(x: 0, y:0), in: recognizer.view)
////            
////            //            self.panForTranslation(translation)
////            //            recognizer.setTranslation(CGPointZero, in: recognizer.view)
////            
////        }
////        //        else if recognizer.state == .ended {
////        //            var translation = recognizer.translation(in: recognizer.view!)
////        //            translation = CGPoint(x: translation.x, y: -translation.y)
////        //            print("in handle pan.....\(translation)")
////        //
////        //        }
////    }
//    
//    
//    
//    
//    
//    override func update(_ currentTime: TimeInterval) {
//    
////        updateSpotSizes()
////        cam.position = Model.shared.myScreenOrigin
////        gravField.position = Model.shared.myScreenOrigin
//// 
////        addSprites()
//       
//    }
//}
//
//
//
//
//
////
////
////    func applySize(position: CGPoint) -> CGFloat {
//////        print(".......\n...\(Model.shared.myScreenOrigin).....")
////        let newX = position.x - (Model.shared.myScreenOrigin.x)
////        let newY = position.y - (Model.shared.myScreenOrigin.y)
////
////        let distance = sqrt((newX * newX) + (newY * newY))
////        var adjustedDist = CGFloat(3500 / distance + 10)
////        print("\(distance).dist....\(adjustedDist).adjustDist")
////
////        if adjustedDist < 50 {
////            adjustedDist = 50
////        }
////        if adjustedDist > 200 {
////            adjustedDist = 200
////        }
////
//////        if distance < 2 {
//////            distance = 2
//////        }
//////        if distance > 20 {
//////            distance = 20
//////        }
////
////        let spriteSize = adjustedDist
//////        print("\(spriteSize)...\(distance).......ss")
////
//////        let spriteSize = CGFloat(distance * 10)
////        return spriteSize
////
////    }
//
//
//
////            targetSprite.physicsBody = targetSprite.getPhysicsBody(position: (targetSprite.target?.origPos)!)
////            print("\(target.sprite!.position)..\n \(target.origPos)...\(target.sprite!.size.width)\n POS in UPDATESPOTSIZES") -- change applysize to mutating func
////            targetSprite.applySize(position: (targetSprite.target?.origPos)!)
////            let sizeFactor = applySize(position: (targetSprite.target?.origPos)!)
////            let size2 = targetSprite.applySize()
////
////            targetSprite.size = CGSize(width: size2, height: size2)
//
////            print(targetSprite.target?.origPos ?? "no origPOs?")
