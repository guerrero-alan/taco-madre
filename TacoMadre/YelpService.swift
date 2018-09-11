//
//  YelpService.swift
//  TacoMadre
//
//  Created by Alan Guerrero on 7/27/18.
//  Copyright © 2018 Alan Guerrero. All rights reserved.
//

import Foundation

struct AuthenticationConstants {
    static let apiKey = "JMlNZOpvef-cyoKfEGHOQgq5MpbxOdK9crlZCmX1lJXjge1LP2nHuBkEc4ny6CXp6Uegthj19U9WM6l8jOQ9d8ou9gcGZx2esRh-XG3Pt9zUj7CIBLhakedGLbwIWXYx"
    static let term = "taco"
}

final class YelpService {
    static let shared = YelpService()
    
    private init() {
        
    }
    
    func setupYelp() {
        
    }
    
    func getBusinesses() {
        let path = "https://api.yelp.com/v3/businesses/search"
        let authorization = "Bearer \(AuthenticationConstants.apiKey)"
        let headers = ["Content-Type": "application/json", "Authorization": authorization]
        
        
    }
}
