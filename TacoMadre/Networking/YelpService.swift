//
//  YelpService.swift
//  TacoMadre
//
//  Created by Alan Guerrero on 7/27/18.
//  Copyright © 2018 Alan Guerrero. All rights reserved.
//

import Foundation
import CoreLocation

// MARK: - AuthenticationConstants

struct AuthenticationConstants {
    static let apiKey = "JMlNZOpvef-cyoKfEGHOQgq5MpbxOdK9crlZCmX1lJXjge1LP2nHuBkEc4ny6CXp6Uegthj19U9WM6l8jOQ9d8ou9gcGZx2esRh-XG3Pt9zUj7CIBLhakedGLbwIWXYx"
    static let term = "taco"
}

// MARK: - YelpService

final class YelpService {
    
    // MARK: - Properties

    static let shared = YelpService()
    
    // MARK: - Methods

    func getBusinesses(location: CLLocation, completion: @escaping (Result<YelpServerResponse>) -> Void) {
        let path = "https://api.yelp.com/v3/businesses/search?term=taco&latitude=\(location.coordinate.latitude)&longitude=\(location.coordinate.longitude)&radius=10000"
        let authorization = "Bearer \(AuthenticationConstants.apiKey)"
        let headers = ["Content-Type": "application/json", "Authorization": authorization]
        
        HTTPRequestManager(path: path, method: .get, headers: headers).getBusinesses { (result) in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
