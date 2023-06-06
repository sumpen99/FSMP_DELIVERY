//
//  LocationSearchView.swift
//  FSMP_DELIVERY
//
//  Created by Marko Paunovic on 2023-05-29.
//

import SwiftUI

struct LocationSearchView: View {
    
    @State private var startLocationText = ""
    @Binding var mapState: MapViewState
    @EnvironmentObject var queryLocation : LocationSearchViewModel
    
    var body: some View {
        VStack {
            // header view
            HStack {
                HStack {
                    Button {
                        withAnimation(.spring()) {
                            actionForState(mapState)
                        }
                    } label: {
                        Image(systemName: "arrow.left")
                            .font(.title2)
                            .foregroundColor(.black)
                            .padding()
                            .background(.white)
                            .clipShape(Circle())
                    }
                }
                VStack {
                    TextField("Current location", text: $startLocationText)
                        .frame(height: 32)
                        .background(Color(
                            .systemGroupedBackground))
                        .padding(.trailing)
                    
                    TextField("Order address", text: $queryLocation.queryFragment)
                        .frame(height: 32)
                        .background(Color(.systemGray4))
                        .padding(.trailing)
                }
            }
            .padding(.horizontal)
            .padding(.top, 64)
            
            Divider()
                .padding(.vertical)
            
            // list view
            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(queryLocation.results, id: \.self) { result in
                        LocationSearchResultCell(title: result.title, subtitle: result.subtitle)
                            .onTapGesture {
                                queryLocation.selectedLocation(result)
                                mapState = .locationSelected
                            }
                    }
                }
            }
        }
        .background(.white)
    }
    
    func actionForState(_ state: MapViewState) {
        switch state {
        case .noInput:
            print("DEBUG: No Input")
        case .searchingForLocation:
            mapState = .noInput
        case .locationSelected:
            print("DEBUG: Clear map view..")
        }
    }
}

struct LocationSearchView_Previews: PreviewProvider {
    static var previews: some View {
        LocationSearchView(mapState: .constant(.searchingForLocation))
    }
}
