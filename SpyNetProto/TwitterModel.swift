//
//  TwitterModel.swift
//  SpyNetProto
//
//  Created by Edward Han on 2/14/17.
//  Copyright © 2017 Edward Han. All rights reserved.
//

import Foundation
import TwitterKit
import CoreLocation
import UIKit


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






class Modelv2{
    static let shared = Modelv2()
    private init(){}
    
    var dateFormatter = DateFormatter()
    
    weak var addTweetDelegate: AddTweetProtocol?
    
    weak var addTargetDelegate: AddTargetProtocol?
    
    
    func getTweeterDist(myLocation: CLLocation) -> [(String, Double)] {
        
        var distMap: [(sender: String, dist: Double)] = []
        
        for (key, value) in Model.shared.coordinates {
            let location = key
            let dist = myLocation.distance(from: value)
            let roundedDist = Double(round(dist)/1000)
            let newDistMapTuple = (location, roundedDist)
            distMap.append(newDistMapTuple)
        }
        
        let sortedDistMap = distMap.sorted(by: {$0.dist < $1.dist})
        return sortedDistMap
        
        
    }
    
    
    
    func getTweeterByDist(myLocation: CLLocation) {
        
        var distMap: [(sender: String, dist: Double)] = []
        
        for (key, value) in Model.shared.coordinates {
            let location = key
            let dist = myLocation.distance(from: value)
            let roundedDist = Double(round(dist)/1000)
            let newDistMapTuple = (location, roundedDist)
            distMap.append(newDistMapTuple)
        }
        
        let sortedDistMap = distMap.sorted(by: {$0.dist < $1.dist})
        //        print(sortedDistMap)
        let senders = sortedDistMap[0..<10]
        
        dateFormatter.dateFormat = "EEE MM dd HH:mm:ss Z yyyy"
        let now  = Date()
    
        
//        var tweetList = [TweetData]()
    
        for sender in senders {
            let client = TWTRAPIClient()
            let statusesShowEndpoint = "https://api.twitter.com/1.1/statuses/user_timeline.json"
            let params: [AnyHashable : Any] = [
                "screen_name": sender.0,
                "count": "1"
            ]
            
            var clientError : NSError?
            let request = client.urlRequest(withMethod: "GET", url: statusesShowEndpoint, parameters: params, error: &clientError)

            client.sendTwitterRequest(request) { (response, data, connectionError) in
                if connectionError != nil {
                    print("Error: \(connectionError)")
                }
                guard let goodData = data else {
                    print("no data TWEETS \n \n \n NO DATA TWEETS")
                    return}
                do {
                    let json = try JSONSerialization.jsonObject(with: goodData, options: .mutableContainers) as! [Any]
                    
                    let tweetDict = json[0] as! [String: Any]
                    
                    let timeString = tweetDict["created_at"] as! String
                    let timeData = self.dateFormatter.date(from: timeString)
                    
                    let timeElapsed = now.timeIntervalSince(timeData!)
                    let roundedTime = Double(round(timeElapsed*100)/100)
                    
                    
                    let userDict = tweetDict["user"] as! [String: Any]
                    
                    //                    let photoID = userDict["profile_image_url"] as! String
                    
                    let photoID = userDict["profile_image_url_https"] as! String
                    
                    let messageText = tweetDict["text"] as! String
                
                    let fetchedData = TweetData(message: messageText, senderName: sender.0, idImageURL: photoID, dist: sender.1, time: roundedTime)
                    
                    let target = Target(tweet: fetchedData, location: CLLocation(latitude: fetchedData.lat, longitude: fetchedData.lon))
                    
                    self.addTargetDelegate?.addTargetSprites(target: target)
                    
//                    self.addTweetDelegate?.addTweet(tweetData: fetchedData)
                    

                } catch let jsonError as NSError {print("json error: \(jsonError.localizedDescription)")}
                
            }
            
        }
        
    }
    
    

////func getTweetData(senders: [(String, Double)], closure: @escaping([TweetData]) -> ())
//func getTweetData(totalMapSenders: [(String, Double)]) {
//    
//  
//    dateFormatter.dateFormat = "EEE MM dd HH:mm:ss Z yyyy"
//    let now  = Date()
//    
//    let dG = DispatchGroup()
//    
//    var tweetList = [TweetData]()
//    
//    var senders = [(String, Double)]()
//    
//    for i in 0...5 {
//        senders.append(totalMapSenders[i])
//    }
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
//        dG.enter()
//        
//        client.sendTwitterRequest(request) { (response, data, connectionError) in
//            if connectionError != nil {
//                print("Error: \(connectionError)")
//            }
//            guard let goodData = data else {
//                print("no data")
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
//                let photoURL = URL(string: photoID)!
//   
//                
//                let fetchedData = TweetData(message: messageText, senderName: sender.0, idImageURL: photoID, dist: sender.1, time: roundedTime)
//                
//                tweetList.append(fetchedData)
//                
//                dG.leave()
//                
//                DispatchQueue.global(qos: .utility).async {
//                    //                        sleep(5)
//                    URLSession.shared.dataTask(with: photoURL) { (data, _, _) in
//                        guard let responseData = data else { return }
//                        let image = UIImage(data: responseData)
//                        DispatchQueue.main.async {
//                            fetchedData.idImage = image!
//
//                        }}.resume()
//                }
//            } catch let jsonError as NSError {print("json error: \(jsonError.localizedDescription)")}
//            
//            
//            dG.notify(queue: .main){    //  HOW TO send shapeV5.all even if all dg has not left, but a time has elapsed
//                print("done------ main queue")
//                for i in 0..<5 {
//                    self.addTweetDelegate?.addTweet(tweetData: tweetList[i])
//                }
//            }
//            
//        }
//        
//    }
//    
//}

}
    
