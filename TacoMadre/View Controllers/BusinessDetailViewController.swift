//
//  BusinessDetailViewController.swift
//  TacoMadre
//
//  Created by Alan Guerrero on 8/2/18.
//  Copyright © 2018 Alan Guerrero. All rights reserved.
//

import UIKit
import MapKit

// MARK: - BusinessDetailViewController

class BusinessDetailViewController: UIViewController, MKMapViewDelegate {
    
    // MARK: - IBOutlets

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var businessPhoneNumber: UILabel!
    @IBOutlet weak var businessAddress: UILabel!
    @IBOutlet weak var businessLocation: UILabel!
    @IBAction func directionsButtonTouched(_ sender: UIButton) {
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: shop.latitude, longitude: shop.longitude)))
        mapItem.name = shop.name
        mapItem.openInMaps(launchOptions: launchOptions)
    }
    @IBAction func callButtonTouched(_ sender: UIButton) {
        guard let number = URL(string: "telprompt://\(shop.phone)") else { return }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(number)
        } else {
            // Fallback on earlier versions
            UIApplication.shared.openURL(number)
        }
    }
    
    // MARK: - Properties

    var shop: Business!
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: shop.latitude, longitude: shop.longitude)
        annotation.title = shop.name
        mapView.addAnnotation(annotation)
       
        let locationCoordinate2D = CLLocationCoordinate2D(latitude: shop.latitude, longitude: shop.longitude)
        mapView.setCenter(locationCoordinate2D, animated: false)
        let coordinateSpan = MKCoordinateSpan(latitudeDelta: 0.002 , longitudeDelta: 0.002)
        let coordinateRegion = MKCoordinateRegion(center: locationCoordinate2D, span: coordinateSpan)
        
        mapView.setRegion(coordinateRegion, animated: false)
        businessAddress.text = shop.location[0]
        businessLocation.text = shop.location[1]
        businessPhoneNumber.text = shop.display_phone
    }
    
    // MARK: - Methods

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let location = view.annotation else { return }
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)))
        mapItem.name = location.title!
        mapItem.openInMaps(launchOptions: launchOptions)
    }
}
