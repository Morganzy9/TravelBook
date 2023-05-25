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
    
    
    var selectedTitle = ""
    
    var selectedNote = ""
    
    var selectedTitleId : UUID?
    
    
    
    
    var annotationTitle = ""
    var annotationNote = ""
    var annotationLatitude = Double()
    var annotationLongitude = Double()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gestureForKeyboardHidding = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        
        view.addGestureRecognizer(gestureForKeyboardHidding)
        
        
        mapDelegate()
        setUpLocation()
        
        
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(chooseLocation(gestureRecognizer: )))
        
        gestureRecognizer.minimumPressDuration = 2
        
        mapView.addGestureRecognizer(gestureRecognizer)
        
        showInDetail()
        
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
            
        
        NotificationCenter.default.post(name: NSNotification.Name("newData"), object: nil)
        
        navigationController?.popViewController(animated: true)
        
        
        
        
    }
    
    func showInDetail() {
        
        if selectedTitle != "" {
//            Get info from CoreData
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            
            let context = appDelegate.persistentContainer.viewContext
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Places")
            
            let idString = selectedTitleId!.uuidString
           
            fetchRequest.predicate = NSPredicate(format: "id = %@", idString)
            
            fetchRequest.returnsObjectsAsFaults = false
            
           
            do {
                
                let results = try context.fetch(fetchRequest)
                
                if results.count > 0 {
                    
                    for result in results as! [NSManagedObject] {
                        
                        if let title = result.value(forKey: "title") as? String {
                            
                            annotationTitle = title
                            
                            if let note = result.value(forKey: "note") as? String {
                                
                                annotationNote = note
                                
                                if let latitude = result.value(forKey: "latitude") as? Double {
                                    
                                    annotationLatitude = latitude
                                    
                                    if let longitude = result.value(forKey: "longitude") as? Double {
                                        
                                        annotationLongitude = longitude
                                        
                                        let annotaion = MKPointAnnotation()
                                        
                                        annotaion.title = annotationTitle
                                        annotaion.subtitle = annotationNote
                                        
                                        let location = CLLocationCoordinate2D(latitude: annotationLatitude, longitude: annotationLongitude)
                                        
                                        annotaion.coordinate = location
                                        
                                        mapView.addAnnotation(annotaion)
                                        
                                        titleText.text = annotationTitle
                                        noteText.text = annotationNote
                                        
//                                        MARK: when user taps to see in detail it will center not user location it center the annotation of saved place
                                        
                                        locationManager.stopUpdatingLocation()
                                        
//                                        Zoom
                                        
                                        let span =  MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                                        
//                                        Centering
                                        
                                        let region = MKCoordinateRegion(center: location, span: span)
                                        
                                        mapView.setRegion(region, animated: true)
                                        
                                        
                                    }
                                    
                                }
                                
                            }
                            
                        }
                        
                    }
                    
                }
                
                
            } catch {
                
                print("Error")
                
            }
            

            
        }else {
//            Adding new Data
            
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
    
    
    func setUpLocation() {
        
        locationManager.delegate = self
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        locationManager.requestWhenInUseAuthorization()
        
        locationManager.startUpdatingLocation()
        
    }
    
    
    /*
     locationManager function search the location of user and shows it on map
     Center it in map
     
     */
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if selectedTitle == "" {
            
            let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
            
            //        How much do i want to zoom in , in map
            //        How much the number smaller then zoom is out bigger
            
            let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            
            let region = MKCoordinateRegion(center: location, span: span)
            
            
            mapView.setRegion(region, animated: true)
            
        }
        
    }
    
}





