////
////  TwitterModel.swift
////  SpyNetProto
////
////  Created by Edward Han on 2/14/17.
////  Copyright © 2017 Edward Han. All rights reserved.
////
//
//import Foundation
//import TwitterKit
//import CoreLocation
//import UIKit
//
//
//
//
//
//
//class Modelv2{
//    static let shared = Modelv2()
//    private init(){}
//    
//    var dateFormatter = DateFormatter()
//    
////    weak var addTweetDelegate: AddTweetProtocol?
//    
//    weak var addTargetDelegate: AddTargetProtocol?
//    
//    
//    func getTweeterDist(myLocation: CLLocation) -> [(String, Double)] {
//        
//        var distMap: [(sender: String, dist: Double)] = []
//        
//        for (key, value) in Model.shared.coordinates {
//            let location = key
//            let dist = myLocation.distance(from: value)
//            let roundedDist = Double(round(dist)/1000)
//            let newDistMapTuple = (location, roundedDist)
//            distMap.append(newDistMapTuple)
//        }
//        
//        let sortedDistMap = distMap.sorted(by: {$0.dist < $1.dist})
//        return sortedDistMap
//        
//        
//    }
//    
//    
//    
//    func getTweeterByDist(myLocation: CLLocation) {
//        
//        var distMap: [(sender: String, dist: Double)] = []
//        
//        for (key, value) in Model.shared.coordinates {
//            let location = key
//            let dist = myLocation.distance(from: value)
//            let roundedDist = Double(round(dist)/1000)
//            let newDistMapTuple = (location, roundedDist)
//            distMap.append(newDistMapTuple)
//        }
//        
//        let sortedDistMap = distMap.sorted(by: {$0.dist < $1.dist})
//        //        print(sortedDistMap)
//        let senders = sortedDistMap[0..<20]
//        
//        dateFormatter.dateFormat = "EEE MM dd HH:mm:ss Z yyyy"
//        let now  = Date()
//    
//        
////        var tweetList = [TweetData]()
//    
//        for sender in senders {
//            let client = TWTRAPIClient()
//            let statusesShowEndpoint = "https://api.twitter.com/1.1/statuses/user_timeline.json"
//            let params: [AnyHashable : Any] = [
//                "screen_name": sender.0,
//                "count": "1"
//            ]
//            
//            var clientError : NSError?
//            let request = client.urlRequest(withMethod: "GET", url: statusesShowEndpoint, parameters: params, error: &clientError)
//
//            client.sendTwitterRequest(request) { (response, data, connectionError) in
//                if connectionError != nil {
//                    print("Error: \(connectionError)")
//                }
//                guard let goodData = data else {
//                    print("no data TWEETS \n \n \n NO DATA TWEETS")
//                    return}
//                do {
//                    let json = try JSONSerialization.jsonObject(with: goodData, options: .mutableContainers) as! [Any]
//                    
//                    let tweetDict = json[0] as! [String: Any]
//                    
//                    let timeString = tweetDict["created_at"] as! String
//                    let timeData = self.dateFormatter.date(from: timeString)
//                    
//                    let timeElapsed = now.timeIntervalSince(timeData!)
//                    let roundedTime = Double(round(timeElapsed*100)/100)
//                    
//                    
//                    let userDict = tweetDict["user"] as! [String: Any]
//                    
//                    //                    let photoID = userDict["profile_image_url"] as! String
//                    
//                    let photoID = userDict["profile_image_url_https"] as! String
//                    
//                    let messageText = tweetDict["text"] as! String
//                
////                    let fetchedData = TweetData(message: messageText, senderName: sender.0, idImageURL: photoID, dist: sender.1, time: roundedTime)
//                    
//                    let target = Target(tweet: fetchedData, location: CLLocation(latitude: fetchedData.lat, longitude: fetchedData.lon))
//                    
////                    self.addTargetDelegate?.addTargetSprites(target: target)
//                    
////                    self.addTweetDelegate?.addTweet(tweetData: fetchedData)
//                    
//
//                } catch let jsonError as NSError {print("json error: \(jsonError.localizedDescription)")}
//                
//            }
//            
//        }
//        
//    }
//    
//    
//
//////func getTweetData(senders: [(String, Double)], closure: @escaping([TweetData]) -> ())
////func getTweetData(totalMapSenders: [(String, Double)]) {
////    
////  
////    dateFormatter.dateFormat = "EEE MM dd HH:mm:ss Z yyyy"
////    let now  = Date()
////    
////    let dG = DispatchGroup()
////    
////    var tweetList = [TweetData]()
////    
////    var senders = [(String, Double)]()
////    
////    for i in 0...5 {
////        senders.append(totalMapSenders[i])
////    }
////    
////    for sender in senders {
////        let client = TWTRAPIClient()
////        let statusesShowEndpoint = "https://api.twitter.com/1.1/statuses/user_timeline.json"
////        let params: [AnyHashable : Any] = [
////            "screen_name": sender.0,
////            "count": "1"
////        ]
////        
////        var clientError : NSError?
////        let request = client.urlRequest(withMethod: "GET", url: statusesShowEndpoint, parameters: params, error: &clientError)
////        
////        dG.enter()
////        
////        client.sendTwitterRequest(request) { (response, data, connectionError) in
////            if connectionError != nil {
////                print("Error: \(connectionError)")
////            }
////            guard let goodData = data else {
////                print("no data")
////                return}
////            do {
////                let json = try JSONSerialization.jsonObject(with: goodData, options: .mutableContainers) as! [Any]
////                
////                let tweetDict = json[0] as! [String: Any]
////                
////                let timeString = tweetDict["created_at"] as! String
////                let timeData = self.dateFormatter.date(from: timeString)
////                
////                let timeElapsed = now.timeIntervalSince(timeData!)
////                let roundedTime = Double(round(timeElapsed*100)/100)
////                
////                
////                let userDict = tweetDict["user"] as! [String: Any]
////                
////                //                    let photoID = userDict["profile_image_url"] as! String
////                
////                let photoID = userDict["profile_image_url_https"] as! String
////                
////                let messageText = tweetDict["text"] as! String
////                
////                let photoURL = URL(string: photoID)!
////   
////                
////                let fetchedData = TweetData(message: messageText, senderName: sender.0, idImageURL: photoID, dist: sender.1, time: roundedTime)
////                
////                tweetList.append(fetchedData)
////                
////                dG.leave()
////                
////                DispatchQueue.global(qos: .utility).async {
////                    //                        sleep(5)
////                    URLSession.shared.dataTask(with: photoURL) { (data, _, _) in
////                        guard let responseData = data else { return }
////                        let image = UIImage(data: responseData)
////                        DispatchQueue.main.async {
////                            fetchedData.idImage = image!
////
////                        }}.resume()
////                }
////            } catch let jsonError as NSError {print("json error: \(jsonError.localizedDescription)")}
////            
////            
////            dG.notify(queue: .main){    //  HOW TO send shapeV5.all even if all dg has not left, but a time has elapsed
////                print("done------ main queue")
////                for i in 0..<5 {
////                    self.addTweetDelegate?.addTweet(tweetData: tweetList[i])
////                }
////            }
////            
////        }
////        
////    }
////    
////}
//
//}
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
////    func getTargets2(myLocation: CLLocation, completion: @escaping ([Target]) -> ()) {
//////    func getTargets2(myLocation: CLLocation) {
////        //Query GeoFire for nearby users
////        //Set up query parameters
////        //        var keys = [String]()
////        //        var locations = [CLLocation]()
//////        keys.append(stringBack)
//////        locations.append(locationBack)
//////        print(stringBack)
////
////
////        let geoFire = GeoFire(firebaseRef: ref.child("user_locations"))
//////        var targets = [Target]()
////        let fakeLocation = makeFakeLocation()
////        let circleQuery = geoFire?.query(at: fakeLocation, withRadius: 0.25)
////
////        let _ = circleQuery?.observe(.keyEntered, with: {(string, location) in
////            if let validUID = string, let locationBack = location {
////
////
////                self.ref.child("users/\(validUID)").observe(.value, with: { snapshot in
//////                    let value = snapshot.value as? [String: Any]
//////                    print(value?["name"] as? String ?? "(ERROR)")
////                    let user = User(snapshot: snapshot)
////                    let target = Target(user: user, location: locationBack)
////
////                    self.queryUsers.append(user)
//////                    targets.append(target)
//////                    self.queryTargets.append(target)
////
//////                    print(target.user?.name ?? "no name")
//////                    print(self.queryTargets.count)
//////                    self.addTargetDelegate?.addTarget(target: target)
////
//////                    circleQuery?.observeReady({
//////                        completion(self.queryTarget)
//////                    })
////
////
////                })
////
////
////            }})
////
//////        circleQuery?.observeReady({
//////
////////            completion(self.queryTargets)
//////
//////        })
////
////
////
////
////    }
//
//
//
//
////func getTargets3(myLocation: CLLocation) {
////    
////    
////    let geoFire = GeoFire(firebaseRef: ref.child("user_locations"))
////    //        var targets = [Target]()
////    //        let fakeLocation = makeFakeLocation()
////    let circleQuery = geoFire?.query(at: myLocation, withRadius: 2.5)
////    
////    circleQuery?.observe(.keyEntered, with: { [weak self] (string, location) in
////        if let validUID = string, let locationBack = location {
////            
////            self?.ref.child("users/\(validUID)").observe(.value, with: { [weak self] snapshot in
////                //                    let value = snapshot.value as? [String: Any]
////                //                    print(value?["name"] as? String ?? "(ERROR)")
////                let user = User(snapshot: snapshot)
////                let target = Target(user: user, location: locationBack)
////                
////                //                    self.queryTargets.append(user)
////                //                    targets.append(target)
////                
////                
////                print(target.user?.name ?? "no name")
////                //                    print(self?.sceneTargets.count ?? "no count")
////                //                    self.addTargetDelegate?.addTarget(target: target)
////                
////                //                    self?.addTargetDelegate?.addTargetSprites(target: target)
////                
////            })
////            
////            
////        }})
////    
////    
////}
//// return the spot class....
//
//

