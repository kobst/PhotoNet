//
//  Session.swift
//  SpyNetProto
//
//  Created by Edward Han on 6/27/17.
//  Copyright © 2017 Edward Han. All rights reserved.
//

import Foundation
import CoreLocation
import Firebase
import GeoFire


private let userKey = "userKey"
private let keychainServiceKey = "spyNetProto"
private let loginKey = "loginKeys"

class Session {
    
    static let sharedSession = Session()
    private init() { }
    
    let keychain = Keychain(service: keychainServiceKey).synchronizable(false)
    let ref = Database.database().reference()
    
    
    private var cachedUser: User?
    var currentUser: User?
    
    var myLocation: CLLocationCoordinate2D?
    
    func logOut() {
        cachedUser = nil
        keychain[data: userKey] = nil
        keychain[data: loginKey] = nil
    }
    
    private var currentLogin: [String: String] {
        if let data = keychain[data: loginKey],
            let dict = NSKeyedUnarchiver.unarchiveObject(with: data as Data), let validDict = dict as? [String: String] {
            return validDict
        }
        return ["email": "", "password": ""]
    }
    
    private var currentUserUid: String? {
        if let data = keychain[data: userKey], let uidData = NSKeyedUnarchiver.unarchiveObject(with: data as Data), let uid = uidData as? String  {
            return uid
        }
        let userUIDfake = "Vk8DAXariGZWyIiVdO4apcatEo73"
        return userUIDfake
//        return nil
    }
    
    
    func setCurrentUser(completion: @escaping (Bool) -> ()) {
        if let validUid = currentUserUid {
           
            UserService.fetchUser(UID: validUid) { user in
                
                Model.shared.loggedInUser = user
                self.currentUser = user
                completion(true)
            }
        }
        else {
            currentUser = nil
            completion(false)
        }
    }

    
    
    
    
    func signIn(email: String, password: String, completion: @escaping (Bool) -> Void) {
        
        UserService.signIn(email: email, password: password) {uid in
            guard let validUid = uid else {
                completion(false)
                return
            }
            
            self.keychain[data: userKey] = NSKeyedArchiver.archivedData(withRootObject: validUid)
            let emailPassword: [String: String] = ["email": email, "password": password]
            self.keychain[data: loginKey] = NSKeyedArchiver.archivedData(withRootObject: emailPassword)
            
            self.setCurrentUser() {success in
                let result = success ? true : false
                completion(result)
                
            }
            
        }
        
    }
    
    
    
    func updateMyLocation(myLocation: CLLocation) {
        let geoFire = GeoFire(firebaseRef: ref.child("user_locations"))
//        let userID = Model.shared.loggedInUser!.uid
        let uid = Session.sharedSession.currentUser?.uid
        geoFire!.setLocation(myLocation, forKey: uid) { (error) in
            //        geoFire!.setLocation(myLocation, forKey: userID) { (error) in
            if (error != nil) {
                debugPrint("An error occured: \(error.debugDescription)")
            } else {
                print("Saved location successfully!")
            }
        }
    }
    

    
}

