//
//  FaceApi.swift
//  SpyNetProto
//
//  Created by Edward Han on 2/8/17.
//  Copyright © 2017 Edward Han. All rights reserved.
//

import Foundation
//
//struct Authentication {
//    var authenticationProvider: NXOAuth2AuthenticationProvider?
//        {
//        get {
//            return NXOAuth2AuthenticationProvider.sharedAuthProvider()
//        }
//    }
//}
//
//extension Authentication {
//    /**
//     Authenticates to Microsoft Graph.
//     If a user has previously signed in before and not disconnected, silent log in
//     will take place.
//     If not, authentication will ask for credentials
//     */
//    func connectToGraph(withClientId clientId: String,
//                        scopes: [String],
//                        completion:(_ result: GraphResult<JSON, Error>) -> Void) {
//        
//        // Set client ID
//        NXOAuth2AuthenticationProvider.setClientId(clientId, scopes: scopes)
//        
//        // Try silent log in. This will attempt to sign in if there is a previous successful
//        // sign in user information.
//        if NXOAuth2AuthenticationProvider.sharedAuthProvider().loginSilent() == true {
//            completion(result: .Success(""))
//        }
//            // Otherwise, present log in controller.
//        else {
//            NXOAuth2AuthenticationProvider.sharedAuthProvider()
//                .loginWithViewController(nil) { (error: NSError?) in
//                    
//                    if let nsError = error {
//                        completion(result: .Failure(Error.UnexpectedError(nsError: nsError)))
//                    }
//                    else {
//                        completion(result: .Success(""))
//                    }
//            }
//        }
//    }
//    
//    func disconnect() {
//        NXOAuth2AuthenticationProvider.sharedAuthProvider().logout()
//    }
//    
//    func isConnected() -> Bool {
//        if NXOAuth2AuthenticationProvider.sharedAuthProvider().loginSilent() == true {
//            return true
//        }
//        else {
//            return false
//        }
//    }
//}
//
//
//
//
//
//
//
//
//static func uploadFace(faceImage: UIImage, personId: String, personGroupId: String, completion: (_ result: FaceAPIResult<JSON, Error>) -> Void) {
//    
//    let url = "https://api.projectoxford.ai/face/v1.0/persongroups/\(personGroupId)/persons/\(personId)/persistedFaces"
//    let request = NSMutableURLRequest(URL: NSURL(string: url)!)
//    
//    request.HTTPMethod = "POST"
//    request.setValue("application/octet-stream", forHTTPHeaderField: "Content-Type")
//    request.setValue(ApplicationConstants.ocpApimSubscriptionKey, forHTTPHeaderField: "Ocp-Apim-Subscription-Key")
//    
//    let pngRepresentation = UIImagePNGRepresentation(faceImage)
//    
//    let task = NSURLSession.sharedSession().uploadTaskWithRequest(request, fromData: pngRepresentation) { (data, response, error) in
//        
//        if let nsError = error {
//            completion(result: .Failure(Error.UnexpectedError(nsError: nsError)))
//        }
//        else {
//            let httpResponse = response as! NSHTTPURLResponse
//            let statusCode = httpResponse.statusCode
//            
//            do {
//                let json = try NSJSONSerialization.JSONObjectWithData(data!, options:.AllowFragments)
//                if statusCode == 200 {
//                    completion(result: .Success(json))
//                }
//            }
//            catch {
//                completion(result: .Failure(Error.JSonSerializationError))
//            }
//        }
//    }
//    task.resume()
//}