////----------------------------------------------------------------
////----------------------------------------------------------------
////----------------------------------------------------------------
////----------------------------------------------------------------
////----------------------------------------------------------------
////----------------------------------------------------------------


////----------------------------------------------------------------





//
//
//
//
//func getTweeterByDist(myLocation: CLLocation) {
//    
//    var distMap: [(sender: String, dist: Double)] = []
//    
//    for (key, value) in Model.shared.coordinates {
//        let location = key
//        let dist = myLocation.distance(from: value)
//        let roundedDist = Double(round(dist)/1000)
//        let newDistMapTuple = (location, roundedDist)
//        distMap.append(newDistMapTuple)
//    }
//    
//    let sortedDistMap = distMap.sorted(by: {$0.dist < $1.dist})
//    //        print(sortedDistMap)
//    let senders = sortedDistMap[0..<20]
//    
//    dateFormatter.dateFormat = "EEE MM dd HH:mm:ss Z yyyy"
//    let now  = Date()
//    
//    
//    //        var tweetList = [TweetData]()
//    
//    for sender in senders {
//        let client = TWTRAPIClient()
//        let statusesShowEndpoint = "https://api.twitter.com/1.1/statuses/user_timeline.json"
//        let params: [AnyHashable : Any] = [
//            "screen_name": sender.0,
//            "count": "1"
//        ]
//        
//        var clientError : NSError?
//        let request = client.urlRequest(withMethod: "GET", url: statusesShowEndpoint, parameters: params, error: &clientError)
//        
//        client.sendTwitterRequest(request) { (response, data, connectionError) in
//            if connectionError != nil {
//                print("Error: \(connectionError)")
//            }
//            guard let goodData = data else {
//                print("no data TWEETS \n \n \n NO DATA TWEETS")
//                return}
//            do {
//                let json = try JSONSerialization.jsonObject(with: goodData, options: .mutableContainers) as! [Any]
//                
//                let tweetDict = json[0] as! [String: Any]
//                
//                let timeString = tweetDict["created_at"] as! String
//                let timeData = self.dateFormatter.date(from: timeString)
//                
//                let timeElapsed = now.timeIntervalSince(timeData!)
//                let roundedTime = Double(round(timeElapsed*100)/100)
//                
//                
//                let userDict = tweetDict["user"] as! [String: Any]
//                
//                //                    let photoID = userDict["profile_image_url"] as! String
//                
//                let photoID = userDict["profile_image_url_https"] as! String
//                
//                let messageText = tweetDict["text"] as! String
//                
//                //                    let fetchedData = TweetData(message: messageText, senderName: sender.0, idImageURL: photoID, dist: sender.1, time: roundedTime)
//                
//                //                    let target = Target(tweet: fetchedData, location: CLLocation(latitude: fetchedData.lat, longitude: fetchedData.lon))
//                
//                
//                let tweetTarget = TweetTarget(message: messageText, senderName: sender.0, idImageURL: photoID, time: roundedTime)
//                
//                //                    self.addTargetDelegate?.addTargetSprites(target: target)
//                
//                self.addTargetDelegate?.addTargetSpritesNew(target: tweetTarget)
//                
//                //                    self.addTweetDelegate?.addTweet(tweetData: fetchedData)
//                
//                
//            } catch let jsonError as NSError {print("json error: \(jsonError.localizedDescription)")}
//            
//        }
//        
//    }
//    
//}
//
//
//func getTimeOutEvents(myLocation: CLLocation) {
//    
//    let geoFire = GeoFire(firebaseRef: ref.child("TimeOutEvents_locations"))
//    
//    let circleQuery = geoFire?.query(at: myLocation, withRadius: 3.0)
//    
//    
//    circleQuery?.observe(.keyEntered, with: { [weak self] (string, location) in
//        if let validUID = string, let locationBack = location {
//            
//            self?.ref.child("TimeOutEvents/\(validUID)").observe(.value, with: { [weak self] snapshot in
//                //                    let value = snapshot.value as? [String: Any]
//                //                    print(value?["name"] as? String ?? "(ERROR)")
//                //                    let user = User(snapshot: snapshot)
//                //                    let target = Target(user: user, location: locationBack)
//                
//                let event = TimeOutTarget(snapshot: snapshot, location: locationBack)
//                
//                self?.addTargetDelegate?.addTargetSpritesNew(target: event)
//                
//                
//            })
//            
//            
//        }})
//    
//    
//    
//    
//}
//
//
//func getEater(myLocation: CLLocation) {
//    
//    let geoFire = GeoFire(firebaseRef: ref.child("Eater38_locations"))
//    
//    let circleQuery = geoFire?.query(at: myLocation, withRadius: 3.0)
//    
//    
//    
//    circleQuery?.observe(.keyEntered, with: { [weak self] (string, location) in
//        if let validUID = string, let locationBack = location {
//            
//            self?.ref.child("Eater38/\(validUID)").observe(.value, with: { [weak self] snapshot in
//                //                    let value = snapshot.value as? [String: Any]
//                //                    print(value?["name"] as? String ?? "(ERROR)")
//                //                    let user = User(snapshot: snapshot)
//                //                    let target = Target(user: user, location: locationBack)
//                
//                let eaterRestaurant = Eater38(snapshot: snapshot, location: locationBack)
//                
//                //                    print(target.user?.name ?? "no name")
//                //                    print(self?.sceneTargets.count ?? "no count")
//                //                    self.addTargetDelegate?.addTarget(target: target)
//                //
//                //                    self?.addTargetDelegate?.addTargetSprites(target: target)
//                print("eater \n eater \n eater \n")
//                self?.addTargetDelegate?.addTargetSpritesNew(target: eaterRestaurant)
//                
//                
//            })
//            
//            
//        }})
//    
//}
    
