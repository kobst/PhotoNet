//
//  LocationService.swift
//  SpyNetProto
//
//  Created by Edward Han on 6/28/17.
//  Copyright © 2017 Edward Han. All rights reserved.
//

import Foundation
import GeoFire
import Firebase
import INTULocationManager

class LocationService {
    
    static private let ref = Database.database().reference()
    
    static func getLocation(completion: @escaping (Bool) -> ()) {
        
        let locMgr: INTULocationManager = INTULocationManager.sharedInstance()
        print("getting location------")
        
        locMgr.requestLocation(withDesiredAccuracy: INTULocationAccuracy.block,
                               timeout: 5,
                               delayUntilAuthorized: true,
                               block: {(currentLocation: CLLocation?, achievedAccuracy: INTULocationAccuracy, status: INTULocationStatus) -> Void in
                             
                                
                                if status == INTULocationStatus.success {
                                    print("got location");
                                    let dummyLocation = CLLocation(latitude: 40.7369432, longitude: -73.9918239)
                                    
                                   // let dummyLocation = currentLocation
                                    
//                                  Model.shared.updateMyLocation(myLocation: dummyLocation)
                                    
                                    Session.sharedSession.myLocation = CLLocationCoordinate2D(latitude: dummyLocation.coordinate.latitude, longitude: dummyLocation.coordinate.longitude)
                                    
                                    updateMyLocation(myLocation: dummyLocation)
                                    
                                    Model.shared.myLocation = dummyLocation
                                    
                                    completion(true)
                                    
                                }
                                    
                                else {
                                    print("no location")
                                    completion(false)
                                }
                                
        })
        
        
    }
    
    
    
    static private func makeFakeLocation() -> CLLocation {
        let count = fakeLocations.count - 1
        let random = Int(arc4random()) % count
        let key = fakeLocations[random]
        return coordinates[key]!
    }
    
    static private func updateMyLocation(myLocation: CLLocation) {
        let geoFire = GeoFire(firebaseRef: ref.child("user_locations"))
        
//        let userID = Model.shared.loggedInUser!.uid
//
        
        if let userUid = Session.sharedSession.currentUser?.uid {
            let fakeLocation = makeFakeLocation()
            
            geoFire!.setLocation(fakeLocation, forKey: userUid) { (error) in
                //        geoFire!.setLocation(myLocation, forKey: userID) { (error) in
                if (error != nil) {
                    debugPrint("An error occured: \(String(describing: error))")
                } else {
                    print("Saved location successfully!")
                }
            }
            
            
        }
        
    }
    
    
    
    
    static func getTargetsNewVerComp2(myLocation: CLLocation, closure: (@escaping() -> Void)) {
        
        var uids = [(String, CLLocation)]()
        
        let geoFire = GeoFire(firebaseRef: ref.child("user_locations"))
        
        let dG = DispatchGroup()
        
        if let circleQuery = geoFire?.query(at: myLocation, withRadius: 2.5) {
            
            _ = circleQuery.observe(.keyEntered, with: { string, location in
                if let validUID = string, let locationBack = location {
                    let tuple = (validUID, locationBack)
                    uids.append(tuple)
                    
                    dG.enter()
                    
                    ref.child("users/\(validUID)").observe(.value, with: { snapshot in
                        
                        let userTarget = UserTarget(snapshot: snapshot, location: locationBack)
                        
                        Model.shared.userTargets.append(userTarget)
                        Model.shared.addBlipDelegate?.addTargetBlips(target: userTarget)
                        
                        print(uids.count)
                        
                        dG.leave()
                    })
                    
                }
                }
            )
            circleQuery.observeReady( {
                
                dG.notify(queue: .main, execute: {
                    print("\n-------observeReady-------\n ")
                    print(uids.count)
                    closure()
                    
                })

            })
        }
    }
    
    
    
    
    
