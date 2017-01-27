//
//  MapViewController.swift
//  SpyNetProto
//
//  Created by Edward Han on 1/27/17.
//  Copyright © 2017 Edward Han. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class MapViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager = CLLocationManager()
    
    func makeMap() {
        let latitude: CLLocationDegrees = 40
        
        let longitude: CLLocationDegrees = 90
        
        let lanDelta: CLLocationDegrees = 0.0005
        
        let lonDelta: CLLocationDegrees = 0.0005
        
        let span = MKCoordinateSpan(latitudeDelta: lanDelta, longitudeDelta: lonDelta)
        
        let center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        let region = MKCoordinateRegion(center: center, span: span)
        
         mapView.setRegion(region, animated: true)
    
        
    }
    
    
    func getLocationPermissions() {
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getLocationPermissions()
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}




extension ViewController: CLLocationManagerDelegate {
    
    
    // MARK: - location delegate
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            self.locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        print(locations.first)
    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
}
