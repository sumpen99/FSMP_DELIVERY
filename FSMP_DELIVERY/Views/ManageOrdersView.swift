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

struct ManageOrdersView_Previews: PreviewProvider {
    @State private var order = Order(ordername: "Fixa Vasken", details: "rensa vatten låset", customer: Customer(customerId: "123123", name: "janne", phoneNumber: 123123123), orderId: "", initDate: Date())

    static var previews: some View {
        ManageOrdersView_Previews().previewLayout()
    }

    func previewLayout() -> some View {
        ManageOrdersView(choosenOrder: $order)
            .environmentObject(FirestoreViewModel())
    }
}
