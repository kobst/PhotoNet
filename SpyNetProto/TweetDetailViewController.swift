//
//  TweetDetailViewController.swift
//  SpyNetProto
//
//  Created by Edward Han on 2/15/17.
//  Copyright © 2017 Edward Han. All rights reserved.
//

import UIKit
import MapKit

class TweetDetailViewController: UIViewController {
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var tweetLabel: UILabel!
    
    
    var tweet: TweetData {
        return (targetSprite?.target?.tweet)!
    }
    var targetSprite: TargetSprite?

    @IBAction func exit(_ sender: Any) {
        
         self.dismiss(animated: true, completion: nil)
    }
    
    
    func fillMap() {
        
        
        let userLocation = Model.shared.myLocation
        
        let destinationCoordinate = Model.shared.coordinates[tweet.senderID]
        
        let destAnnotation = MKPointAnnotation()
        destAnnotation.coordinate = (destinationCoordinate?.coordinate)!
        
        let latitude = userLocation?.coordinate.latitude
        
        let longitude = userLocation?.coordinate.longitude
        
        let lanDelta: CLLocationDegrees = 0.0005
        
        let lonDelta: CLLocationDegrees = 0.0005
        
        let span = MKCoordinateSpan(latitudeDelta: lanDelta, longitudeDelta: lonDelta)
        
        let center = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
        
        let region = MKCoordinateRegion(center: center, span: span)
        
        mapView.setRegion(region, animated: true)
        mapView.addAnnotation(destAnnotation)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

  
        nameLabel.text = tweet.senderID
//        nameLabel.text = "\(targetSprite?.position)..\(tweet.origPos).."
        let cgVersion = targetSprite?.texture!.cgImage()
        profileImage.image = UIImage(cgImage: cgVersion!)
        tweetLabel.text = tweet.message
//        tweetLabel.text = "\(targetSprite?.target?.lat)..\(targetSprite?.target?.lon)"
        
        

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
