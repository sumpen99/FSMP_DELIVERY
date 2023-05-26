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
    @State var isRemoveCustomer:Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                TextEditor(text: Binding(get: { chosenCustomerDetails }, set: { _ in }))
                    .disabled(true)
                    .padding()
                if let customer = choosenCustomer {
                        HStack{
                            NavigationLink(destination:LazyDestination(destination: {
                                AddOrderView(customer: Binding(get: { customer }, set: { _ in }))})){
                                    Text("Add order")
                            }
                            .buttonStyle(CustomButtonStyle1())
                            .padding(.leading, 20)
                            removeCustomerButton
                        }
                    }
                    
                else{
                    Spacer()
                }
                
                List{
                    ForEach(firestoreVM.customers) { customer in
                        getListButton(customer: customer)
                    }
                    .onReceive(firestoreVM.$customers) { (customers) in
                        guard !customers.isEmpty else { return }
                        choosenCustomer = customers.first
                    }
                }
            }
            .navigationBarItems(trailing: NavigationLink(destination: CreateCustomerView()){
                Text(Image(systemName: "plus.circle"))
            })
            .navigationTitle("Customers")
        }
        .alert(isPresented: $isRemoveCustomer, content: {
            onConditionalAlert(actionPrimary: removeCustomer,
                               actionSecondary: { })
        })
        /*.onAppear() {
            firestoreVM.listenToFirestoreCustomers()
            if let firstCustomer = firestoreVM.customers.first {
                choosenCustomer = firstCustomer
            }
        }*/
    }
    
    func getListButton(customer:Customer) -> some View{
        return HStack {
            Button(action: { choosenCustomer = customer }){
                Text(customer.name)
            }
            Spacer()
            Image(systemName: "checkmark.circle.fill")
                .opacity(choosenCustomer?.customerId == customer.customerId ? 1.0 : 0.0)
                .foregroundColor(.gray)
        }
    }
    
    var removeCustomerButton:some View{
        Button(action: { setAlertRemoveCustomer() }){
            Text(Image(systemName: "person.crop.circle.badge.minus"))
                .font(.largeTitle).multilineTextAlignment(.leading)
              
        }
        .hTrailing()
        .padding(.trailing,20.0)
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
    
    private func removeCustomer(){
        guard let customer = choosenCustomer else {
            return
        }
        firestoreVM.removeCustomer(customer)
    }
    
    private func setAlertRemoveCustomer(){
        let name = choosenCustomer?.name ?? "kunden"
        ALERT_TITLE = "Ta bort kund"
        ALERT_MESSAGE = "All information om \(name) kommer raderas.\n\nFortsätt?"
        isRemoveCustomer.toggle()
    }
}

struct CustomerView_Previews: PreviewProvider {
    static var previews: some View {
        CustomerView()
            .environmentObject(FirestoreViewModel())
    }
}
