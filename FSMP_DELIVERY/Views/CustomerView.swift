//
//  CustomerView.swift
//  FSMP_DELIVERY
//
//  Created by Philip Andersson on 2023-05-15.
//

import SwiftUI

struct CustomerView: View {
    // temp State var. remove
    @EnvironmentObject var firestoreVM: FirestoreViewModel
    
    @State private var choosenCustomerDetails = "Here is all information about the highlighted customer\n\nName: Janne\nAdress: Lugnagatan 1. 242 33 Hörby\nNumber: 0701234567\nEmail: janne.jansson@gmail.com\n\nDescription: Bra kille!"
    
    var body: some View {
        NavigationStack {
            VStack {
                TextEditor(text: $choosenCustomerDetails)
                    .disabled(true)
                    .padding()
                HStack{
                    Button {
                        print("Go to add orderView with this customer as a Binding")
                    } label: {
                        Text("Add order")
                    }
                    .buttonStyle(CustomButtonStyle1())
                    Spacer()
                }
                .padding(.leading, 20)
                List{
                    ForEach(firestoreVM.customers) { customer in
                        HStack {
                            test()
                            Text(customer.name)
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
            print(firestoreVM.customers.count)
        }
        
    }
    
    func test() -> some View {
        print("asd")
        return EmptyView()
        
    }
    
}

struct CustomerView_Previews: PreviewProvider {
    static var previews: some View {
        CustomerView()
    }
}
