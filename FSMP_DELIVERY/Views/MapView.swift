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
    @State private var showLocationSearchView = false
    
    var body: some View {
        ZStack(alignment: .top) {
            ShowMap(userLocation: userLocation)
                .edgesIgnoringSafeArea(.all)
            
                .onAppear {
                    manager.checkIfLocationServicesIsEnabled()
                }
            if showLocationSearchView {
                LocationSearchView(showLocationSearchView: $showLocationSearchView)
            } else {
                LocationSearchActivationView()
                    .onTapGesture {
                        withAnimation(.spring()) {
                            showLocationSearchView.toggle()
                        }
                    }
            }
            VStack{
                Spacer()
                
                VStack {
                    
                    Button {
                        //
                    } label: {
                        Image(systemName: "location.fill")
                            .font(.title2)
                            .padding(10)
                            .background(Color.primary)
                            .clipShape(Circle())
                    }
                    
                    Button(action: manager.updateMapType,
                     label: {
                        Image(systemName: manager.mapType == .standard ? "network" : "map")
                            .font(.title2)
                            .padding(10)
                            .background(Color.primary)
                            .clipShape(Circle())
                    })
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding()
            }
        }
    }
}

struct LocationSearchActivationView: View {
    var body: some View {
        HStack {
            Rectangle()
                .fill(Color.black)
                .frame(width: 8, height: 8)
                .padding(.horizontal)
            Text("Order address")
                .foregroundColor(Color(.darkGray))
            
            Spacer()
        }
        .frame(width: UIScreen.main.bounds.width - 64, height: 50)
        .background(
        Rectangle()
            .fill(Color.white)
            .shadow(color: Color.black.opacity(0.3),
                    radius: 3,x: 3,y: 3))
    }
}

struct options : View {
    
    @StateObject var manager = LocationManager()
    @State private var userLocation: CLLocationCoordinate2D?
    @State var calculateRoute = ShowMap()
    
    let destination = CLLocationCoordinate2D(latitude: 37.332331, longitude: -122.031219)
    
    //@StateObject var makeRoute =
    //@StateObject var startRoute =
    
    var body: some View {
        
        VStack() {
            Button {
                //ShowMap.RouteCalculator()
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
        options()
    }
}
