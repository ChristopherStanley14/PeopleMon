//
//  MapViewController.swift
//  PeopleMon
//
//  Created by Christopher Stanley on 11/8/16.
//  Copyright © 2016 Christopher Stanley. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {

    

    
    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager: CLLocationManager!
    var userLocation: CLLocationCoordinate2D! {
        didSet {
            print("Coordinates have been changed")
            mapView.setCenter(userLocation, animated: true)
        }
    }
    var latitudeDelta = 0.002
    var longitudeDelta = 0.002
    var updatingLocation = true
    var annotations: [MapPin] = []

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
            locationManager.distanceFilter = kCLDistanceFilterNone
            mapView.showsUserLocation = true
            
        }
    }

    
        

        // Do any additional setup after loading the view.
    

    
  
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !WebServices.shared.userAuthTokenExists() || WebServices.shared.userAuthTokenExpired() {
            
            performSegue(withIdentifier: "PresentLoginNoAnimation", sender: self)
        }
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

// MARK: - CLLocationManagerDelegate
extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last!
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpanMake(latitudeDelta, longitudeDelta))
        mapView.setRegion(region, animated: true)
        updatingLocation = true
    }
}

// MARK: - MKMapViewDelegate
extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.animatesDrop = true
            
            let leftButton = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
            leftButton.setImage(#imageLiteral(resourceName: "info"), for: .normal)
            pinView!.leftCalloutAccessoryView = leftButton
            
            let rightButton = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
            rightButton.setImage(#imageLiteral(resourceName: "directions"), for: .normal)
            pinView!.rightCalloutAccessoryView = rightButton
        } else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
}






