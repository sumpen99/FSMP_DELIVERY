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
    @State var newPhoneNumberString : String = ""
    @State var newTaxnumberString : String = ""
    
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
                    TextField(String(customerToEdit.phoneNumber), text: $newPhoneNumberString)
                    TextField(String(customerToEdit.taxnumber), text: $newTaxnumberString)
                }
            }

            Button("update customer \(Image(systemName: "square.and.arrow.up"))"){
                
                let newPhoneNumber = NumberFormatter().number(from: newPhoneNumberString)
                let newTaxnumber = NumberFormatter().number(from: newTaxnumberString)
                
                let testCustomer = Customer(customerId: UUID().uuidString, name: newName, adress: newAdress, postcode: newPostcode, email: newEmail)
                
                if testCustomer.isNotValid(){
                    print("walla fel")
                    return
                } else {
                    firestoreVM.editCustomer(customerToEdit, newName, newAdress, newPostcode, newEmail, newDescription, newPhoneNumber as? Int ?? customerToEdit.phoneNumber, newTaxnumber as? Int ?? customerToEdit.taxnumber)
                    
                    dismiss()
                }
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
            newPhoneNumberString = String(customerToEdit.phoneNumber)
            newTaxnumberString = String(customerToEdit.taxnumber)
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
