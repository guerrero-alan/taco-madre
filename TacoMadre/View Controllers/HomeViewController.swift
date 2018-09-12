//
//  HomeViewController.swift
//  TacoMadre
//
//  Created by Alan Guerrero on 7/30/18.
//  Copyright © 2018 Alan Guerrero. All rights reserved.
//

import UIKit
import CoreLocation

var currentLocation:CLLocation!

// MARK: - HomeViewController

class HomeViewController: UIViewController {
    
    // MARK: - IBOutlets

    @IBAction func viewAsMapTouched(_ sender: UIBarButtonItem) {
        let businessMapLocationsViewController = UIStoryboard(name: "BusinessMapLocations", bundle: nil).instantiateViewController(withIdentifier: "MapLocationsStoryboard") as? BusinessMapLocationsViewController
        businessMapLocationsViewController?.shops = shops
        present(businessMapLocationsViewController!, animated: true, completion: nil)
    }
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties

    let homeViewModel = HomeViewModel()
    var shops: [Business] = [] {
        didSet {
            shops = shops.sorted(by: {$0.distance < $1.distance})
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    let locationManager = CLLocationManager()
    let imageCache = NSCache<AnyObject, AnyObject>()

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "TACO MADRE"
        tableView.dataSource = self
        tableView.delegate = self
        locationManager.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        } else {
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
    }
    
    
    func displayURLImage(of imageURL: URL, completion: @escaping (Result<UIImage>) -> Void){
        let tempUrl = imageURL
        
        if let imageFromCache = imageCache.object(forKey: imageURL as AnyObject) as? UIImage {
            //cached
            completion(.success(imageFromCache))
            return
        }
        let session = URLSession(configuration: .default)
        
        let dataTask = session.dataTask(with: imageURL) { (data, response, error) in
            if let error = error {
                print("Error downloading profile picture: \(error)")
                completion(.failure(error))
            } else if (response as? HTTPURLResponse) != nil {
                if let imageData = data {
                    guard let image = UIImage(data: imageData) else { return }
                    let imageToCache = UIImage(data: data!)
                    self.imageCache.setObject(imageToCache!, forKey: imageURL as AnyObject)
                    //noncache
                    if tempUrl == imageURL {
                        completion(.success(image))
                    } else {
                        return 
                    }
                } else {
                    print("Couldn't get image: Image is nil")
                    completion(.failure(RequestError.invalidURL))
                }
            } else {
                print("Couldn't get response code")
                completion(.failure(RequestError.invalidURL))
            }
        }
        dataTask.resume()
    }

}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Methods

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let businessDetailStoryboard = UIStoryboard(name: "BusinessDetail", bundle: nil)
        let businessDetailViewController = businessDetailStoryboard.instantiateViewController(withIdentifier: "BusinessDetailStoryboard") as? BusinessDetailViewController
        businessDetailViewController?.shop = shops[indexPath.row]
        navigationController?.pushViewController(businessDetailViewController!, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shops.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessCell", for: indexPath) as? BusinessTableViewCell else {
            return BusinessTableViewCell()
        }
        cell.selectionStyle = .none
        cell.businessNameLabel.text = shops[indexPath.row].name
        cell.businessRating.text = "Rating\n\(String(shops[indexPath.row].rating))"
        cell.businessDistance.text = "Distance: " + String(((shops[indexPath.row].distance / 1609.344)*10).rounded() / 10) + " mi"
        
        if let url = URL(string: shops[indexPath.row].image_url) {
            let tempUrl = url
            displayURLImage(of: url) { (result) in
                switch result {
                case .success(let data):
                    DispatchQueue.main.async {
                        if tempUrl == url {
                            cell.businessImageView.image = data
                        }
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
        return cell
    }
}

// MARK: - CLLocationManagerDelegate

extension HomeViewController: CLLocationManagerDelegate {
    
    // MARK: - Methods

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {        
        let location = locations[0]
        
        if currentLocation != nil {
            let distance = location.distance(from: currentLocation)
            let distanceMiles = distance / 1609
            if distanceMiles.rounded() < 1.0 { return }
        }
        
        currentLocation = location
        YelpService.shared.getBusinesses(location: location) { (result) in
            switch result {
            case .success(let data):
                if self.shops != data.businesses {
                    self.shops = data.businesses
                }
                self.locationManager.stopUpdatingLocation()
                DispatchQueue.main.async {
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
