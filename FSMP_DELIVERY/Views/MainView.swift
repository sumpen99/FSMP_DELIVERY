//
//  MainView.swift
//  FSMP_DELIVERY
//
//  Created by Philip Andersson on 2023-05-11.
//

import SwiftUI

struct MainView: View {
    
    // temp State var. remove
    @State private var choosenOrderDetails = " Here is all information about the highlighted order\n\n Customer: Janne\n Number: 0701234567\n Adress: Lugnagatan 1. 242 33 Hörby\n\n Description: Sesensor utebelysning ur funktion"
    
    var body: some View {
        NavigationStack {
            VStack {
                TextEditor(text: $choosenOrderDetails)
                HStack{
                    Button {
                        print("Activate this order")
                    } label: {
                        Text("Activate")
                    }
                    .buttonStyle(CustomButtonStyle1())
                    
                    Button {
                        print("navigate to this order")
                    } label: {
                        Text("Navigate")
                    }
                    .buttonStyle(CustomButtonStyle2())
                    Spacer()
                }
                .padding(.leading, 20)
                List{
                    ForEach(1...10, id: \.self) { i in
                        HStack {
                            Text("Order \(i)")
                        }
                    }
                }
            }
            .navigationTitle("Available orders")
            .fontWeight(.regular)
            .toolbar {
                Button {
                    print("show menu")
                } label: {
                    Image(systemName: "text.justify")
                        .foregroundColor(.accentColor)
                }
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
