//
//  MainView.swift
//  FSMP_DELIVERY
//
//  Created by Philip Andersson on 2023-05-11.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var firestoreVM: FirestoreViewModel
    @State var pdfUrl:URL?
    @State private var showSideMenu: Bool = false
    @State private var orderIsActivated: Bool = false
    @State var currentOrder:Order?
    
    var body: some View {
        NavigationStack {
            ZStack() {
                backgroundColor
                VStack {
                    PDFKitView(url:$pdfUrl)
                    bottomButtons
                    Spacer()
                    listOfOrders
                }
                sideMenu
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
        .onAppear() {
            firestoreVM.initializeListener()
        }
        
    }
    
    var backgroundColor: some View{
        Color(red: 70/256, green: 89/256, blue: 116/256).opacity(0.5)
                .ignoresSafeArea()
    }
    
    var sideMenu: some View{
        GeometryReader { _ in
            SideMenuView()
//              .offset(x: 0)
//              .offset(x: UIScreen.main.bounds.width)
                .offset(x: showSideMenu ? 0 : -300, y: 0)
            Spacer()
        }
    }
    
    var listOfOrders: some View{
        List{
            ForEach(firestoreVM.orders, id: \.orderId) { order in
                HStack {
                    Text("\(order.ordername)")
                }
            }
            .onReceive(firestoreVM.$orders) { (orders) in
                guard !orders.isEmpty, let firstOrder = orders.first else { return }
                updatePdfViewWithOrder(firstOrder)
            }
        }
        .cornerRadius(16)
        .padding()
    
    }
    
    var bottomButtons: some View{
        HStack(spacing:20){
            activateOrderButton
            mapviewButton
            signOfOrderBtn
            Spacer()
        }
        .padding(.leading)
    }
    
    var activateOrderButton: some View {
        Button {
            orderIsActivated.toggle()
        } label: {
            Text(Image(systemName: "hand.tap"))
                .font(.largeTitle)
        }
        .buttonStyle(CustomButtonStyle1())
    }
    
    var mapviewButton: some View{
        NavigationLink(destination: MapView()){
            Text(Image(systemName: "map"))
                .font(.largeTitle)
        }
        .buttonStyle(CustomButtonStyle2())
    }
    
    var signOfOrderBtn: some View {
        NavigationLink(destination:LazyDestination(destination: { SignOfOrderView() })) {
            Text(Image(systemName: "square.and.pencil"))
                .font(.largeTitle)
        }
        .buttonStyle(CustomButtonStyleDisabledable())
        .disabled(orderIsActivated)
    }
    
    func updatePdfViewWithOrder(_ order:Order){
        currentOrder = order
        guard let documentDirectory = documentDirectory else { return }
        let filePath = order.orderId + ".pdf"
        let renderedUrl = documentDirectory.appending(path: filePath)
        
        firestoreVM.downloadFormPdf(orderType: .ORDER_IN_PROCESS,
                                    localUrl: renderedUrl,
                                    orderNumber: order.orderId){ url in
            guard let url = url else { return }
            pdfUrl = url
        }
    }
}


struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
