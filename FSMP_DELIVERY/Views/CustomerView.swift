//
//  CustomerView.swift
//  FSMP_DELIVERY
//
//  Created by Philip Andersson on 2023-05-15.
//

import SwiftUI

struct CustomerView: View {
    @EnvironmentObject var firebaseAuth: FirebaseAuth
    @EnvironmentObject var firestoreVM: FirestoreViewModel
    @State private var choosenCustomer : Customer? = nil
    @State var isRemoveCustomer:Bool = false
    @State private var showAlertForDelete = false
    @State private var indexSetToDelete: IndexSet?
    
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
                                    Text("Create order \(Image(systemName: "square.and.pencil"))")
                            }
                            .buttonStyle(CustomButtonStyle1())
                            .padding(.leading, 20)
                            
                            NavigationLink(destination: LazyDestination(destination: {ManageCustomerView(customerToEdit: Binding(get: {customer}, set: { _ in }))})){
                                Image(systemName: "gearshape")
                            }
                        }
                    }
                    
                else{
                    Spacer()
                }
                
                List{
                    ForEach(firestoreVM.customers,id: \.customerId) { customer in
                        getListButton(customer: customer)
                    }
                    .onDelete() { indexSet in
                        self.showAlertForDelete = true
                        self.indexSetToDelete = indexSet
                    }
                    .deleteDisabled(firebaseAuth.loggedInAs != .ADMIN)
                    .onReceive(firestoreVM.$customers) { (customers) in
                        guard !customers.isEmpty else { return }
                        guard let choosenCustomer = choosenCustomer
                        else { choosenCustomer = customers.first;return}
                        findActivatedLastCustomer(customerId: choosenCustomer.customerId, customers: customers)
                    }
                    .alert(isPresented: $showAlertForDelete) {
                        let name = choosenCustomer?.name ?? "kunden"
                        return Alert(title: Text("Vill du ta bort \(name)?"),
                              message: Text("Allt information om \(name) kommer raderas!. Är du säker på att du vill fortsätta?"),
                              primaryButton: .destructive(Text("Ta bort")) {
                            if let indexSet = indexSetToDelete {
                                for index in indexSet {
                                        let customerToRemove = firestoreVM.customers[index]
                                        firestoreVM.removeCustomer(customerToRemove)
                                }
                            }
                        },
                              secondaryButton: .cancel {
                            showAlertForDelete = false
                        })
                    }
                }
            }
            .onDisappear(){
                firestoreVM.closeListenerCustomers()
            }
            .onAppear{
                firestoreVM.initializeListenerCustomers()
            }
            .navigationBarItems(trailing: NavigationLink(destination: CreateCustomerView()){
                Text(Image(systemName: "plus.circle"))
            })
            .navigationTitle("Customers")
        }
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
        details += "Adress: \(customer.adress)\n"
        details += "Postkod: \(customer.postcode)\n"
        details += "Phone Number: \(customer.phoneNumber)\n"
        details += "Description: \(customer.description)\n"
        details += "Tax Number: \(customer.taxnumber)"
        
        return details
    }
    
    func findActivatedLastCustomer(customerId:String,customers:[Customer]){
        guard let index = customers.firstIndex(where: {
            $0.customerId == customerId
        })
        else{
            guard let firstCustomer = customers.first else { return }
            choosenCustomer = firstCustomer
            return
        }
        choosenCustomer = customers[index]
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
            .environmentObject(FirebaseAuth())
            .environmentObject(FirestoreViewModel())
    }
}
