//
//  LocationManager.swift
//  FSMP_DELIVERY
//
//  Created by Marko Paunovic on 2023-05-18.
//

import UIKit
import MapKit
import CoreLocation
    
final class LocationManager: NSObject, CLLocationManagerDelegate, ObservableObject {
    
    @Published var region = MKCoordinateRegion()
    var manager = CLLocationManager()
    var locationManager: CLLocationManager?
    
    func locationRegion() {
        
        region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 62.390, longitude: 17.306), span: MKCoordinateSpan(latitudeDelta: 15, longitudeDelta: 15))
    }
    
    func checkIfLocationServiecesIsEnable() {
        if CLLocationManager.locationServicesEnabled() {
            manager = CLLocationManager()
            checkLocationAuthorization()
        }
    }
    
    func checkLocationAuthorization() {
        guard let locationManager = locationManager else { return }
        
        switch locationManager.authorizationStatus {
            
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            print("Location is restricted likely due to parental controls.")
        case .denied:
            print("You have denied this app location permission. Go to settins to change it.")
        case .authorizedAlways, .authorizedWhenInUse:
            break
        @unknown default:
            break
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        //
    }
}
