//
//  LocationManager.swift
//  FSMP_DELIVERY
//
//  Created by Marko Paunovic on 2023-05-18.
//

import MapKit
import CoreLocation
    
final class LocationManager: NSObject, CLLocationManagerDelegate, ObservableObject {
    
    @Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 62.390, longitude: 17.306), span: MKCoordinateSpan(latitudeDelta: 15, longitudeDelta: 15))
    
    var locationManager: CLLocationManager?
    
    var p1 = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 59.329, longitude: 18.068))
    
    // Göteborg PLACEMARK
    var p2 = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 57.708, longitude: 11.974))
    
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
    
    func route() -> MKMapView {
        let mapView = MKMapView()
        
        // Stockholm PLACEMARK
        let p1 = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 59.329, longitude: 18.068))
        
        // Göteborg PLACEMARK
        let p2 = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 57.708, longitude: 11.974))
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: p1)
        request.source = MKMapItem(placemark: p2)
        request.transportType = .automobile
        
        let directions = MKDirections(request: request)
        directions.calculate { response, error in
            guard let route = response?.routes.first else { return }
            mapView.addAnnotation([p1,p2] as! MKAnnotation)
            mapView.addOverlay(route.polyline)
            mapView.setVisibleMapRect(route.polyline.boundingMapRect,
            edgePadding: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20),
            animated: true)
        }
        return mapView
    }
    
//    func updateUIView(_ uiView: MKMapView, context: Context) {
//        directions()
//    }
}