    static private let coordinates: [String: CLLocation] = [
        "strandbookstore": CLLocation(latitude: 40.7332583, longitude: -73.9907914),
        "eatalyflatiron": CLLocation(latitude: 40.742164, longitude: -73.992088),
        "UnionSquareNY": CLLocation(latitude: 40.7362512, longitude: -73.9946859),
        "MadSqParkNYC": CLLocation(latitude: 40.7420411, longitude: -73.9897575),
        "TimesSquareNYC": CLLocation(latitude: 40.758899, longitude: -73.987325),
        "sunshine_cinema": CLLocation(latitude: 40.7231256, longitude: -73.9921055),
        "IrvingPlaza" : CLLocation(latitude: 40.734933, longitude: -73.990642),
        "unionfarenyc": CLLocation(latitude: 40.737899, longitude: -73.993489),
        "highlinenyc" : CLLocation(latitude: 40.7479965, longitude: -74.0069589),
        "WSPConservancy": CLLocation(latitude: 40.7308228,longitude: -73.997332),
        "RubinMuseum": CLLocation(latitude: 40.732294, longitude: -73.9998917),
        "flightclub": CLLocation(latitude: 40.7324626, longitude: -73.999618),
        "WebsterHall" : CLLocation(latitude: 40.7324626, longitude: -73.999618),
        "vanguardjazz": CLLocation(latitude: 40.7324626, longitude: -73.999618),
        "MorganLibrary": CLLocation(latitude: 40.7489914, longitude: -73.9949119),
        "TheGarden": CLLocation(latitude: 40.7505085, longitude: -73.9956327),
        "GothamComedy": CLLocation(latitude: 40.7443792, longitude: -73.9964206),
        "burger_lobster": CLLocation(latitude: 40.7399067, longitude: -73.9942959),
        "OttoPizzeria": CLLocation(latitude: 40.7321577, longitude: -73.9987826),
        "lprnyc": CLLocation(latitude: 40.7254847, longitude: -74.0078584),
        "MightyQuinnsBBQ": CLLocation(latitude: 40.7270126, longitude: -73.9851812),
        "BaohausNYC": CLLocation(latitude: 40.734478, longitude: -73.9880487),
        "thespottedpig": CLLocation(latitude: 40.7316653, longitude: -74.0085412),
        "thebeannyc": CLLocation(latitude: 40.7246695, longitude: -73.9901214),
        "UnleashedPetco": CLLocation(latitude: 40.716145, longitude: -74.012408),
        "MercuryLoungeNY": CLLocation(latitude: 40.7451645,longitude: -73.9803567),
        "FriedmansNYC": CLLocation(latitude: 40.7451998, longitude: -73.995726),
        "Tekserve": CLLocation(latitude: 40.7434809, longitude: -73.995594),
        "Almond_NYC": CLLocation(latitude: 40.740085, longitude: -73.9909449),
        "BarnJoo": CLLocation(latitude: 40.7388458, longitude: -73.9922692),
        "milkbarstore": CLLocation(latitude: 40.7319039, longitude: -73.9879422),
        "BNUnionSquareNY": CLLocation(latitude: 40.7369432, longitude: -73.9918239)
    ]
    
    
    
    
    
    static private let fakeLocations: [String] = [
        "strandbookstore",
        "eatalyflatiron",
        "UnionSquareNY",
        "MadSqParkNYC",
        "TimesSquareNYC",
        "sunshine_cinema",
        "IrvingPlaza",
        "unionfarenyc",
        "highlinenyc",
        "WSPConservancy",
        "RubinMuseum",
        "flightclub",
        "WebsterHall",
        "vanguardjazz",
        "MorganLibrary",
        "TheGarden",
        "GothamComedy",
        "burger_lobster",
        "OttoPizzeria",
        "lprnyc",
        "MightyQuinnsBBQ",
        "BaohausNYC",
        "thespottedpig",
        "thebeannyc",
        "UnleashedPetco",
        "MercuryLoungeNY",
        "FriedmansNYC",
        "Tekserve",
        "Almond_NYC",
        "BarnJoo",
        "milkbarstore",
        "BNUnionSquareNY"
    ]
    
    

    
    
    
}
