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
import Mapbox
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




// make avatar a URL.....
// timestamp date


class User {
    
    var uid: String
    var name: String
    var avatar: URL
    var blurb: String
    var timeStamp: Double
    
    init(uid: String) {
        self.uid = uid
        name = ""
        avatar = URL(string: "")!
        blurb = ""
        timeStamp = 0.0
    }
    
    init(snapshot: FIRDataSnapshot) {
        let value = snapshot.value as! [String: Any]!
        uid = snapshot.key
        let avatarString = value?["avatar"] as? String ?? ""
        avatar = URL(string: avatarString)!
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
//        let point = CGPoint(x: deltaLon, y: deltaLat)
        
    
//        super.init(position: point, image: #imageLiteral(resourceName: "twitter"), name: senderID)
        
        super.init(image: #imageLiteral(resourceName: "twitter"), name: senderID)
  
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
        
//        super.init(position: point, image: UIImage(named: "timeOut")!, name: eventTitle)
        super.init(image: UIImage(named: "timeOut")!, name: eventTitle)
        
    }
    
}

class Blip: UIView {

    
    init(pos: CGPoint){
        let newPosX = pos.x - 10
        let newPosY = pos.y - 10
//        let rect = CGRect(x: Double(pos.x), y: Double(pos.y), width: 20, height: 20)
        let rect = CGRect(x: newPosX, y: newPosY, width: 20, height: 20)
    
        super.init(frame: rect)
        self.backgroundColor = UIColor.cyan
        self.frame.size.width = 20
        self.frame.size.height = 20
        self.layer.cornerRadius = 10
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }
    
}


class UserTarget: TargetNew {
    
    var uid: String
    var userName: String
    var avatar: URL
    var blurb: String
    var time: Double
    var lat: CLLocationDegrees
    var lon: CLLocationDegrees
    var distance: Double
    
    var annotation: MGLPointAnnotation
    
    
    init(snapshot: FIRDataSnapshot, location: CLLocation) {
        let value = snapshot.value as! [String: Any]!
        uid = snapshot.key
        let avatarString = value?["avatar"] as? String ?? ""
        avatar = URL(string: avatarString)!
        blurb = value?["blurb"] as? String ?? ""
        userName = value?["name"] as? String ?? ""
        time = value?["timeStamp"] as? Double ?? 0.0
        lat = location.coordinate.latitude
        lon = location.coordinate.longitude
        
        distance = location.distance(from: Model.shared.myLocation!)
        
        annotation = MGLPointAnnotation()
        //        let point = MyAnnotationView()
        
        annotation.coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        
        let origin = Model.shared.myLocation
        let deltaLat = CGFloat(lat - (origin!.coordinate.latitude))
        let deltaLon = CGFloat(lon - (origin!.coordinate.longitude))
        let point = CGPoint(x: deltaLon, y: deltaLat)
        
        let imageHolder = UIImage(named: "backdrop")?.circle
        
//        super.init(position: point, image: imageHolder!, name: userName)
        super.init(image: imageHolder!, name: userName)
        
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
        
//        super.init(position: point, image: UIImage(named: "eater38")!, name: restName)
        super.init(image: UIImage(named: "eater38")!, name: restName)
    }
    
    
}

// not necessary, let vc get info direct from userTarget...

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
    
    var profileImage: UIImage
    var name: String
   
    
    
    init(image: UIImage, name: String)     {
//        let scaledX = position.x
//        let scaledY = position.y
//        origPos = CGPoint(x: scaledX, y: scaledY)
        profileImage = image.circle!
        self.name = name
        
    }
    
}
        

class TargetScnNode: SCNNode {
    var target: TargetNew
    var profileImageURL: URL
    //    var tweetData: TweetData?
    
    var anchorGrav = SKFieldNode()
    var timeRing = SKShapeNode()
    var mask: UInt32?
    var iconNode: SKSpriteNode?
    var nameLabel = SKLabelNode()
//    var status: OnView = .offScreen
    var category: Category?
//    var distance: CGFloat {
//        
//        let newX = position.x - (Model.shared.myScreenOrigin.x)
//        let newY = position.y - (Model.shared.myScreenOrigin.y)
//        
//        return sqrt((newX * newX) + (newY * newY))
//        
//    }
    
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    init(target: TargetNew){
        self.target = target
        let userTarget = target as! UserTarget
        profileImageURL = userTarget.avatar
        nameLabel.text = userTarget.userName
        super.init()
    
        let geoplane = SCNPlane()
        self.geometry = geoplane
    }
    
    
}




class TargetSpriteNew: SKSpriteNode {
    
    
    static var allTargetSpriteNew = [TargetSpriteNew]()
    
    
    func animateExit() {
        
        self.physicsBody = nil
        let move = SKAction.move(to: self.origPos!, duration: 1.25)
        let fadeOut = SKAction.fadeOut(withDuration: 1.25)
        let shrinkAction = SKAction.resize(toWidth: 10, height: 10, duration: 1.75)
        var actions = [SKAction]()
        actions.append(fadeOut)
        actions.append(shrinkAction)
        actions.append(move)
        let group = SKAction.group(actions)
        self.run(group)
        
        
    }
    
