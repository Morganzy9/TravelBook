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
    

    
    @IBOutlet var nameText: UITextField!
    
    @IBOutlet var noteText: UITextField!
    
    @IBOutlet var mapView: MKMapView!
    
    var locationManager = CLLocationManager()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapDelegate()
        managerLocation()
        
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(chooseLocation(gestureRecognizer: )))
        
        gestureRecognizer.minimumPressDuration = 2
        
        mapView.addGestureRecognizer(gestureRecognizer)
        
    }
    
    
    @objc func chooseLocation(gestureRecognizer: UILongPressGestureRecognizer) {
        
        if gestureRecognizer.state == .began {
            
            let touchedPoint = gestureRecognizer.location(in: mapView)
            
            let touchedCoordinate = mapView.convert(touchedPoint, toCoordinateFrom: mapView)
            
//           PIN :
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = touchedCoordinate
            
            annotation.title = nameText.text
            annotation.subtitle = noteText.text
            
            
            
            mapView.addAnnotation(annotation)
            
            
        }
        
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





