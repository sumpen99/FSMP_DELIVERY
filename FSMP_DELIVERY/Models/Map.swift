//
//  Map.swift
//  FSMP_DELIVERY
//
//  Created by Marko Paunovic on 2023-05-18.
//

import SwiftUI
import MapKit

struct ShowMap: UIViewRepresentable {
    
    @State var userLocation: CLLocationCoordinate2D?
    @EnvironmentObject var locationViewModel : LocationSearchViewModel
    
    let destination = CLLocationCoordinate2D(latitude: 59.329, longitude: 18.068)
    let mapView = MKMapView()
    
    func makeUIView(context: Context) -> MKMapView {
        mapView.isRotateEnabled = false
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        //mapView.delegate = context.coordinator
        
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        if let coordinate = locationViewModel.selectedLocationCoordinate {
            context.coordinator.addAndSelectAnnotaion(withCoordinate: coordinate)
        }
    }
    
    func makeCoordinator() -> MapCoordinator {
        return MapCoordinator(parent: self)
    }
    
//    class Coordinator: NSObject, MKMapViewDelegate {
//        var parent: ShowMap
//
//        init(_ parent: ShowMap) {
//            self.parent = parent
//            super.init()
//        }
//
//        func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
//            parent.userLocation = userLocation.coordinate
//        }
//
//        func makeCoordinator() -> MapCoordinator {
//            return MapCoordinator(parent: self)
//        }
//    }
}

extension ShowMap {
    
    class MapCoordinator: NSObject, MKMapViewDelegate {
        
        //MARK: - Properites
        let parent: ShowMap
        
        //MARK: - Lifecycle
        init(parent: ShowMap) {
            self.parent = parent
            super.init()
        }
        
        // MARK: - MKMapViewDelegate
        
        func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
            let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
            parent.mapView.setRegion(region, animated: true)
        }
        
        //MARK: - Helpers
        func addAndSelectAnnotaion(withCoordinate coordinate: CLLocationCoordinate2D) {
            parent.mapView.removeAnnotation(parent.mapView.annotations as! MKAnnotation)
            
            let anno = MKPointAnnotation()
            anno.coordinate = coordinate
            self.parent.mapView.addAnnotation(anno)
            self.parent.mapView.selectAnnotation(anno, animated: true)
            
            parent.mapView.showAnnotations(parent.mapView.annotations, animated: true)
        }
        
    }
}
    
//    class RouteCalculator {
//
//        func calculateRoute(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D, completion: @escaping (MKRoute?, Error?) -> Void) {
//
//            let sourcePlacemark = MKPlacemark(coordinate: source)
//            let destinationPlacemark = MKPlacemark(coordinate: destination)
//
//            let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
//            let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
//
//            let request = MKDirections.Request()
//            request.source = sourceMapItem
//            request.destination = destinationMapItem
//            request.transportType = .automobile
//
//            let directions = MKDirections(request: request)
//            directions.calculate { (response, error) in
//                completion(response?.routes.first, error)
//            }
//        }
//    }
//
//     func calculateRoute() {
//        guard let userLocation = userLocation else {
//            // Handle when user location is not available
//            return
//        }
//
//        let routeCalculator = RouteCalculator()
//        routeCalculator.calculateRoute(from: userLocation, to: destination) { (route, error) in
//            if let error = error {
//                // Handle route calculation error
//                print("Error calculating route: \(error.localizedDescription)")
//            } else if let route = route {
//                // Handle the route, e.g., display it on the map
//                displayRoute(route)
//            }
//        }
//    }
//
//    private func displayRoute(_ route: MKRoute) {
//        // Add code to display the route on the map
//    }
//}

    
    
//    @Binding var userLocation: CLLocationCoordinate2D?
//
//    func updateUIView(_ uiView: MKMapView, context: Context) {
//        //
//    }
//
//    typealias UIViewType = MKMapView
//
//    func makeUIView(context: Context) -> MKMapView {
//        let mapView = MKMapView()
//        mapView.showsUserLocation = true
//        mapView.delegate = context.coordinator
//        return mapView
//    }
//
//        func route() -> MKMapView {
//            let mapView = MKMapView()
//
//            // Stockholm PLACEMARK
//            let p1 = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 59.329, longitude: 18.068))
//
//            // Göteborg PLACEMARK
//            let p2 = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 57.708, longitude: 11.974))
//
//            let request = MKDirections.Request()
//            request.source = MKMapItem(placemark: p1)
//            request.source = MKMapItem(placemark: p2)
//            request.transportType = .automobile
//
//            let directions = MKDirections(request: request)
//            directions.calculate { response, error in
//                guard let route = response?.routes.first else { return }
//                mapView.addAnnotation([p1,p2] as! MKAnnotation)
//                mapView.addOverlay(route.polyline)
//                mapView.setVisibleMapRect(route.polyline.boundingMapRect,
//                                          edgePadding: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20),
//                                          animated: true)
//            }
//            return mapView
//        }
//
//
//        func updateUIView(_ uiView: MKMapView, context: Context) {
//            //
//        }
//        return mapView
//    }

