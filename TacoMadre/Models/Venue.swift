//
//  Venue.swift
//  TacoMadre
//
//  Created by Alan Guerrero on 8/4/18.
//  Copyright © 2018 Alan Guerrero. All rights reserved.
//

import Foundation
import MapKit
import AddressBook

// MARK: - Venue

class Venue: NSObject, MKAnnotation {
    
    // MARK: - Properties

    let title: String?
    let locationName: String?
    let coordinate: CLLocationCoordinate2D
    
    var subtitle: String? {
        return locationName
    }
    
    // MARK: - Initializers

    init(title: String?, locationName: String?, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.locationName = locationName
        self.coordinate = coordinate
        
        super.init()
    }
}
