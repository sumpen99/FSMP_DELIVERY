//
//  MainView.swift
//  FSMP_DELIVERY
//
//  Created by Philip Andersson on 2023-05-11.
//

import SwiftUI

struct MainView: View {
    
    // temp State var. remove
    @State private var choosenOrderDetails = "Here is all information about the highlighted order\n\nCustomer: Janne\nNumber: 0701234567\nAdress: Lugnagatan 1. 242 33 Hörby\n\nDescription: Sesensor utebelysning ur funktion"
    
    @State private var showSideMenu: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack() {
                VStack {
                    TextEditor(text: $choosenOrderDetails)
                        .disabled(true)
                        .padding()
                    HStack{
                        Button {
                            print("Activate this order")
                            print("and ...")
                        } label: {
                            Text("Activate")
                        }
                        .buttonStyle(CustomButtonStyle1())
                        
                        Button {
                            print("navigate to this order")
                        } label: {
                            Text("View on map")
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
                
                GeometryReader { _ in
                    
                    SideMenuView()
//                        .offset(x: 0)
//                        .offset(x: UIScreen.main.bounds.width)
                        .offset(x: showSideMenu ? 0 : -300, y: 0)
                    Spacer()
                }
            }
            .navigationTitle("Available orders")
            .fontWeight(.regular)
            .toolbar {
                Button {
                    print("show menu")
                    withAnimation(.easeInOut){
                        showSideMenu.toggle()
                    }
                    
                    
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
