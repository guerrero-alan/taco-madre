//
//  HomeViewController.swift
//  TacoMadre
//
//  Created by Alan Guerrero on 7/30/18.
//  Copyright © 2018 Alan Guerrero. All rights reserved.
//

import UIKit
import CoreLocation

// MARK: - HomeViewController

class HomeViewController: UIViewController {
    
    // MARK: - IBOutlets

    @IBAction func viewAsMapTouched(_ sender: UIBarButtonItem) {
        let businessMapLocationsViewController = UIStoryboard(name: "BusinessMapLocations", bundle: nil).instantiateViewController(withIdentifier: "MapLocationsStoryboard") as? BusinessMapLocationsViewController
        businessMapLocationsViewController?.shops = homeViewModel.shops
        present(businessMapLocationsViewController!, animated: true, completion: nil)
    }
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties

    let homeViewModel = HomeViewModel()
    let locationManager = CLLocationManager()
   

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
        businessDetailViewController?.shop = homeViewModel.shops[indexPath.row]
        navigationController?.pushViewController(businessDetailViewController!, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homeViewModel.shops.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessCell", for: indexPath) as? BusinessTableViewCell else {
            return BusinessTableViewCell()
        }
        cell.imageCache = homeViewModel.imageCache
        cell.updateCell(business: homeViewModel.shops[indexPath.row])
        return cell
    }
}

// MARK: - CLLocationManagerDelegate

extension HomeViewController: CLLocationManagerDelegate {
    
    // MARK: - Methods

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        if !homeViewModel.isOneMileAway(from: location) { return }
        homeViewModel.pastLocation = location
        
        homeViewModel.getBusinesses(location: location) { (result) in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                self.locationManager.stopUpdatingLocation()
            case .failure(let error):
                print(error)
            }
        }
    }
}
