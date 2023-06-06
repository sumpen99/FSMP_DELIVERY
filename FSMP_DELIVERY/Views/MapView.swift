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
    @State var showMap : ShowMap
    @State private var userLocation: CLLocationCoordinate2D?
    @State private var mapState = MapViewState.noInput
    
    var body: some View {
        ZStack(alignment: .top) {
            ShowMap(userLocation: userLocation, mapState: $mapState)
                .edgesIgnoringSafeArea(.all)
            
                .onAppear {
                    manager.checkIfLocationServicesIsEnabled()
                }
            if mapState == .searchingForLocation {
                LocationSearchView(mapState: $mapState)
            } else if mapState == .noInput {
                LocationSearchActivationView(mapState: mapState)
                    .onTapGesture {
                        withAnimation(.spring()) {
                            mapState = .searchingForLocation
                        }
                    }
            }
            
            VStack {
                Spacer()
                
                VStack {
                    if mapState == .locationSelected {
                        MapViewActionButton(mapState: $mapState)
                            .padding(.top, 50)
                    } else if mapState == .searchingForLocation {
                        MapViewActionButton(mapState: $mapState)
                            .padding(.top, 50)
                    }
                    Spacer()
                    //Spacer()
                    VStack {
                        Button(action: manager.focusLocation,
                               label: {
                            Image(systemName: "location.fill")
                                .font(.title2)
                                .padding(10)
                                .background(.white)
                                .clipShape(Circle())
                        })
                        
                        Button {
                            manager.toggleMapType()
                        } label: {
                            Image(systemName: "map")
                                .font(.title2)
                                .padding(10)
                                .background(.white)
                                .clipShape(Circle())
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding()
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding()
            }
        }
    }
}

struct LocationSearchActivationView: View {
    @State var mapState: MapViewState
    
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

//struct MapView_Previews: PreviewProvider {
//
//    static var previews: some View {
//        MapView()
//    }
//}
