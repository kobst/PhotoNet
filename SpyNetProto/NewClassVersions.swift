//
//  NewClassVersions.swift
//  SpyNetProto
//
//  Created by Edward Han on 3/2/17.
//  Copyright © 2017 Edward Han. All rights reserved.
//
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
import SceneKit

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



class TweetTarget: TargetNew {
    //        static var all = [Message]()
    var message: String
    var senderID: String
    var idImageURL: String
//    var dist: Double
    var time: Double
//    var scaleAdjust = CGFloat(15500)
    var lat: CLLocationDegrees
    var lon: CLLocationDegrees
//    var origPos: CGPoint
//    var profileImage: UIImage
    
    init (message: String, senderName: String, idImageURL: String, time: Double) {
        self.message = message
        self.senderID = senderName
        self.idImageURL = idImageURL
//        self.dist = dist
        self.time = time
        self.lat = (Model.shared.coordinates[senderName]?.coordinate.latitude)!
        self.lon = (Model.shared.coordinates[senderName]?.coordinate.longitude)!
        
        let origin = Model.shared.myLocation
        let deltaLat = CGFloat(lat - (origin!.coordinate.latitude))
        let deltaLon = CGFloat(lon - (origin!.coordinate.longitude))
        let point = CGPoint(x: deltaLon, y: deltaLat)
        
    
        super.init(position: point, image: #imageLiteral(resourceName: "twitter"), name: senderID)
        
        
    }
    
}





class TimeOutTarget: TargetNew {
    //        static var all = [Message]()
    
    
    var uid: String
    var eventTitle: String
    var blurb: String
    var address: String
    var website: String
    var phone: String
    var lat: CLLocationDegrees
    var lon: CLLocationDegrees
//    var dates: String
    
    //    var origPos: CGPoint
    //    var profileImage: UIImage
    
//    init (message: String, senderName: String, idImageURL: String, time: Double) {
//        self.message = message
//        self.senderID = senderName
//        self.idImageURL = idImageURL
//        //        self.dist = dist
//        self.time = time
//        self.lat = (Model.shared.coordinates[senderName]?.coordinate.latitude)!
//        self.lon = (Model.shared.coordinates[senderName]?.coordinate.longitude)!
//        
//        let origin = Model.shared.myLocation
//        let deltaLat = CGFloat(lat - (origin!.coordinate.latitude))
//        let deltaLon = CGFloat(lon - (origin!.coordinate.longitude))
//        let point = CGPoint(x: deltaLon, y: deltaLat)
    
    init(snapshot: FIRDataSnapshot, location: CLLocation) {
        let value = snapshot.value as! [String: Any]!
        uid = snapshot.key
        eventTitle = value?["name"] as? String ?? ""
        blurb = value?["blurb"] as? String ?? ""
        address = value?["address"] as? String ?? ""
        phone = value?["phone"] as? String ?? ""
        website = value?["website"] as? String ?? ""
        lat = location.coordinate.latitude
        lon = location.coordinate.longitude
        
        let origin = Model.shared.myLocation
        let deltaLat = CGFloat(lat - (origin!.coordinate.latitude))
        let deltaLon = CGFloat(lon - (origin!.coordinate.longitude))
        let point = CGPoint(x: deltaLon, y: deltaLat)
        
        super.init(position: point, image: UIImage(named: "timeOut")!, name: eventTitle)
        
        
    }
    
}


class UserTarget: TargetNew {
    
