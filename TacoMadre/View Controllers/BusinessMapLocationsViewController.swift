//
//  BusinessMapLocationsViewController.swift
//  TacoMadre
//
//  Created by Alan Guerrero on 8/3/18.
//  Copyright © 2018 Alan Guerrero. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import AddressBook

// MARK: - BusinessMapLocationsViewController

class BusinessMapLocationsViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    // MARK: - IBOutlets

    @IBAction func backButtonTouched(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: - Properties

    var shops: [Business]!
    let locationManager = CLLocationManager()
    private let regionRadius: CLLocationDistance = 1000
    
    // MARK: - Life Cycle

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapView.showsUserLocation = true
            locationManager.startUpdatingLocation()
        } else {
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        zoomMapOn(location: CLLocation(latitude: shops[0].latitude, longitude: shops[0].longitude))
        mapView.delegate = self
        
        for shop in shops {
            print(shop.name)
            let annotation = MKPointAnnotation()
            annotation.title = shop.name
            annotation.coordinate = CLLocationCoordinate2D(latitude: shop.latitude, longitude: shop.longitude)
            annotation.subtitle = shop.location[0]
            mapView.addAnnotation(annotation)
        }
    }

    // MARK: - Methods
    
    func simulate() {
        let span: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        let userLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake(shops[0].latitude, shops[0].longitude)
        let region: MKCoordinateRegion = MKCoordinateRegionMake(userLocation, span)
        
        mapView.setRegion(region, animated: true)
        self.mapView.showsUserLocation = true
    }
    
    func zoomMapOn(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "pin"
        var view: MKMarkerAnnotationView
        if annotation.coordinate.latitude == mapView.userLocation.coordinate.latitude &&
            annotation.coordinate.longitude == mapView.userLocation.coordinate.longitude {
            return nil
        }
        if let dequedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView {
            dequedView.annotation = annotation
            view = dequedView
        } else {
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset  = CGPoint(x: -20, y: 20)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            view.leftCalloutAccessoryView = UIButton(type: .contactAdd)
        }
        return view
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let location = view.annotation else { return }
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)))
        mapItem.name = location.title!
        mapItem.openInMaps(launchOptions: launchOptions)
    }
}
