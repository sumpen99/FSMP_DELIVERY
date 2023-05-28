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
    @State var isUploadAttempt = false
    @State var showProgressOfUploadOrder = false
    var isValidForm = false
    let currentDate = Date()
    let currentDateString:String = Date().toISO8601String()
    @Binding var customer : Customer
    let qrCode:(qrImage:Image?,orderId:String?) = getQrImage()
    
    var isNotValidForm:Bool {
        return (orderName.isEmpty || description.isEmpty || qrCode.orderId == nil || qrCode.qrImage == nil)
    }
    
    var body: some View {
        NavigationStack {
            ZStack{
                VStack {
                    formSections
                }
                if showProgressOfUploadOrder{
                    LoadingView(loadingtext: "Laddar upp...")
                    
                }
            }
        }
        .navigationBarBackButtonHidden(showProgressOfUploadOrder)
        .alert(isPresented: $isUploadAttempt, content: {
            onResultAlert(){
                if !isNotValidForm{
                    presentationMode.wrappedValue.dismiss()
                }
            }
        })
        .navigationTitle("Create order for \(customer.name)")
        .fontWeight(.regular)
        .toolbar {
            ToolbarItemGroup{
                orderButton
                    .disabled(showProgressOfUploadOrder)
            }
        }
    }
    
    var formSections: some View {
        Form{
            Section(header: Text("Order Details")) {
                TextField("Order Name", text: $orderName)
                TextField("Description", text: $description)
                Text(currentDateString)
            }
            
            Section(header: Text("Qr-Code")) {
                qrCode.qrImage?.resizable().frame(width: 150.0,height: 150.0)
            }
        }
    }
    
    var orderButton: some View{
        Button(action: { verifyAndUpload()}){
            Image(systemName: "square.and.arrow.up")
        }
    }
    
    var formAsPdf:some View{
        return VStack(alignment:.center,spacing:5){
                    Image("delivery")
                        .resizable()
                        .frame(width:200,height:200)
                    Text("FSMP - Delivery")
                    .font(.system(size: 40, weight: .heavy, design: .rounded))
                    .padding()
                    Section(
                        header: Text("Bekräftelse av mottagen order").font(.title2),
                        footer: Text("\(currentDateString)")){
                        Text("Namn")
                        Text(customer.name)
                            .font(.caption)
                        Text("Adress")
                        Text(customer.adress + "\n" + customer.postcode)
                            .font(.caption)
                        Text("Email")
                        Text(customer.email)
                            .font(.caption)
                        Text("Order Id")
                            Text(qrCode.orderId ?? "")
                            .font(.caption)
                        Text("Information")
                        Text(orderName + "\n" + description)
                            .font(.caption)
                    }
                    Spacer()
                    qrCode.qrImage?.resizable().frame(width: 150.0,height: 150.0)
                }
                .hLeading()
                .frame(width:400,height:800)
    }
    
    private func verifyAndUpload(){
        guard let newOrder = getOrder() else{
            setFormResult(.ORDER_NOT_ACCEPTABLE)
            return
        }
      
        let fileName = "added" + (qrCode.orderId ?? "")
        guard let url = getPdfUrlPath(fileName: fileName),
              let fileUrl = formAsPdf.exportAsPdf(renderedUrl: url) else{
            setFormResult(.USER_URL_ERROR)
            return
        }
        showProgressOfUploadOrder.toggle()
        firestoreVM.updateCustomerWithNewOrder(customer,orderId: newOrder.orderId)
        firestoreVM.setOrderInProcessDocument(newOrder)
        firestoreVM.uploadFormPDf(
            url:fileUrl,
            orderType:.ORDER_IN_PROCESS,
            orderNumber:newOrder.orderId){ result in
            if result == .FORM_SAVED_SUCCESFULLY{
                sendMailVerificationToCustomer(fileUrl: fileUrl,fileName:fileName)
            }
            else{
                showProgressOfUploadOrder.toggle()
                setFormResult(result)
            }
        }
    }
    
    private func sendMailVerificationToCustomer(fileUrl:URL,fileName:String){
        firestoreVM.getCredentials(){ credentials in
            guard let credentials = credentials else { return }
            let manager = MailManager(credentials:credentials)
            manager.onResult = { result in
                showProgressOfUploadOrder.toggle()
                removeOneOrderFromFolder(fileName: fileName)
                if result{
                    setFormResult(.FORM_SAVED_SUCCESFULLY)
                }
                else{
                    setFormResult(.FORM_SAVED_BUT_NO_MAIL_WAS_SENT)
                }
            }
            manager.sendOrderResponseMailTo(customer:customer,fileUrl:fileUrl)
                
        }
    }
    
    func getOrder() -> Order?{
        if isNotValidForm{
            return nil
        }
        return Order(ordername: orderName,
                     details: description,
                     customer: customer,
                     orderId: qrCode.orderId ?? "",
                     initDate:currentDate)
    }
    
    private func setFormResult(_ signedFormResult:SignedFormResult){
        let desc = signedFormResult.describeYourSelf
        ALERT_TITLE = desc.title
        ALERT_MESSAGE = desc.message
        isUploadAttempt.toggle()
    }
    
}


struct AddOrderView_Previews: PreviewProvider {
    static var previews: some View {
        var customer = Customer( customerId:"12334",name: "janne",adress: "",postcode:"", email: "asd", phoneNumber: 12, taxnumber: 123) // Create an instance of Customer
        
        return AddOrderView(customer: Binding<Customer>(
            get: { customer },
            set: { customer = $0 }
        ))
    }
}
