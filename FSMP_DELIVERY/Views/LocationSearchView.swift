//
//  LocationSearchView.swift
//  FSMP_DELIVERY
//
//  Created by Marko Paunovic on 2023-05-29.
//

import SwiftUI

struct LocationSearchView: View {
    
    @State private var startLocationText = ""
    @Binding var showLocationSearchView: Bool
    @EnvironmentObject var queryLocation : LocationSearchViewModel
    
    var body: some View {
            VStack {
                // header view
                HStack {
                    VStack {
                        
                        Button {
                            withAnimation(.spring()) {
                                showLocationSearchView.toggle()
                            }
                        } label: {
                            Image(systemName: "arrow.left")
                                .font(.title2)
                                .foregroundColor(.black)
                                .padding()
                                .background(.white)
                                .clipShape(Circle())
                                .shadow(color: Color.black.opacity(0.3),
                                        radius: 3,x: 3,y: 3)
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
                                    showLocationSearchView.toggle()
                                }
                            
                        }
                    }
                }
            }
        .background(.white)
    }
}

struct LocationSearchView_Previews: PreviewProvider {
    static var previews: some View {
        LocationSearchView(showLocationSearchView: .constant(true))
    }
}
