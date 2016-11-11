
//
//  MapViewController.swift
//  PeopleMon
//
//  Created by Brett Keck on 8/17/16.
//  Copyright © 2016 Eleven Fifty. All rights reserved.
//
import UIKit
import MapKit

class MapViewController: UIViewController, SegueHandlerType {
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    let latitudeDelta = 0.005
    let longitudeDelta = 0.005
    
    var annotations: [MapPin] = []
    var overlay: MKOverlay?
    var firstLocation = true
    
    var timer: Timer?
    
    enum SegueIdentifier: String {
        case PresentLoginNoAnimation
        case PresentLogin
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        mapView.showsUserLocation = true
        mapView.isZoomEnabled = false
        mapView.isScrollEnabled = false
        locationManager.startUpdatingLocation()
        
        mapView.delegate = self
        
        UserStore.shared.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if !WebServices.shared.userAuthTokenExists() || WebServices.shared.userAuthTokenExpired() {
            performSegueWithIdentifier(segueIdentifier: .PresentLoginNoAnimation, sender: self)
        } else {
            let infoUser = Account()
            WebServices.shared.getObject(infoUser, completion: { (user, error) in
                if let user = user {
                    UserStore.shared.user = user
                }
            })
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
        stopTimer()
    }
    
    func loadMap() {
        if let coordinate = locationManager.location?.coordinate {
            let checkIn = User(coordinate: coordinate)
            WebServices.shared.postObject(checkIn, completion: { (object, error) in
                
            })
        }
        
        let nearby = User(radiusInMeters: Constants.radiusInMeters)
        WebServices.shared.getObjects(nearby) { (objects, error) in
            if let objects = objects {
                let oldAnnotations = self.annotations
                self.annotations = []
                for person in objects {
                    let pin = MapPin(person: person)
                    self.annotations.append(pin)
                }
                self.mapView.addAnnotations(self.annotations)
                self.mapView.removeAnnotations(oldAnnotations)
            }
        }
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(loadMap), userInfo: nil, repeats: true)
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    
    // MARK: - IBActions
    @IBAction func logout(sender: AnyObject) {
        UserStore.shared.logout {
            self.performSegueWithIdentifier(segueIdentifier: .PresentLogin, sender: self)
        }
    }
}

// MARK: - CLLocationManagerDelegate
extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last!
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpanMake(latitudeDelta, longitudeDelta))
        
        self.mapView.setRegion(region, animated: true)
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
            pinView!.canShowCallout = false
            pinView!.animatesDrop = false
        } else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let mapPin = view.annotation as? MapPin, let person = mapPin.person, let name = person.userName, let userId = person.userId {
            let alert = UIAlertController(title: "Catch User", message: "Catch \(name)?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Catch", style: .default, handler: { (action) in
                let catchPerson = User(caughtUserId: userId, radiusInMeters: Constants.radiusInMeters)
                WebServices.shared.postObject(catchPerson, completion: { (object, error) in
                    if let error = error {
                        self.present(Utils.createAlert(message: error), animated: true, completion: nil)
                    } else {
                        self.present(Utils.createAlert(title: "Congrats", message: "\(name) Caught"), animated: true, completion: nil)
                    }
                })
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        self.overlay = overlay
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 5.0
        renderer.lineCap = CGLineCap.round
        return renderer
    }
}

// MARK: - UserStoreDelegate
extension MapViewController: UserStoreDelegate {
    func userLoggedIn() {
        NotificationCenter.default.addObserver(self, selector: #selector(stopTimer), name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(startTimer), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        stopTimer()
        startTimer()
    }
}











////
////  MapViewController.swift
////  PeopleMon
////
////  Created by Christopher Stanley on 11/8/16.
////  Copyright © 2016 Christopher Stanley. All rights reserved.
////
//
//import UIKit
//import MapKit
//import CoreLocation
//
//class MapViewController: UIViewController {
//
//    
//
//    
//    @IBOutlet weak var mapView: MKMapView!
//    
//    var locationManager: CLLocationManager!
//    var userLocation: CLLocationCoordinate2D! {
//        didSet {
//            print("Coordinates have been changed")
//            mapView.setCenter(userLocation, animated: true)
//        }
//    }
//    var latitudeDelta = 0.002
//    var longitudeDelta = 0.002
//    var updatingLocation = true
//    var annotations: [MapPin] = []
//    var overlay: MKOverlay?
//
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        if (CLLocationManager.locationServicesEnabled()) {
//            locationManager = CLLocationManager()
//            locationManager.delegate = self
//            locationManager.desiredAccuracy = kCLLocationAccuracyBest
//            locationManager.requestAlwaysAuthorization()
//            locationManager.startUpdatingLocation()
//            locationManager.distanceFilter = kCLDistanceFilterNone
//            mapView.showsUserLocation = true
//            locationManager.startUpdatingLocation()
//            
//            mapView.delegate = self
////            UserStore.shared.delegate = self
//            
//        }
//    }
//
//    
//        
//
//        // Do any additional setup after loading the view.
//    
//
//    
//  
//    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        if !WebServices.shared.userAuthTokenExists() || WebServices.shared.userAuthTokenExpired() {
//            
//            performSegue(withIdentifier: "PresentLoginNoAnimation", sender: self)
//        } else {
//            let infoUser = Account()
//            WebServices.shared.getObject(infoUser, completion: { (user, error) in
//                if let user = user {
//                    UserStore.shared.user = user
//                }
//            })
//        }
//    }
//    
//    func loadMap() {
//        if let coordinate = locationManager.location?.coordinate {
//            let checkIn = User(coordinate: coordinate)
//            WebServices.shared.postObject(checkIn, completion: { (object, error) in
//                
//            })
//        }
//       
//        let nearby = User(radiusInMeters: Constants.radiusInMeters)
//        WebServices.shared.getObjects(nearby) { (objects, error) in
//            if let objects = objects {
//                let oldAnnotations = self.annotations
//                self.annotations = []
//                for person in objects {
//                    let pin = MapPin(person: person)
//                    self.annotations.append(pin)
//                }
//                self.mapView.addAnnotations(self.annotations)
//                self.mapView.removeAnnotations(oldAnnotations)
//            }
//        }
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    
//    
//
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//    }
//    */
//
//}
//
//// MARK: - CLLocationManagerDelegate
//extension MapViewController: CLLocationManagerDelegate {
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        let location = locations.last!
//        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
//        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpanMake(latitudeDelta, longitudeDelta))
//        mapView.setRegion(region, animated: true)
//        updatingLocation = false
//        locationManager.stopUpdatingLocation()
//    }
//}
//
//
//// MARK: - MKMapViewDelegate
//extension MapViewController: MKMapViewDelegate {
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        if annotation is MKUserLocation {
//            return nil
//        }
//        
//        let reuseId = "pin"
//        
//        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
//        if pinView == nil {
//            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
//            pinView!.canShowCallout = false
//            pinView!.animatesDrop = false
//        } else {
//            pinView!.annotation = annotation
//        }
//        
//        return pinView
//    }
//    
//    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
//        if let mapPin = view.annotation as? MapPin, let person = mapPin.person, let name = person.userName, let userId = person.userId {
//            let alert = UIAlertController(title: "Catch User", message: "Catch \(name)?", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "Catch", style: .default, handler: { (action) in
//                let catchPerson = User(caughtUserId: userId, radiusInMeters: Constants.radiusInMeters)
//                WebServices.shared.postObject(catchPerson, completion: { (object, error) in
//                    if let error = error {
//                        self.present(Utils.createAlert(message: error), animated: true, completion: nil)
//                    } else {
//                        self.present(Utils.createAlert(message: "User Caught"), animated: true, completion: nil)
//                    }
//                })
//            }))
//            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//            self.present(alert, animated: true, completion: nil)
//        }
//    }
//    
//    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
//        self.overlay = overlay
//        let renderer = MKPolylineRenderer(overlay: overlay)
//        renderer.strokeColor = UIColor.blue
//        renderer.lineWidth = 5.0
//        renderer.lineCap = CGLineCap.round
//        return renderer
//    }
//}
//
////// MARK: - UserStoreDelegate
////extension MapViewController: UserStoreDelegate {
////    func userLoggedIn() {
////        NotificationCenter.default.addObserver(self, selector: #selector(stopTimer), name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
////        NotificationCenter.default.addObserver(self, selector: #selector(startTimer), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
////        stopTimer()
////        startTimer()
////    }
////}
//
//
////// MARK: - MKMapViewDelegate
////extension MapViewController: MKMapViewDelegate {
////    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
////        if annotation is MKUserLocation {
////            return nil
////        }
////        
////        let reuseId = "pin"
////        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
////        if pinView == nil {
////            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
////            pinView!.canShowCallout = true
////            pinView!.animatesDrop = true
////            
////            let leftButton = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
////            leftButton.setImage(#imageLiteral(resourceName: "info"), for: .normal)
////            pinView!.leftCalloutAccessoryView = leftButton
////            
////            let rightButton = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
////            rightButton.setImage(#imageLiteral(resourceName: "directions"), for: .normal)
////            pinView!.rightCalloutAccessoryView = rightButton
////            
////           
////            
////            
////        } else {
////            pinView!.annotation = annotation
////        }
////        
////        return pinView
////    }
////    
////    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
////        self.overlay = overlay
////        let renderer = MKPolylineRenderer(overlay: overlay)
////        renderer.strokeColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
////        renderer.lineWidth = 5.0
////        renderer.lineCap = .round
////        return renderer
////    }
////}
//
//
//
//
//
//
