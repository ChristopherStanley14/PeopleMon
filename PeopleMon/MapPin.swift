//
//  MapPin.swift
//  Map
//
//  Created by Christopher Stanley on 10/20/16.
//  Copyright © 2016 Christopher Stanley. All rights reserved.
//

import UIKit
import MapKit

class MapPin: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var person: User?
    
    init(person: User) {
        self.person = person
        if let lat = person.latitude, let long = person.longitude {
            self.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        } else {
            self.coordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
        }
    }
}
