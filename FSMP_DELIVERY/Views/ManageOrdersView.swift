//
//  ManageOrdersView.swift
//  FSMP_DELIVERY
//
//  Created by Philip Andersson on 2023-05-29.
//

import SwiftUI

struct ManageOrdersView: View {
    
    @EnvironmentObject var firestoreVM: FirestoreViewModel
    
    @Binding var choosenOrder : Order
    
//    @State var newCustomer: Customer
    @State var newDetails: String = ""
    @State var newOrderName: String = ""
    
    @State var selectedCustomerId: String = ""
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack{
            Form{
                Section(header: Text("Edit Order")) {
                    
                    // !!! Firebase klagar när jag försöker byta customer !!!
                    
//                    Picker("\(choosenOrder.customer.name)", selection: $newCustomer) {
//                        ForEach(firestoreVM.customers, id: \.customerId) { customer in
//                            Text(customer.name).tag(customer.customerId)
//                        }
//                    }
                    TextField(choosenOrder.ordername, text: $newOrderName)
                    TextField(choosenOrder.details, text: $newDetails)
                }
            }

            Button("update order \(Image(systemName: "square.and.arrow.up"))"){
                firestoreVM.editOrder(choosenOrder, newDetails, orderName: newOrderName)
                dismiss()
            }
            .padding()
            Spacer()
        }
//        .onChange(of: selectedCustomerId) { newCustomerId in
//            if let newCustomer = firestoreVM.customers.first(where: { $0.customerId == newCustomerId }) {
//                choosenOrder.customer = newCustomer
//            }
//        }
        .onDisappear(){
            firestoreVM.closeListenerCustomers()
        }
        .onAppear{
            firestoreVM.initializeListenerCustomers()
            
            newOrderName = choosenOrder.ordername
            newDetails = choosenOrder.details
        }
    }
}

struct ManageOrdersView_Previews: PreviewProvider {
    @State private var order = Order(ordername: "Fixa Vasken", details: "rensa vatten låset", customer: Customer(customerId: "123123", name: "janne", phoneNumber: 123123123), orderId: "",assignedUser: "", initDate: Date())

    static var previews: some View {
        ManageOrdersView_Previews().previewLayout()
    }

    func previewLayout() -> some View {
        ManageOrdersView(choosenOrder: $order)
            .environmentObject(FirestoreViewModel())
    }
}
