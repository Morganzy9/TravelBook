//
//  ViewController.swift
//  TravelBook
//
//  Created by Ислам Пулатов on 5/22/23.
//

import UIKit
import MapKit
import CoreLocation
import CoreData

class ViewController: UIViewController {
    
    
    
    @IBOutlet var titleText: UITextField!
    
    @IBOutlet var noteText: UITextField!
    
    @IBOutlet var mapView: MKMapView!
    
    var locationManager = CLLocationManager()
    
    var choosenLatitude = Double()
    
    var choosenLongitude = Double()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gestureForKeyboardHidding = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(gestureForKeyboardHidding)
        
        
        mapDelegate()
        managerLocation()
        
        
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(chooseLocation(gestureRecognizer: )))
        
        gestureRecognizer.minimumPressDuration = 2
        
        mapView.addGestureRecognizer(gestureRecognizer)
        
        
        
    }
    
    
    @IBAction func saveButton(_ sender: Any) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let newPlace = NSEntityDescription.insertNewObject(forEntityName: "Places", into: context)
        
        
            newPlace.setValue(titleText.text, forKey: "title")
            newPlace.setValue(noteText.text, forKey: "note")
            
            newPlace.setValue(choosenLatitude, forKey: "latitude")
            newPlace.setValue(choosenLongitude, forKey: "longitude")
            newPlace.setValue(UUID(), forKey: "id")
            
            
        if titleText.text != "" && noteText.text != "" {
            
            do {
                
                try context.save()
                
                print("Saved")
                
            } catch {
                print("Error")
            }
            
        }
            
        
        
       
        
        
        
        
    }
    
    
    @objc func chooseLocation(gestureRecognizer: UILongPressGestureRecognizer) {
        
        if gestureRecognizer.state == .began {
            
            let touchedPoint = gestureRecognizer.location(in: mapView)
            
            let touchedCoordinate = mapView.convert(touchedPoint, toCoordinateFrom: mapView)
            
            choosenLatitude = touchedCoordinate.latitude
            
            choosenLongitude = touchedCoordinate.longitude
            
            
            //           PIN  ON MAP:
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = touchedCoordinate
            
            annotation.title = titleText.text
            annotation.subtitle = noteText.text
            
            
            
            mapView.addAnnotation(annotation)
            
            
        }
        
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
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





