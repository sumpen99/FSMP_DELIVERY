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
    
    var body: some View {
        NavigationStack {
            VStack() {
                HStack {
                    Spacer()
                    Image(systemName: "person.crop.circle")
                        .imageScale(.large)
                        .padding()
                    TextField("*Name:", text: $newCustomer.name)
                        .font(.title3)
                        .fontWeight(.semibold)
                }
                HStack {
                    Spacer()
                    Image(systemName: "envelope.circle")
                        .imageScale(.large)
                        .padding()
                    TextField("*Email:", text: $newCustomer.email)
                        .font(.title3)
                        .fontWeight(.semibold)
                }
                HStack {
                    Spacer()
                    Image(systemName: "house.circle")
                        .imageScale(.large)
                        .padding()
                    TextField("*Adress:", text: $newCustomer.adress)
                        .font(.title3)
                        .fontWeight(.semibold)
                }
                HStack {
                    Spacer()
                    Image(systemName: "signpost.right")
                        .imageScale(.large)
                        .padding()
                    TextField("*Postkod:", text: $newCustomer.postcode)
                        .font(.title3)
                        .fontWeight(.semibold)
                }
                HStack {
                    Spacer()
                    Image(systemName: "phone.circle")
                        .imageScale(.large)
                        .padding()
                    Text("*Number:")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.gray.opacity(0.5))
                    TextField("", value: $newCustomer.phoneNumber, formatter: NumberFormatter())
                        .font(.title3)
                        .fontWeight(.semibold)
                        .keyboardType(.numberPad)
                }
                HStack {
                    Spacer()
                    Image(systemName: "book.closed.circle")
                        .imageScale(.large)
                        .padding()
                    Text("tax number:")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.gray.opacity(0.5))
                    TextField("Number:", value: $newCustomer.taxnumber,  formatter: NumberFormatter())
                        .keyboardType(.numberPad)
                }
                HStack {
                    Spacer()
                    Image(systemName: "square.and.pencil.circle")
                        .imageScale(.large)
                        .padding()
                    TextField("Description:", text: $newCustomer.description)
                        .font(.title3)
                        .fontWeight(.semibold)
                }
                Spacer()
                Button {
                    if newCustomer.isNotValid(){
                        print("new customer is not valid, show dialog and tell people")
                        return
                    }
                    
                    firestoreVM.setCustomerDocument(newCustomer)
                } label: {
                    HStack {
                        Text("Save")
                        Image(systemName: "plus")
                    }
                        .imageScale(.large)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .foregroundColor(.accentColor)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(16)
                        .fontWeight(.semibold)
                        
                }
            }
            .navigationTitle("Create new customer")
        }
    }
}

struct CreateCustomerView_Previews: PreviewProvider {
    static var previews: some View {
        CreateCustomerView()
    }
}
