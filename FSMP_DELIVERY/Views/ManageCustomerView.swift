//
//  ManageCustomerView.swift
//  FSMP_DELIVERY
//
//  Created by Philip Andersson on 2023-06-01.
//

import SwiftUI

struct ManageCustomerView: View {
    
    @EnvironmentObject var firestoreVM: FirestoreViewModel
    
    @Binding var customerToEdit : Customer
    
    @State var newName : String = ""
    @State var newAdress : String = ""
    @State var newPostcode : String = ""
    @State var newEmail : String = ""
    @State var newDescription : String = ""
    @State var newPhoneNumber : Int = 0
    @State var newTaxnumber : Int = 0
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack{
            Form{
                Section(header: Text("Edit Order")) {
                    
                    TextField(customerToEdit.name, text: $newName)
                    TextField(customerToEdit.adress, text: $newAdress)
                    TextField(customerToEdit.postcode, text: $newPostcode)
                    TextField(customerToEdit.email, text: $newEmail)
                    TextField(customerToEdit.description, text: $newDescription)
                    
                    // walla fixa!!
                    TextField(customerToEdit.phoneNumber, text: $newPhoneNumber)
                    TextField(customerToEdit.newTaxnumber, text: $newTaxnumber)
                }
            }

            Button("update order \(Image(systemName: "square.and.arrow.up"))"){
                firestoreVM.editCustomer(customerToEdit, newName, newAdress, newPostcode, newEmail, newDescription, newPhoneNumber, newTaxnumber)
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
        .onAppear{
            
            newName = customerToEdit.name
            newAdress = customerToEdit.adress
            newPostcode = customerToEdit.postcode
            newEmail = customerToEdit.email
            newDescription = customerToEdit.description
            newPhoneNumber = customerToEdit.phoneNumber
            newTaxnumber = customerToEdit.taxnumber
        }
    }
}

struct ManageCustomerView_Previews: PreviewProvider {
    
    @State private var customer = Customer(customerId: "123123", name: "janne", phoneNumber: 123123123)
    static var previews: some View {
        ManageCustomerView_Previews().previewLayout()
    }
    
    func previewLayout() -> some View {
        ManageCustomerView(customerToEdit: $customer)
            .environmentObject(FirestoreViewModel())
    }
}
