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
    @State private var userLocation: CLLocationCoordinate2D?
    
    
//    @State private var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 62.390, longitude: 17.306), span: MKCoordinateSpan(latitudeDelta: 15, longitudeDelta: 15))
    
    
    var body: some View {
        ZStack(alignment: .top) {
            ShowRoute(userLocation: userLocation)
                .edgesIgnoringSafeArea(.all)
            Map(coordinateRegion: $manager.region, showsUserLocation: true)
//                .edgesIgnoringSafeArea(.all)
//                .accentColor(Color(.systemPink))
//
                .onAppear {
                    manager.checkIfLocationServicesIsEnabled()
                }
            options()
        }
    }
    
}

struct OvalTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(10)
            .background(LinearGradient(gradient: Gradient(colors: [Color.white, Color.gray]), startPoint: .topLeading, endPoint: .bottomTrailing))
            .cornerRadius(20)
            .shadow(color: .gray, radius: 10)
    }
}

struct options : View {
    
    @StateObject var manager = LocationManager()
    @State private var userLocation: CLLocationCoordinate2D?
    @State var calculateRoute = ShowRoute()
    
    let destination = CLLocationCoordinate2D(latitude: 37.332331, longitude: -122.031219)
    
    //@StateObject var makeRoute =
    //@StateObject var startRoute =
    
    @State var searchAddress = ""
    
    var body: some View {
        
        VStack() {
            HStack {
                TextField("Search address...", text: $searchAddress)
            }
            .textFieldStyle(OvalTextFieldStyle())
            .padding()
            Spacer()
            Button {
                ShowRoute.RouteCalculator()
            } label: {
                Text("Show route")
                    .frame(minWidth: 0, maxWidth: 100)
                    .font(.system(size: 18))
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(25)
                    .shadow(color: Color.black.opacity(0.3),
                            radius: 3,x: 3,y: 3)
            }
            
            Button {
                // START ROUTE
            } label: {
                Text("Start route")
                    .frame(minWidth: 0, maxWidth: 100)
                    .font(.system(size: 18))
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(25)
                    .shadow(color: Color.black.opacity(0.3),
                            radius: 3,x: 3,y: 3)
            }
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
