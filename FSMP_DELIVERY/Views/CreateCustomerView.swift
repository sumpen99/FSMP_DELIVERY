//
//  CreateCustomerView.swift
//  FSMP_DELIVERY
//
//  Created by Philip Andersson on 2023-05-15.
//

import SwiftUI

struct CreateCustomerView: View {
    
    let firestoreVM = FirestoreViewModel()
    
    @State var name : String = ""
    @State var email : String = ""
    @State var adress : String = ""
    @State var number : Int = 0
    @State var taxNumber : Int = 0
    @State var description : String = ""
    
    var body: some View {
        NavigationStack {
            VStack() {
                Spacer()
                HStack {
                    Spacer()
                    Image(systemName: "person.crop.circle")
                        .imageScale(.large)
                        .padding()
                    TextField("*Name:", text: $name)
                        .font(.title3)
                        .fontWeight(.semibold)
                }
                HStack {
                    Spacer()
                    Image(systemName: "envelope.circle")
                        .imageScale(.large)
                        .padding()
                    TextField("*Email:", text: $email)
                        .font(.title3)
                        .fontWeight(.semibold)
                }
                HStack {
                    Spacer()
                    Image(systemName: "house.circle")
                        .imageScale(.large)
                        .padding()
                    TextField("*Adress:", text: $adress)
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
                    TextField("", value: $number, formatter: NumberFormatter())
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
                    TextField("Number:", value: $taxNumber,  formatter: NumberFormatter())
                        .keyboardType(.numberPad)
                }
                HStack {
                    Spacer()
                    Image(systemName: "square.and.pencil.circle")
                        .imageScale(.large)
                        .padding()
                    TextField("Description:", text: $description)
                        .font(.title3)
                        .fontWeight(.semibold)
                }
                Spacer()
                Button {
                    
                    print("Saving customer to firestore")
                    // Needs if statements to check correct inputs
                    let newCustomer = Customer(
                        customerId:UUID().uuidString,
                        name: name,
                        email: email,
                        phoneNumber: number,
                        description: description,
                        taxnumber: taxNumber)
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
                Spacer()
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
