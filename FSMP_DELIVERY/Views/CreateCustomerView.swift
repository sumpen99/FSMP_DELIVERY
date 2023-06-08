//
//  CreateCustomerView.swift
//  FSMP_DELIVERY
//
//  Created by Philip Andersson on 2023-05-15.
//

import SwiftUI

struct CreateCustomerView: View {
    let firestoreVM = FirestoreViewModel()
    @State var newCustomer:Customer = Customer(customerId:UUID().uuidString)
    
    @Environment(\.dismiss) private var dismiss
    
    @State var phoneString = ""
    @State var taxString = ""
    
    var body: some View {
        NavigationStack {
            VStack() {
                Form {
                        Section(header:
                                    Text("Customer details"))
                        {
                            TextField("\(Image(systemName: "person.crop.circle")) Name:", text: $newCustomer.name)
                            
                            TextField("\(Image(systemName: "envelope.circle")) Email:", text: $newCustomer.email)
                            
                            TextField("\(Image(systemName: "house.circle")) Adress:", text: $newCustomer.adress)
                            
                            TextField("\(Image(systemName: "signpost.right")) Postal/zip:", text: $newCustomer.postcode)
                            
                            TextField("\(Image(systemName: "phone.circle")) phone:", text: $phoneString)
                                .keyboardType(.numberPad)
                            
                            TextField("\(Image(systemName: "book.closed.circle")) Taxnumber:", text: $taxString)
                            
                            TextField("\(Image(systemName: "square.and.pencil.circle")) Description:", text: $newCustomer.description)
                            
                        }
                    }
                .navigationBarItems(trailing: Button {
                    
                    let phoneNumber = NumberFormatter().number(from: phoneString)
                    let taxNumber = NumberFormatter().number(from: taxString)
                    
                    newCustomer.phoneNumber = phoneNumber as? Int ?? 0
                    newCustomer.phoneNumber = taxNumber as? Int ?? 0
                    if newCustomer.isNotValid(){
                        print("new customer is not valid, show dialog and tell people")
                        return
                    }
                    
                    firestoreVM.setCustomerDocument(newCustomer)
                    
                    dismiss()
                } label: {
                    HStack {
                        Image(systemName: "square.and.arrow.up")
                    }
                })
                .navigationTitle("Create new customer")
            }
        }
    }
    
//    var fomrSections: some View {
//
//    }
    
    struct CreateCustomerView_Previews: PreviewProvider {
        //    let newCustomer = Customer(customerId: UUID())
        static var previews: some View {
            CreateCustomerView()
        }
    }
}