    var uid: String
    var userName: String
    var avatar: String
    var blurb: String
    var time: Double
    var lat: CLLocationDegrees
    var lon: CLLocationDegrees
    
    
    init(snapshot: FIRDataSnapshot, location: CLLocation) {
        let value = snapshot.value as! [String: Any]!
        uid = snapshot.key
        avatar = value?["avatar"] as? String ?? ""
        blurb = value?["blurb"] as? String ?? ""
        userName = value?["name"] as? String ?? ""
        time = value?["timeStamp"] as? Double ?? 0.0
        lat = location.coordinate.latitude
        lon = location.coordinate.longitude
        
        let origin = Model.shared.myLocation
        let deltaLat = CGFloat(lat - (origin!.coordinate.latitude))
        let deltaLon = CGFloat(lon - (origin!.coordinate.longitude))
        let point = CGPoint(x: deltaLon, y: deltaLat)
        
        super.init(position: point, image: UIImage(named: "spyGame")!, name: userName)
        
    }
    
}







class Eater38: TargetNew {
    var uid: String
    var restName: String
    var blurb: String
    var address: String
    var website: String
    var phone: String
    var lat: CLLocationDegrees
    var lon: CLLocationDegrees
    
    
    init(snapshot: FIRDataSnapshot, location: CLLocation) {
        let value = snapshot.value as! [String: Any]!
        uid = snapshot.key
        restName = value?["name"] as? String ?? ""
        blurb = value?["blurb"] as? String ?? ""
        address = value?["address"] as? String ?? ""
        phone = value?["phone"] as? String ?? ""
        website = value?["website"] as? String ?? ""
        lat = location.coordinate.latitude
        lon = location.coordinate.longitude
        
        let origin = Model.shared.myLocation
        let deltaLat = CGFloat(lat - (origin!.coordinate.latitude))
        let deltaLon = CGFloat(lon - (origin!.coordinate.longitude))
        let point = CGPoint(x: deltaLon, y: deltaLat)
        
        super.init(position: point, image: UIImage(named: "eater38")!, name: restName)
        
    }
    
    
}



class TargetNew {
    //    var sprite: SKSpriteNode?
    
    enum OnView {
        case offScreen
        case onScreen
    }
    
//    enum Category {
//        case spyGame
//        case tweet
//        case eater38
//        case timeOutEvent
//        case other
//    }
    
//    var scaleAdjust = CGFloat(30000)  // was at 9500
    var origPos: CGPoint
    var profileImage: UIImage
    var name: String
   
    
    init(position: CGPoint, image: UIImage, name: String) {
        let scaledX = position.x
        let scaledY = position.y
        origPos = CGPoint(x: scaledX, y: scaledY)
        profileImage = image.circle!
        self.name = name
        
    }
    
}
        
//
//class TargetSceneNode: SCNNode {
//    
//    
//    var target: TargetNew
//    
//
//    required init(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    
//    init(target: TargetNew) {
//        
//        self.target = target
//        
//
//        let targetNode = SCNPlane(width: 1.5, height: 1.5)
//        targetNode.cornerRadius = targetNode.width / 2
//        
//        targetNode.firstMaterial?.diffuse.contents = target.profileImage.circle
//        
//        super.init(geometry: targetNode)
//        
//        
//        
//        let x = target.origPos.x / 100
//        let y = target.origPos.y / 100
//        
////        let targetNodeGeo = SCNNode(geometry: targetNode)
//        position = SCNVector3(x, y, 0)
//        
////        super.init(geometry: targetNode)
//    }
//    
//    
//}




//let target = SCNPlane(width: 1.5, height: 1.5)
//target.cornerRadius = target.width / 2
//
//target.firstMaterial?.diffuse.contents = UIImage(named: "trippy2")
//
//let targetNode = SCNNode(geometry: target)
//targetNode.position = SCNVector3(0, 2, -2)
//rootNode.addChildNode(targetNode)






class TargetSpriteNew: SKSpriteNode {
    
    func applySize() {
        
        let adjSize = (distance / -2.0) + 150
        
        //   this needs to be log scale....
        
        if adjSize < 30 {
            
            self.alpha = 0
            
        }
        
        
        if adjSize > 30 {
            
            self.alpha = ((adjSize - 75) / 50.0) + 0.5
        }
        
        self.nameLabel.isHidden = adjSize > 100 ? false : true
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
        
    }
    
    
    
    enum OnView {
        case offScreen
        case onScreen
    }
    
    enum Category: String {
        case spyGame = "spyGame"
        case tweet = "twitter"
        case eater38 = "eater38"
        case timeOutEvent = "timeOut"
        case other = "other"
    }
    
    var target: TargetNew
    var profileImageURL: String
    
    //    var tweetData: TweetData?

