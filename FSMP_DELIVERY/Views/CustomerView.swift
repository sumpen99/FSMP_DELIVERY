//
//  CustomerView.swift
//  FSMP_DELIVERY
//
//  Created by Philip Andersson on 2023-05-15.
//

import SwiftUI

struct CustomerView: View {
    
    @EnvironmentObject var firestoreVM: FirestoreViewModel
    
    @State private var choosenCustomer : Customer? = nil
    
    var body: some View {
        NavigationStack {
            VStack {
                TextEditor(text: Binding(get: { chosenCustomerDetails }, set: { _ in }))
                    .disabled(true)
                    .padding()
                if let customer = choosenCustomer {
                    NavigationLink(destination: AddOrderView(customer: Binding(get: { customer }, set: { _ in }))) {
                        Text("Add order")
                        }
                        .buttonStyle(CustomButtonStyle1())
                        .padding(.leading, 20)
                    } else {
                        Spacer()
                    }
                
                List{
                    ForEach(firestoreVM.customers) { customer in
                        HStack {
                            Text(customer.name)
                        }
                        .onTapGesture {
                            choosenCustomer = customer
                        }
                    }
                }
            }
            .navigationBarItems(trailing: NavigationLink(destination: CreateCustomerView()) {
                Image(systemName: "plus.circle")
            })
            .navigationTitle("Customers")
            
        }
        .onAppear() {
            firestoreVM.listenToFirestore()
            if let firstCustomer = firestoreVM.customers.first {
                choosenCustomer = firstCustomer
            }
        }
    }
    
    var chosenCustomerDetails: String {
        guard let customer = choosenCustomer else {
            return ""
        }
        
        var details = ""
        details += "\(customer.name)\n"
        details += "Email: \(customer.email)\n"
        details += "Phone Number: \(customer.phoneNumber)\n"
        details += "Description: \(customer.description)\n"
        details += "Tax Number: \(customer.taxnumber)"
        
        return details
    }
}

struct CustomerView_Previews: PreviewProvider {
    static var previews: some View {
        CustomerView()
            .environmentObject(FirestoreViewModel())
    }
}
