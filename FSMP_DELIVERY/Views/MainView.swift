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
    @State private var orderActivationChange: Bool = false
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
        .alert(isPresented: $orderActivationChange, content: {
            onConditionalAlert(actionPrimary: {
                orderIsActivated.toggle()
            },
                actionSecondary: { })
        })
        .onChange(of: orderIsActivated){ isActivated in
            callFirebaseAndTooggleOrderActivation(shouldActivate: isActivated)
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
            ForEach(firestoreVM.ordersInProcess, id: \.orderId) { order in
                getListOrderButton(order: order)
            }
            .onReceive(firestoreVM.$ordersInProcess) { (orders) in
                guard !orders.isEmpty else { return }
                findActivatedOrderOrSetFirst(orders: orders)
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
            if orderIsActivated{
                deActivateOrderButton
            }
        }
        .padding(.leading)
    }
    
    var activateOrderButton: some View {
        Button(action: {setAlertActivateOrderMessage()})
        {
            Text(Image(systemName: "hand.tap"))
                .font(.largeTitle)
        }
        .buttonStyle(CustomButtonStyleDisabledable())
        .disabled(orderIsActivated)
    }
    
    var mapviewButton: some View{
        NavigationLink(destination: MapView()){
            Text(Image(systemName: "map"))
                .font(.largeTitle)
        }
        .buttonStyle(CustomButtonStyle2())
    }
    
    var signOfOrderBtn: some View {
        NavigationLink(destination:LazyDestination(destination: { SignOfOrderView(currentOrder:currentOrder) })) {
            Text(Image(systemName: "square.and.pencil"))
                .font(.largeTitle)
        }
        .buttonStyle(CustomButtonStyleDisabledable())
        .disabled(!orderIsActivated)
    }
    
    var deActivateOrderButton: some View {
        Button(action: {setAlertDeActivateOrderMessage()})
        {
            Text(Image(systemName: "hand.raised.slash"))
                .font(.largeTitle)
        }
        .buttonStyle(CustomButtonStyle1())
        .padding(.trailing)
    }
    
    func getListOrderButton(order:Order) -> some View{
        return HStack {
            Button(action: {
                if orderIsActivated { return }
                currentOrder = order
                updatePdfViewWithOrder(order)
            }){
                Text("\(order.customer.name) - \(order.ordername)")
            }
            Spacer()
            Image(systemName: "checkmark.circle.fill")
                .opacity(currentOrder?.orderId == order.orderId ? 1.0 : 0.0)
                .foregroundColor(orderIsActivated ? .green : .gray)
        }
    }
    
    func findActivatedOrderOrSetFirst(orders:[Order]){
        guard let index = orders.firstIndex(where: {
            $0.isActivated
        })
        else{
            guard let firstOrder = orders.first else { return }
            updatePdfViewWithOrder(firstOrder);
            return
        }
    
        orderIsActivated = true
        currentOrder = orders[index]
        updatePdfViewWithOrder(orders[index])
    }
    
    func callFirebaseAndTooggleOrderActivation(shouldActivate:Bool){
        guard let orderId = currentOrder?.orderId else { return }
        if shouldActivate{
            firestoreVM.activateOrderInProcess(orderId)
        }
        else{
            firestoreVM.deActivateOrderInProcess(orderId)
        }
    }
    
    func updatePdfViewWithOrder(_ order:Order){
        currentOrder = order
        guard let renderedUrl = getPdfUrlPath(fileName: order.orderId) else { return }
        if FileManager.default.fileExists(atPath: renderedUrl.path()) {
            pdfUrl = renderedUrl
        } else {
            firestoreVM.downloadFormPdf(orderType: .ORDER_IN_PROCESS,
                                        localUrl: renderedUrl,
                                        orderNumber: order.orderId){ url in
                guard let url = url else { return }
                pdfUrl = url
            }
        }
        
        /*
            CLEAR ORDERS FOLDER AT SOME POINT
            removeOneOrderFromFolder(fileName: order.orderId)
            removeAllOrdersFromFolder()
         
         */
        
    }
    
    private func setAlertActivateOrderMessage(){
        ALERT_TITLE = "Aktivera Order"
        ALERT_MESSAGE = "Vill ni aktivera \nOrder: \(currentOrder?.orderId ?? "")?"
        orderActivationChange.toggle()
    }
    
    private func setAlertDeActivateOrderMessage(){
        ALERT_TITLE = "Avsluta Order"
        ALERT_MESSAGE = "Vill ni ta bort aktiverad \nOrder: \(currentOrder?.orderId ?? "")?"
        orderActivationChange.toggle()
    }
    
}


struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
