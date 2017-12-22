//
//  UserService.swift
//  SpyNetProto
//
//  Created by Edward Han on 7/3/17.
//  Copyright © 2017 Edward Han. All rights reserved.
//

import Foundation
import CoreLocation
import Firebase
import GeoFire


private let userKey = "userKey"
private let keychainServiceKey = "spyNetProto"
private let loginKey = "loginKeys"


class UserService {
    
    let keychain = Keychain(service: keychainServiceKey).synchronizable(false)
    static let ref = Database.database().reference()
    
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
    
    
    
    static func fetchUser(UID: String, completionHandler: @escaping (User?) -> ()){
        ref.child("users").child(UID).observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists() {
                let newUser = User(snapshot: snapshot)
                completionHandler(newUser)
            }
            else {
                completionHandler(nil)
            }
        })
    }
    
    
    static func signIn(email: String, password: String, completion: @escaping (String?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { user, error in
            guard let validUser = user else {
                completion(nil)
                return
            }
            completion(validUser.uid)
        }
    }
    
    
}
