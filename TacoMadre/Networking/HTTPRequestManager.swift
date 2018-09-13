//
//  HTTPRequestManager.swift
//  TacoMadre
//
//  Created by Alan Guerrero on 7/28/18.
//  Copyright © 2018 Alan Guerrero. All rights reserved.
//

import Foundation

enum NetworkMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

public enum Result<T> {
    case success(T)
    case failure(Error)
}

enum RequestError: Error {
    case invalidDate
    case requestHandlerNil
    case invalidURL
    case noResponse
    case httpResponse(Int)
    case retryAfter(String)
    case noData
    case noSongData
    case decoderFailure
}

extension RequestError: CustomStringConvertible {
    var description: String {
        switch self {
        case .invalidDate:
            return "Invalid Date"
        case .requestHandlerNil:
            return "No Request Handler"
        case .invalidURL:
            return "Invalid URL"
        case .noResponse:
            return "No Response"
        case .httpResponse(let errorCode):
            return "HTTP Response: \(errorCode)"
        case .retryAfter(let time):
            return time
        case .noData:
            return "No Data Returned"
        case .noSongData:
            return "No songs available for artist"
        case .decoderFailure:
            return "JSONDecoder failed to generate model"
        }
    }
}

struct HTTPRequestManager {
    var path: String
    var method: NetworkMethod
    var headers: [String: String]?
    
    func getBusinesses(completion: @escaping (Result<YelpServerResponse>)-> Void) {
        let path = self.path
        let method = self.method
        let headers = self.headers
        
        guard let url = URL(string: path) else {
            completion(.failure(RequestError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        if let headers = headers {
            for(key, value) in headers {
                request.addValue(value, forHTTPHeaderField: key)
            }
        }
        
        let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
            }
            
            guard let response = response as? HTTPURLResponse else {
                completion(.failure(RequestError.noResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(RequestError.noData))
                return
            }
            
            do {
                let rawResult = try JSONDecoder().decode(YelpServerResponse.self, from: data)
                completion(.success(rawResult))
            } catch {
                completion(.failure(RequestError.decoderFailure))                
            }
        }
        dataTask.resume()
    }
}
