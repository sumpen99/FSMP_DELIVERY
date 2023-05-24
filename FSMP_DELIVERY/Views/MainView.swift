//
//  MainView.swift
//  FSMP_DELIVERY
//
//  Created by Philip Andersson on 2023-05-11.
//

import SwiftUI

struct MainView: View {
    
    @EnvironmentObject var firestoreVM: FirestoreViewModel
    
    // temp State var. remove
    @State private var choosenOrderDetails = "Here is all information about the highlighted order\n\nCustomer: Janne\nNumber: 0701234567\nAdress: Lugnagatan 1. 242 33 Hörby\n\nDescription: Sesensor utebelysning ur funktion"
    
    @State private var showSideMenu: Bool = false
    @State private var orderIsActivated: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack() {
                Color(red: 70/256, green: 89/256, blue: 116/256).opacity(0.5)
                        .ignoresSafeArea()
                VStack {
                    TextEditor(text: $choosenOrderDetails)
                        .disabled(true)
                        .cornerRadius(16)
                        .padding()
                    HStack{
                        Button {
                            print("Activate this order")
                            print("and ...")
                            orderIsActivated.toggle()
                        } label: {
                            Text("Activate")
                        }
                        .buttonStyle(CustomButtonStyle1())
                        
                        NavigationLink("View on map") {
                            MapView()
                        }
                        .buttonStyle(CustomButtonStyle2())
                        getSignOfOrderBtn()
                        Spacer()
                    }
                    .padding(.leading, 20)
                    List{
                        ForEach(1...10, id: \.self) { i in
                            HStack {
                                Text("Order \(i)")
                            }
                        }
                    }.background(Color(red: 70/256, green: 89/256, blue: 116/256))
                        .cornerRadius(16)
                        .padding()
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
//            .navigationBarItems(leading: NavigationLink(destination: AddOrderView()) {
//                Image(systemName: "plus.circle")
//            })
        }
        .onAppear() {
            firestoreVM.listenToFirestore()
        }
        
    }
    
    
    
    
    func getSignOfOrderBtn() -> some View{
        return NavigationLink(destination:SignOfOrderView()) {
            Text("Sign Of Order")
        }
        .buttonStyle(CustomButtonStyleDisabledable())
        .disabled(orderIsActivated)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
