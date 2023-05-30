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
    
    var body: some View {
        VStack{
            Text(choosenOrder.ordername)
            Form{
                Section(header: Text("Edit Order")) {
                    Text(choosenOrder.customer.name)
                    TextField(choosenOrder.ordername, text: $choosenOrder.ordername)
                    TextField(choosenOrder.details, text: $choosenOrder.details)
                    
                }
                
            }
        }
    }
}

//struct ManageOrdersView_Previews: PreviewProvider {
//    static var previews: some View {
//        let customer = Customer(customerId: "123123",name: "janne", phoneNumber: 123123123)
//        let order = Order(ordername: "Fixa Vasken", details: "rensa vatten låset", customer: customer, orderId: "", initDate: Date())
//        ManageOrdersView(choosenOrder: order)
//            .environmentObject(FirestoreViewModel())
//    }
//}
