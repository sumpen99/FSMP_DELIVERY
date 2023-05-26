//
//  AddOrderView.swift
//  FSMP_DELIVERY
//
//  Created by Kanyaton Somjit on 2023-05-15.
//

import SwiftUI
import FirebaseCore
import Firebase

struct AddOrderView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var firestoreVM: FirestoreViewModel
    
    @State private var orderName = ""
    @State private var description = ""
    @Binding var customer : Customer
    // UserId isnt the same as FirestoreAuth UUID
    @State private var user = UUID()
    @State private var isActivated = false
    @State private var isCompleted = false
    @State private var initDate = Date()
    @State private var dateOfCompletion = Date()
    
    var body: some View {
      
        
        NavigationStack {
            VStack {
                Form {
                    Section(header: Text("Order Details")) {
                        TextField("Order Name", text: $orderName)
                        TextField("Description", text: $description)
                    }
                }
            }
        }
        .navigationTitle("Create order for \(customer.name)")
        .fontWeight(.regular)
        .toolbar {
            ToolbarItemGroup{
                Button(action: {
                    let newOrder = Order(ordername: orderName, details: description, customer: customer, assignedUser: user, initDate: Date())
                    
                    firestoreVM.setOrderDocument(newOrder)
                    
                    presentationMode.wrappedValue.dismiss()
                }
) {
                    Image(systemName: "square.and.arrow.up")
                }
            }
        }
    }
}


struct AddOrderView_Previews: PreviewProvider {
    static var previews: some View {
        var customer = Customer( name: "janne", email: "asd", phoneNumber: 12, taxnumber: 123) // Create an instance of Customer
        
        return AddOrderView(customer: Binding<Customer>(
            get: { customer },
            set: { customer = $0 }
        ))
    }
}
