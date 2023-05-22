//
//  MapView.swift
//  FSMP_DELIVERY
//
//  Created by Marko Paunovic on 2023-05-18.
//

import SwiftUI
import MapKit

struct MapView: View {
    @StateObject var manager = LocationManager()
    
    
//    @State private var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 62.390, longitude: 17.306), span: MKCoordinateSpan(latitudeDelta: 15, longitudeDelta: 15))
    
    
    var body: some View {
        Map(coordinateRegion: $manager.region, showsUserLocation: true)
            .edgesIgnoringSafeArea(.all)
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
