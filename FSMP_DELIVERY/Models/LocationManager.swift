//
//  LocationManager.swift
//  FSMP_DELIVERY
//
//  Created by Marko Paunovic on 2023-05-18.
//

import MapKit
import SwiftUI
import CoreLocation
    
final class LocationManager: NSObject, CLLocationManagerDelegate, ObservableObject, MKMapViewDelegate {
    
    //private var locationManager = CLLocationManager()
    
    // Region
    @Published var region : MKCoordinateRegion!
    
    // MapView
    @Published var mapView = MKMapView()
    
    // Map Type
    //@Published private var elevationStyle: MKMapConfiguration.ElevationStyle = .flat
    @Published var mapType: MKMapType = .standard
    
    // LocationManager
    var locationManager: CLLocationManager?
    
    // Updating Map Type
    func toggleMapType() {
        if mapType == .standard {
            mapType = .hybrid
            print("DEBUG: mapType is HYBRID")
        } else {
            mapType = .standard
            print("DEBUG: mapType is STANDARD")
        }
    }
    
    // Focusing users current Location
    func focusLocation() {
        guard let _ = region else {return}
            
            mapView.setRegion(region, animated: true)
            mapView.setVisibleMapRect(mapView.visibleMapRect, animated: true)
        print("DEBUG: focusing current location \(mapView.showsUserLocation)")
    }
    
    // Checks for the user permission for current location
    func checkIfLocationServicesIsEnabled() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager?.delegate = self
        } else {
            print("Show alert to let them know this is off and go to turn on")
        }
    }
    
    private func checkLocationAuthorization() {
        guard let locationManager = locationManager else { return }
        
        switch locationManager.authorizationStatus {
            
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            print("Location is restricted likely due to parental controls.")
        case .denied:
            print("You have denied this app location permission. Go to settins to change it.")
        case .authorizedAlways, .authorizedWhenInUse:
            region = MKCoordinateRegion(center: locationManager.location!.coordinate,
                                        span: MKCoordinateSpan(latitudeDelta: 15, longitudeDelta: 15))
        @unknown default:
            break
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
}
