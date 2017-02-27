//
//  TargetUsersSprites.swift
//  SpyNetProto
//
//  Created by Edward Han on 2/22/17.
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



class TweetData {
    //        static var all = [Message]()
    
    var message: String
    var senderID: String
    var idImageURL: String
    var dist: Double
    var time: Double
    var scaleAdjust = CGFloat(15500)
    var lat: CLLocationDegrees
    var lon: CLLocationDegrees
    var origPos: CGPoint
    var profileImage: UIImage
    
    init (message: String, senderName: String, idImageURL: String, dist: Double, time: Double) {
        self.message = message
        self.senderID = senderName
        self.idImageURL = idImageURL
        self.dist = dist
        self.time = time
        self.lat = (Model.shared.coordinates[senderName]?.coordinate.latitude)!
        self.lon = (Model.shared.coordinates[senderName]?.coordinate.longitude)!
        let origin = Model.shared.myLocation
        let originLat = CGFloat(lat - (origin!.coordinate.latitude))
        let originLon = CGFloat(lon - (origin!.coordinate.longitude))
        let scaledX = originLat * scaleAdjust
        let scaledY = originLon * scaleAdjust
        self.origPos = CGPoint(x: scaledX, y: scaledY)
        self.profileImage = UIImage(named: "twitter")!
        
    }
    
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
    //    var sprite: SKSpriteNode?
    
    enum OnView {
        case offScreen
        case onScreen
    }
    
    var user: User? // make this a UID...
    var tweet: TweetData?
    var scaleAdjust = CGFloat(30000)  // was at 9500
    var lat: CLLocationDegrees  // prob dont need. keep in user/tweet....
    var lon: CLLocationDegrees
    var origPos: CGPoint
    var profileImage: UIImage
    var sceneStatus: OnView = .offScreen
    //    var sprite: TargetSpriteVar?
    
    
    init(user: User, location: CLLocation) {
        self.user = user
        self.lat = (location.coordinate.latitude)
        self.lon = (location.coordinate.longitude)
        let origin = Model.shared.myLocation
        let originLat = CGFloat(lat - (origin!.coordinate.latitude))
        let originLon = CGFloat(lon - (origin!.coordinate.longitude))
        let scaledY = (originLat * scaleAdjust)
        let scaledX = (originLon * scaleAdjust)
        self.origPos = CGPoint(x: scaledY, y: scaledX)
        profileImage = (UIImage(named: "plus")?.circle!)!
        self.tweet = nil
        //        sprite = TargetSpriteVar(target: self, image: self.profileImage)
    }
    
    init(tweet: TweetData, location: CLLocation) {
        self.tweet = tweet
        self.lat = (location.coordinate.latitude)
        self.lon = (location.coordinate.longitude)
        let origin = Model.shared.myLocation
        let originLat = CGFloat(lat - (origin!.coordinate.latitude))
        let originLon = CGFloat(lon - (origin!.coordinate.longitude))
        let scaledX = originLat * scaleAdjust
        let scaledY = originLon * scaleAdjust
        self.origPos = CGPoint(x: scaledY, y: scaledX)
        self.profileImage = tweet.profileImage
        self.user = nil
        
        
    }
    
    
}



class TargetSprite: SKSpriteNode {
    
    func applySize() {
        
        var adjSize = (distance / -2.0) + 150
        
        //        print("\(adjSize)..adjSize \n \(distance)..dist \n"
        
        if adjSize < 75 {
            
            self.alpha = 0
            
        }
        
        
        if adjSize > 75 {
            
            self.alpha = ((adjSize - 75) / 50.0) + 0.5
        }
        
        self.nameLabel?.isHidden = adjSize > 100 ? false : true
        self.size.height = adjSize
        self.size.width = adjSize
        
    }
    
    
    
    func changePhysicsBody() {
        
        self.physicsBody = nil
        
        let size = self.size.width > 1 ? self.size.width : 1
        
        let body = SKPhysicsBody(circleOfRadius: size / 2.0)
        
        body.affectedByGravity = true
        body.isDynamic = true
        body.density = 0.25
        body.friction = 0.85
        body.restitution = 0.95
        body.allowsRotation = false
        body.angularVelocity = 0
        body.linearDamping = 1
        body.angularDamping = 1
        
        self.physicsBody = body
        
//        if let validMask = self.mask {
//            body.fieldBitMask = validMask
//        }
    }
    
    
    
    enum OnView {
        case offScreen
        case onScreen
    }
    
    var target: Target?
    //    var tweetData: TweetData?
    var anchorGrav = SKFieldNode()
    var mask: UInt32?
    var nameLabel: SKLabelNode?
    var status: OnView = .offScreen
    
    var distance: CGFloat {
        
        let newX = position.x - (Model.shared.myScreenOrigin.x)
        let newY = position.y - (Model.shared.myScreenOrigin.y)
        
        return sqrt((newX * newX) + (newY * newY))
        
    }
    
    
    
    
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
        self.size = CGSize(width: 50, height: 50)
        if let goodUserName = target.user?.name {
            self.name = goodUserName
        }
        if let tweetUserName = target.tweet?.senderID {
            self.name = tweetUserName
        }
        
       
        
        self.anchorGrav = SKFieldNode.springField()
        self.anchorGrav.position = target.origPos
        self.anchorGrav.isEnabled = true
        self.anchorGrav.strength = 1.0
        //        self.anchorGrav.name = "anchor\(target.user?.name)"
        
//        let gravMask = Model.shared.assignBitMask()
//        if let validMask = gravMask {
//            print("\(validMask)..\(anchorGrav.position)...VALIDMASK")
//            //            physicsBody!.fieldBitMask = validMask
//            anchorGrav.categoryBitMask = validMask
//            self.mask = validMask
//        }
        
//        let roundLat = Double(round(Double(target.lat)*1000) / 1000)
//        let roundLon = Double(round(Double(target.lon)*1000) / 1000)
//        
        nameLabel = SKLabelNode()
        nameLabel = SKLabelNode(fontNamed: "Chalkduster")
        nameLabel?.text = name
        nameLabel?.fontSize = 8
        nameLabel?.horizontalAlignmentMode = .center
        nameLabel?.position = CGPoint(x: 0, y: 0)
        nameLabel?.isHidden = true
        self.addChild(nameLabel!)
        
        
        
        let path = CGMutablePath()
        path.addArc(center: CGPoint.zero, // CGPoint.centerNode.
            radius: self.size.width, //spriteNode.size.width...
            startAngle: 0,
            endAngle: (CGFloat.pi * 2) * CGFloat((arc4random()%100) / 100),
            clockwise: true)
        let ball = SKShapeNode(path: path)
        ball.lineWidth = 10
        ball.fillColor = .red
        ball.strokeColor = .white
        ball.glowWidth = 5.5
        self.addChild(ball)
        
        
        
        
    }
    
}



