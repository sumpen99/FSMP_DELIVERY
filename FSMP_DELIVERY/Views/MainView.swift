//
//  MainView.swift
//  FSMP_DELIVERY
//
//  Created by Philip Andersson on 2023-05-11.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var firebaseAuth: FirebaseAuth
    @EnvironmentObject var firestoreVM: FirestoreViewModel
    @State var pdfUrl:URL?
    @State private var showAlert: Bool = false
    @State private var showAlertForDelete = false
    @State private var indexSetToDelete: IndexSet?
    @State private var showSideMenu: Bool = false
    @State private var orderIsActivated: Bool = false
    @State private var orderActivationChange: Bool = false
    @State private var listOfOrdersIsShowing:Bool = true
    @State var currentOrder:Order?
    
    
    var body: some View {
        NavigationStack {
            ZStack() {
                VStack {
                    PDFKitView(url:$pdfUrl)
                    bottomButtons
                    Spacer()
                    if !orderIsActivated {
                        ToggleBox(toogleIsOn: $listOfOrdersIsShowing, label: "").padding(.bottom,-50.0)
                        if listOfOrdersIsShowing {
                            listOfOrders
                        }
                    }
                }
                sideMenu
            }
            .onReceive(firestoreVM.$ordersInProcess) { (orders) in
                guard !orders.isEmpty else { return }
                findActivatedOrderOrSetFirst(orders: orders)
            }
            .fontWeight(.regular)
            .toolbar {
                Button {
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
                animateOrderIsActive(value: !orderIsActivated)
            },
                actionSecondary: { })
        })
        .onChange(of: orderIsActivated){ isActivated in
            callFirebaseAndTooggleOrderActivation(shouldActivate: isActivated)
        }
        .onAppear() {
            firestoreVM.initializeListenerOrdersInProcess()
        }
        .onDisappear{
            firestoreVM.closeListenerOrdersInProcess()
        }
        
    }
    
    var sideMenu: some View{
        GeometryReader { _ in
            SideMenuView(closeMenuOnDissapear:$showSideMenu){ firestoreVM.releaseData() }
            .offset(x: showSideMenu ? 0 : -300, y: 0)
            Spacer()
        }
    }
    
    var listOfOrders: some View{
        List{
            ForEach(firestoreVM.ordersInProcess, id: \.orderId) { order in
                getListOrderButton(order: order)
            }
            .onDelete() { indexSet in
                self.showAlertForDelete = true
                self.indexSetToDelete = indexSet
            }
            .deleteDisabled(firebaseAuth.loggedInAs != .ADMIN)
            .alert(isPresented: $showAlertForDelete) {
                Alert(title: Text("Ta bort Order!"),
                      message: Text("Är du säker på att du vill ta bort beställningen?"),
                      primaryButton: .destructive(Text("Ta bort")) {
                    if let indexSet = indexSetToDelete {
                        for index in indexSet {
                            let orderToRemove = firestoreVM.ordersInProcess[index]
                            firestoreVM.removeOrderInProcess(orderToRemove.orderId)
                            firestoreVM.removeOrderPdfFromStorage(orderType: .ORDER_IN_PROCESS,orderNumber: orderToRemove.orderId)
                        }
                    }
                },
                      secondaryButton: .cancel {
                    showAlertForDelete = false
                }
                )
            }
            .onTapGesture(count: 2) {
                showAlert = true
            }
        }
        .alert("Edit order?", isPresented: $showAlert) {

            if let order = currentOrder {
                    HStack{
                        NavigationLink(destination: LazyDestination(destination: {
                            ManageOrdersView(choosenOrder: Binding(get: { order }, set: { _ in }))
                        })) {
                            Text("Yes")
                        }
                    }
                }

            else{
                Spacer()
            }

            Button("no") {
                print("no")
            }
        }
        .cornerRadius(16)
        .padding()
    }
    
    var bottomButtons: some View{
        HStack(spacing:20){
            Spacer()
            deAndActivateOrderButton
            mapviewButton
            Spacer()
            signOfOrderBtn
            Spacer()
        }
        .padding(.leading)
    }
    
    var deAndActivateOrderButton: some View {
        
        Button(action: {
            if !orderIsActivated{
                setAlertActivateOrderMessage()
            } else {
                setAlertDeActivateOrderMessage()
            }})
        {
            if !orderIsActivated{
                Text("Activate \(Image(systemName: "checkmark.circle"))")
            } else {
                Text("Deactivate \(Image(systemName: "checkmark.circle.badge.xmark"))")
            }
            
        }
        
        .buttonStyle(CustomButtonStyleActivateDeactivate(isActivated: !orderIsActivated))
    }
    
    var mapviewButton: some View{
        NavigationLink(destination: MapView()){
            Image(systemName: "map")
        }
        .buttonStyle(CustomButtonStyleDisabledable())
        .disabled(!orderIsActivated)
    }
    
    var signOfOrderBtn: some View {
        NavigationLink(destination:LazyDestination(destination: { SignOfOrderView(currentOrder:currentOrder) })) {
            Text("Sign \(Image(systemName: "square.and.pencil"))")
        }
        .buttonStyle(CustomButtonStyleDisabledable())
        .disabled(!orderIsActivated)
    }
    
    func getListOrderButton(order:Order) -> some View{
        return HStack{
                VStack(spacing:10){
                    getHeaderSubHeader("Kund: ", subHeader: order.customer.name)
                    getHeaderSubHeader("Adress: ", subHeader: order.customer.adress)
                    getHeaderSubHeader("Inkom: ", subHeader: order.initDate.formattedString())
                    getHeaderSubHeader("Väntat: ", subHeader:
                                        "\(Calendar.numberOfDaysBetween(order.initDate, and: Date()))")
                }
                Spacer()
                Text(Image(systemName: "checkmark.circle.fill"))
                    .opacity(currentOrder?.orderId == order.orderId ? 1.0 : 0.0)
                    .foregroundColor(orderIsActivated ? .green : .gray)
            }
            .foregroundColor(.white)
            .listRowBackground(
                RoundedRectangle(cornerRadius: 5)
                    .background(.clear)
                    .foregroundColor(.white)
                    .padding([.top,.bottom],2.0)
            )
            .listRowSeparator(.hidden)
            .contentShape(Rectangle())
            .onTapGesture {
                if orderIsActivated { return }
                withAnimation{
                    currentOrder = order
                    updatePdfViewWithOrder(order)
                }
            }
            /*return HStack {
                Button(action: {
                    if orderIsActivated { return }
                    currentOrder = order
                    updatePdfViewWithOrder(order)
                }){
                    shortestOrderInfo(order)
                }
                Spacer()
                Image(systemName: "checkmark.circle.fill")
                    .opacity(currentOrder?.orderId == order.orderId ? 1.0 : 0.0)
                    .foregroundColor(orderIsActivated ? .green : .gray)
            }*/
    }
    
    func findActivatedOrderOrSetFirst(orders:[Order]){
        guard let index = orders.firstIndex(where: {
            $0.isActivated
        })
        else{
            guard let firstOrder = orders.first else { return }
            animateOrderIsActive(value: false)
            currentOrder = firstOrder
            updatePdfViewWithOrder(firstOrder);
            return
        }
        
        SIMULATED_QR_CODE = orders[index].orderId
        animateOrderIsActive(value: true)
        currentOrder = orders[index]
        updatePdfViewWithOrder(orders[index])
    }
    
    
    func callFirebaseAndTooggleOrderActivation(shouldActivate:Bool){
        guard let orderId = currentOrder?.orderId else { return }
        if shouldActivate{
            SIMULATED_QR_CODE = orderId
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
    }
    
    func shortestOrderInfo(_ order:Order) -> some View{
        VStack(spacing:10){
            getHeaderSubHeader("Kund: ", subHeader: order.customer.name)
            getHeaderSubHeader("Adress: ", subHeader: order.customer.adress)
            getHeaderSubHeader("Inkom: ", subHeader: order.initDate.formattedString())
        }
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
    
    private func animateOrderIsActive(value:Bool){
        withAnimation{
            orderIsActivated = value
        }
    }
    
}


struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        
        MainView()
            .environmentObject(FirestoreViewModel())
            .environmentObject(FirebaseAuth())
    }
}
