////
////  FavoritesService.swift
////  TacoMadre
////
////  Created by Alan Guerrero on 8/7/18.
////  Copyright © 2018 Alan Guerrero. All rights reserved.
////
//
//import Foundation
//
//// MARK: - FavoritesService
//
//class FavoritesService {
//    
//    static let shared = FavoritesService()
//    
//    private var favoritesUrl: URL = {
//        let documentDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//        return documentDirectoryUrl.appendingPathComponent("favorites.json")
//    }()
//    
//    var favoriteLocations: [Location] {
//        do {
//            let data = try Data(contentsOf: favoritesUrl)
//            return try JSONDecoder().decode([Location].self, from: data)
//        } catch {
//            print(error.localizedDescription)
//        }
//        return []
//    }
//    
//    private func save(_ favoriteLocations: [Location]) {
//        do {
//            let data = try JSONEncoder().encode(favoriteLocations)
//            try data.write(to: favoritesUrl)
//        } catch {
//            print(error.localizedDescription)
//        }
//    }
//    
//    func add(_ location: Location) {
//        var favoriteLocations = self.favoriteLocations
//        favoriteLocations.append(location)
//        save(favoriteLocations)
//    }
//    
//    func remove(_ location: Location) {
//        var favoriteLocations = self.favoriteLocations
//        guard let index = favoriteLocations.index(of: location) else { return }
//        favoriteLocations.remove(at: index)
//        save(favoriteLocations)
//    }
//    
//}
