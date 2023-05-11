//
//  MainView.swift
//  FSMP_DELIVERY
//
//  Created by Philip Andersson on 2023-05-11.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        NavigationStack {
            VStack {
                List{
                    ForEach(1...10, id: \.self) { i in
                        HStack {
                            Text("Order \(i)")
                        }
                    }
                }
            }
            .navigationTitle("Available orders")
            .fontWeight(.thin)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
