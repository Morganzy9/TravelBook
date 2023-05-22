//
//  ViewController.swift
//  TravelBook
//
//  Created by Ислам Пулатов on 5/22/23.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController {
    

    @IBOutlet var mapView: MKMapView!
    
    var locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapDelegate()
        managerLocation()
        
        
    }
    
    
    
    

}


//  MARK: - Extensions

extension ViewController : MKMapViewDelegate {
    
    func mapDelegate() {
        mapView.delegate = self
    }
    
    
    
}

extension ViewController : CLLocationManagerDelegate {
    
    
    func managerLocation() {
        
        locationManager.delegate = self
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        locationManager.requestWhenInUseAuthorization()
        
        locationManager.startUpdatingLocation()
        
    }
    
    
/*
        locationManager function search the location of user and shows it on map
 
 
 */

    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        
//        How much do i want to zoom in , in map
//        How much the number smaller then zoom is out bigger
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        
        let region = MKCoordinateRegion(center: location, span: span)
        
        
        mapView.setRegion(region, animated: true)
        
    }
    
}