    func animateSize() {
        
//      var adjSize = ((distance * distance) / -2.0) + 150
//        var adjSize = ((distance * distance) / -100) + 150
        
//        var adjSize = ((distance * distance) / -100) + 125
        
        let adjD = 400 - distance
        var adjSize = (adjD * adjD) / 1000
        
        
        if adjSize < 25 {
            
            adjSize = 25
            
        }
        
        if adjSize > 25 && adjSize < 70 {
             self.alpha = 0.5
            adjSize = 50
            
        }
        
        if adjSize > 70 {
            
            self.alpha = ((adjSize - 75) / 50.0) + 0.5
        }
        

//        adjSize = 30
        
        Model.shared.fetchImage(stringURL: profileImageURL) { [weak self] returnedImage in
            guard let validImage = returnedImage else {
                return
            }
            
//            let firstImage = self?.texture
            self?.isHidden = false
            
            let roundedImage = validImage.circle
            let myTexture = SKTexture(image: roundedImage!)
            self?.texture = myTexture
            
            
            var actions = [SKAction]()
            
            
            //use applySize here, instead of repeating above...
            
            let growAction = SKAction.resize(toWidth: adjSize, height: adjSize, duration: 1.5)
//            let imageAction = SKAction.animate(with: [firstImage!, myTexture], timePerFrame: 2.5)
            
            let fadeOut = SKAction.fadeOut(withDuration: 0)
            let fadeIn = SKAction.fadeIn(withDuration: 1.5)
            
            // make fade to alpha and grow to size simultaneous as function
            
            
            self?.run(fadeOut)
            
            actions.append(growAction)
            actions.append(fadeIn )
            

            
            let group = SKAction.group(actions)
            self?.run(group)
            
        }
        

        
        
    }
    
    func applySize() {
//        
//        var adjSize = (distance / -2.0) + 150
        
//        var adjSize = ((distance * distance) / -100) + 200
        let adjD = 400 - distance
        var adjSize2 = (adjD * adjD) / 1000
        
        
        if adjSize2 < 25 {
            
            self.alpha = 0.25
            adjSize2 = 25
            
        }
        
        if adjSize2 > 25 {
            
            self.alpha = ((adjSize2 / 50.0) + 0.25)
        }
    
        
        self.size.height = adjSize2
        self.size.width = adjSize2
        

    }
    

    func changePhysicsBody() {
        
        self.physicsBody = nil
//        self.position = self.origPos!
        
        if self.size.width < 70 {
            
            if self.mask != nil {
                Model.shared.removeBitMask2(mask: self.mask!)
                
                self.mask = nil
                
                self.position = self.origPos!
            }
           
//            self.mask = nil
            self.nameLabel.isHidden = true
            self.position = self.origPos!
            
        }
        
        if self.size.width > 70 {
            
            let size = self.size.width
            
            let body = SKPhysicsBody(circleOfRadius: size / 2.0)
            
            body.affectedByGravity = true
            body.isDynamic = true
            body.density = 0.5
            body.friction = 1
            body.restitution = 1.0
            body.allowsRotation = false
            body.angularVelocity = 0
            body.linearDamping = 1
            body.angularDamping = 1
//            body.pinned = true
        
            
            self.physicsBody = body
            self.nameLabel.isHidden = false
            
//            self.position = self.origPos!
            

          if self.mask == nil {
                
                if let validMask = Model.shared.assignBitMask2()  {
                    self.anchorGrav.categoryBitMask = validMask
                    self.anchorGrav.position = self.origPos!
                    self.physicsBody?.fieldBitMask = validMask
                    self.mask = validMask
                }
            
            }
            
        }
    
        
    }
    
    
    
    enum OnView {
        case offScreen
        case onScreen
    }

    
    var target: TargetNew
    var profileImageURL: URL
    var origPos: CGPoint?
    
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
    
  
    init(target: TargetNew, pos: CGPoint) {
        
        self.target = target
        let roundedImage = target.profileImage
        let myTexture = SKTexture(image: roundedImage)

        nameLabel.fontName = "Chalkduster"
        nameLabel.fontSize = 12
        nameLabel.horizontalAlignmentMode = .center
        nameLabel.position = CGPoint(x: 0, y: 0)
        nameLabel.isHidden = true
   
//        self.anchorGrav.position = origPosition
//        self.anchorGrav.isEnabled = true
//        self.anchorGrav.strength = 1.0
        
        let userTarget = target as! UserTarget
        profileImageURL = userTarget.avatar
        nameLabel.text = userTarget.userName
        
        super.init(texture: myTexture, color: UIColor(), size: CGSize(width: 25, height: 25))
        
//        super.init(color: UIColor.cyan, size: CGSize(width: 25, height: 25))
        
        position = pos
        origPos = position
        

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
        
        
        TargetSpriteNew.allTargetSpriteNew.append(self)
        
        
    }
    
    
}






class ButtonCategoryNode: SKSpriteNode {
    
    
//    var category: TargetSpriteNew.Category
    
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
//    init(categoryInit: TargetSpriteNew.Category) 
    
        init() {
    
        let size = CGSize(width: 50, height: 50)
        let icon = UIImage(named: "spyIcon")?.circle
        let textureIcon = SKTexture(image: icon!)
 
        
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
        
//        name = category.rawValue
//        
        
}





}
