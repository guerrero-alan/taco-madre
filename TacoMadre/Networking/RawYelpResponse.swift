//
//  RawYelpResponse.swift
//  TacoMadre
//
//  Created by Alan Guerrero on 7/28/18.
//  Copyright © 2018 Alan Guerrero. All rights reserved.
//

import Foundation

// MARK: - RawYelpResponse

struct RawYelpResponse: Codable {
    
    struct Businesses: Codable {
        var name: String
        var categories: [Categories]
        var image_url: String
        var rating: Double
        var distance: Double
        var location: Location
        var display_phone: String
        var coordinates: Coordinates
        var phone: String
    }
    
    struct Categories: Codable {
        var alias: String
    }
    
    struct Location: Codable {
        var display_address: [String]
    }
    
    struct Coordinates: Codable {
        var latitude: Double
        var longitude: Double
    }
    var businesses: [Businesses]
}

// MARK: - Business

struct Business {
    var name: String
    var image_url: String
    var rating: Double
    var distance: Double
    var location: [String]
    var display_phone: String
    var latitude: Double
    var longitude: Double
    var phone: String
    
}
extension Business: Equatable {
    static func == (lhs: Business, rhs: Business) -> Bool {
        return lhs.name == rhs.name
    }
}

extension Business: Hashable {
    var hashValue: Int {
        return self.name.hashValue
    }
}

// MARK: - YelpServerResponse

struct YelpServerResponse: Decodable {
    var businesses: [Business] = []
    
    init(from decoder: Decoder) throws {
        let rawResponse = try RawYelpResponse(from: decoder)
        rawResponse.businesses.forEach { (shop) in
            shop.categories.forEach({ (category) in
                if category.alias == "tacos" || category.alias == "mexican" {
                    let name = shop.name
                    let image_url = shop.image_url
                    let rating = shop.rating
                    let distance = shop.distance
                    let location = shop.location.display_address
                    let display_phone = shop.display_phone
                    let latitude = shop.coordinates.latitude
                    let longitude = shop.coordinates.longitude
                    let phone = shop.phone
                    
                    businesses.append(Business(name: name, image_url: image_url, rating: rating, distance: distance, location: location, display_phone: display_phone, latitude: latitude, longitude: longitude, phone: phone ))
                }
            })
        }
    }
}
