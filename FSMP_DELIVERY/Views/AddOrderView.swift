//
//  AddOrderView.swift
//  FSMP_DELIVERY
//
//  Created by Kanyaton Somjit on 2023-05-15.
//

import SwiftUI

struct AddOrderView: View {
    
    @State private var customerName = ""
    @State private var orderName = ""
    @State private var assignedUser = ""
    @State private var isActivated = false
    @State private var isCompleted = false
    @State private var initDate = Date()
    @State private var dateOfCompletion = Date()
    
    var body: some View {
      
            Form {
                //            Section(header: Text("Customer Information")) {
                //                TextField("Customer Name", text: $customerName)
                //            }
                
                Section(header: Text("Order Details")) {
                    TextField("Order Name", text: $orderName)
                    TextField("Assigned User", text: $assignedUser)
                    //                DatePicker("Init Date", selection: $initDate, displayedComponents: .date)
                    //                DatePicker("Date of Completion", selection: $dateOfCompletion, displayedComponents: .date)
                }
                
                Section(header: Text("Status")) {
                    Toggle("Is Activated", isOn: $isActivated)
                    Toggle("Is Completed", isOn: $isCompleted)
                }
            }
            .navigationBarTitle("Add Order", displayMode: .inline)
            .navigationBarItems(trailing: Button("Save") {
                print("save new order")
                // Lägg till funs för att spara den nya ordern här
            })
    }
}


struct AddOrderView_Previews: PreviewProvider {
    static var previews: some View {
        AddOrderView()
    }
}
