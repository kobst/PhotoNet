//
//  Model.swift
//  SpyNetProto
//
//  Created by Edward Han on 1/27/17.
//  Copyright © 2017 Edward Han. All rights reserved.
//

import Foundation
import FirebaseStorage
import Firebase
import CoreLocation
import GeoFire


class Model {
    
    static var shared = Model()

    private init(){}
    
    var loggedInUser: User?
    var queryTargets: [User] = []
    
    let ref = FIRDatabase.database().reference()
    let geoFire = GeoFire(firebaseRef: FIRDatabase.database().reference(withPath: "user_locations"))

    
    func fetchUser(UID: String, completionHandler: @escaping (User) -> ()){
        
        ref.child("users").child(UID).observeSingleEvent(of: .value, with: { (snapshot) in
            let newUser = User(snapshot: snapshot)
            completionHandler(newUser)
        })
        
    }
    
    
    func makeFakeLocation() -> CLLocation {
        
        
        let count = fakeLocations.count - 1
        let random = Int(arc4random()) % count
        let key = fakeLocations[random]
        return coordinates[key]!

    }
    
    func updateMyLocation(myLocation: CLLocation) {
        
        
        let userID = Model.shared.loggedInUser!.uid
        let fakeLocation = makeFakeLocation()
        geoFire!.setLocation(fakeLocation, forKey: userID) { (error) in
//        geoFire!.setLocation(myLocation, forKey: userID) { (error) in
            if (error != nil) {
                debugPrint("An error occured: \(error)")
            } else {
                print("Saved location successfully!")
            }
        }
        
        
        
        
    }
    
    
    
    func getTargets(myLocation: CLLocation){
        //Query GeoFire for nearby users
        //Set up query parameters

        var keys = [String]()
        var locations = [CLLocation]()
        let circleQuery = geoFire?.query(at: myLocation, withRadius: 50)
        
        print("Before Geoquery")
        
        circleQuery?.observe(.keyEntered, with: {(string, location) in
        
            if let stringBack = string, let locationBack = location {
                keys.append(stringBack)
                locations.append(locationBack)
                print(stringBack)
            }
            
            
        
    })
          

    }
    
    
    
    
    
    
    let coordinates: [String: CLLocation] = [
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
    
    

    
    
    let fakeLocations: [String] = [
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

class User {
    
    
    var uid: String
    var name: String
    var avatar: String
    var blurb: String
    
    init(uid: String) {
        self.uid = uid
        name = ""
        avatar = ""
        blurb = ""
    }
    
    init(snapshot: FIRDataSnapshot) {
        let value = snapshot.value as! [String: Any]!
        uid = snapshot.key 
        avatar = value?["avatar"] as? String ?? ""
        blurb = value?["blurb"] as? String ?? ""
        name = value?["name"] as? String ?? ""
        
    }
    
}
