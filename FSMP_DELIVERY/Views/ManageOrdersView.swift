//
//  ManageOrdersView.swift
//  FSMP_DELIVERY
//
//  Created by Philip Andersson on 2023-05-29.
//

import SwiftUI

struct ManageOrdersView: View {
    
    @EnvironmentObject var firestoreVM: FirestoreViewModel
    @State private var choosenOrder : Order? = nil
    
    var body: some View {
        VStack{
            Form{
                
            }
            List{
                ForEach(firestoreVM.ordersInProcess,id: \.orderId){ order in
                    Text(order.ordername)
                }
//                .onReceive(firestoreVM.ordersInProcess) { (order) in
//                    guard !order.isEmpty else { return }
//                    choosenOrder = order.first
//                }
            }
        }
    }
}

struct ManageOrdersView_Previews: PreviewProvider {
    static var previews: some View {
        ManageOrdersView()
            .environmentObject(FirestoreViewModel())
    }
}