    var anchorGrav = SKFieldNode()
    var timeRing = SKShapeNode()
    var mask: UInt32?
    var iconNode: SKSpriteNode?
    var nameLabel = SKLabelNode()
    var status: OnView = .offScreen
    var category: Category?
    var distance: CGFloat {
        
        let newX = position.x - (Model.shared.myScreenOrigin.x)
        let newY = position.y - (Model.shared.myScreenOrigin.y)
        
        return sqrt((newX * newX) + (newY * newY))
        
    }
    
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
  
    init(target: TargetNew) {
        
        self.target = target
        let roundedImage = target.profileImage
        let myTexture = SKTexture(image: roundedImage)
                
        let scaledX = target.origPos.x * Model.shared.scaleAdjust
        let scaledY = target.origPos.y * Model.shared.scaleAdjust
        
        let origPosition = CGPoint(x: scaledX, y: scaledY)
        
        nameLabel.fontName = "Chalkduster"
        nameLabel.fontSize = 12
        nameLabel.horizontalAlignmentMode = .center
        nameLabel.position = CGPoint(x: 0, y: 0)
        nameLabel.isHidden = true
   
        self.anchorGrav.position = origPosition
        self.anchorGrav.isEnabled = true
        self.anchorGrav.strength = 1.0
        
        switch target {
            
        case is TweetTarget:
            let tweetTarget = target as! TweetTarget
            profileImageURL = tweetTarget.idImageURL
            nameLabel.text = tweetTarget.senderID
            category = .tweet
            
            let twitterIcon = UIImage(named: "twitter")
            let texture = SKTexture(image: twitterIcon!)
            let twitterNode = SKSpriteNode(texture: texture, color: UIColor(), size: CGSize(width: 25, height: 25))
            twitterNode.position = CGPoint(x: 5, y: 5)
            
            
        case is UserTarget:
            let userTarget = target as! UserTarget
            profileImageURL = userTarget.avatar
            nameLabel.text = userTarget.userName
            category = .spyGame
        
        case is Eater38:
            let eaterRest = target as! Eater38
            profileImageURL = ""
            nameLabel.text = eaterRest.restName
            category = .eater38
        
            
        case is TimeOutTarget:
            let event = target as! TimeOutTarget
            profileImageURL = ""
            nameLabel.text = event.name
            category = .timeOutEvent
            
            
        default:
            fatalError()
        }
        
        super.init(texture: myTexture, color: UIColor(), size: myTexture.size())
        
        position = origPosition

        let path = CGMutablePath()
        path.addArc(center: CGPoint.zero, // CGPoint.centerNode.
            radius: self.size.width, //spriteNode.size.width...
            startAngle: 0,
            endAngle: (CGFloat.pi * 2) * CGFloat((arc4random()%100) / 100),
            clockwise: true)
        timeRing.path = path
        timeRing.lineWidth = 10
        timeRing.fillColor = .red
        timeRing.strokeColor = .white
        timeRing.glowWidth = 5.5
        
        self.addChild(timeRing)
        self.addChild(nameLabel)
        
    }
    
    
}








class ButtonCategoryNode: SKSpriteNode {
    
    
    var category: TargetSpriteNew.Category
    
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    init(categoryInit: TargetSpriteNew.Category) {
        
        let size = CGSize(width: 50, height: 50)
        let icon = UIImage(named: categoryInit.rawValue)?.circle
        let textureIcon = SKTexture(image: icon!)
        category = categoryInit
        
//        switch categoryInit {
//            
//        case .tweet:
//            let icon = UIImage(named: "twitter")?.circle
//            texture = SKTexture(image: icon!)
//            category = .tweet
//            
//        case .spyGame:
//            let icon = UIImage(named: "spyIcon")?.circle
//            texture = SKTexture(image: icon!)
//            category = .spyGame
//            
//        case .eater38:
//            let icon = UIImage(named: "eater38")?.circle
//            texture = SKTexture(image: icon!)
//            category = .eater38
//        
//        case .timeOutEvent:
//            let icon = UIImage(named: "timeOut")?.circle
//            texture = SKTexture(image: icon!)
//            category = .timeOutEvent
//            
//        default:
//            category = .other
//            
//        }
        
        super.init(texture: textureIcon, color: UIColor(), size: size)
        
        name = category.rawValue
        
        
}





}
