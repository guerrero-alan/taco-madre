//
//  HomeViewModel.swift
//  TacoMadre
//
//  Created by Alan Guerrero on 9/11/18.
//  Copyright © 2018 Alan Guerrero. All rights reserved.
//

import Foundation
import CoreLocation

// MARK: - HomeViewModel

class HomeViewModel {
    
    // MARK: - Properties

    var pastLocation:CLLocation!
    let imageCache = NSCache<AnyObject, AnyObject>()
    var shops: [Business] = [] {
        didSet {
            shops = shops.sorted(by: {$0.distance < $1.distance})
        }
    }
    
    // MARK: - Methods

    func getBusinesses(location: CLLocation, completion: @escaping (Result<Bool>) -> Void) {
        YelpService.shared.getBusinesses(location: location) { (result) in
            switch result {
            case .success(let data):
                self.shops = data.businesses
                completion(.success(true))
            case .failure(let error):
                completion(.failure(error))
                print(error)
            }
        }
    }
    
    func isOneMileAway(from currentLocation: CLLocation) -> Bool {
        if let pastLocation = pastLocation {
            let distance = currentLocation.distance(from: pastLocation)
            let distanceMiles = distance / 1609
            if distanceMiles.rounded() < 1.0 { return false }
        }
        return true
    }
}
