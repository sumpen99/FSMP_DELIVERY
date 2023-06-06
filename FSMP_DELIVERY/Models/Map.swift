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
    @Binding var mapState: MapViewState
    
    let destination = CLLocationCoordinate2D(latitude: 59.329, longitude: 18.068)
    let mapView = MKMapView()
    
    func makeUIView(context: Context) -> MKMapView {
        mapView.isRotateEnabled = false
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        mapView.delegate = context.coordinator
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        print("DEBUG: Map state is \(mapState)")
        switch mapState {
        case .noInput:
            context.coordinator.clearMapViewAndRecenterUserLocation()
            break
        case .searchingForLocation:
            break
        case .locationSelected:
            if let coordinate = locationViewModel.selectedLocationCoordinate {
                print("DEBUG: Coordinate is \(coordinate)")
                context.coordinator.configurePolyline(withDestinationCoordinate: coordinate)
                context.coordinator.addAndSelectAnnotaion(withCoordinate: coordinate)
            }
        }
        uiView.mapType = mapView.mapType
    }
    
    func makeCoordinator() -> MapCoordinator {
        return MapCoordinator(parent: self)
    }
}

extension ShowMap {
    
    class MapCoordinator: NSObject, MKMapViewDelegate {
        
        //MARK: - Properites
        let parent: ShowMap
        var userLocationCoordinate: CLLocationCoordinate2D?
        var currentRegion: MKCoordinateRegion?
        
        //MARK: - Lifecycle
        init(parent: ShowMap) {
            self.parent = parent
            super.init()
        }
        
        // MARK: - MKMapViewDelegate
        
        func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
            self.userLocationCoordinate = userLocation.coordinate
            let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            )
            
            self.currentRegion = region
            
            parent.mapView.setRegion(region, animated: true)
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let polyline = MKPolylineRenderer(overlay: overlay)
            polyline.strokeColor = .systemBlue
            polyline.lineWidth = 6
            return polyline
        }
        
        //MARK: - Helpers
        func addAndSelectAnnotaion(withCoordinate coordinate: CLLocationCoordinate2D) {
            parent.mapView.removeAnnotations(parent.mapView.annotations)
            
            let anno = MKPointAnnotation()
            anno.coordinate = coordinate
            self.parent.mapView.addAnnotation(anno)
            self.parent.mapView.selectAnnotation(anno, animated: true)
            
            parent.mapView.showAnnotations(parent.mapView.annotations, animated: true)
        }
        
        func configurePolyline(withDestinationCoordinate coordinate: CLLocationCoordinate2D) {
            guard let userLocationCoordinate = self.userLocationCoordinate else { return }
            getDestinationRoute(from: userLocationCoordinate,
                                to: coordinate) { route in
                self.parent.mapView.addOverlay(route.polyline)
            }
        }
        
        func getDestinationRoute(from userLocation: CLLocationCoordinate2D,
                                 to destination: CLLocationCoordinate2D,
                                 completion: @escaping(MKRoute) -> Void) {
            
            let userPlacemark = MKPlacemark(coordinate: userLocation)
            let destPlaceMark = MKPlacemark(coordinate: destination)
            let request = MKDirections.Request()
            request.source = MKMapItem(placemark: userPlacemark)
            request.destination = MKMapItem(placemark: destPlaceMark)
            let directions = MKDirections(request: request)
            
            directions.calculate { response, error in
                if let error = error {
                    print("DEBUG: Failed to get directions woth error \(error.localizedDescription)")
                    return
                }
                guard let route = response?.routes.first else { return }
                completion(route)
            }
        }
        func clearMapViewAndRecenterUserLocation() {
            parent.mapView.removeAnnotations(parent.mapView.annotations)
            parent.mapView.removeOverlays(parent.mapView.overlays)
            
            if let currentRegion = currentRegion {
                parent.mapView.setRegion(currentRegion, animated: true)
            }
        }
    }
}
