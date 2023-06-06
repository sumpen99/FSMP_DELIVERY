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
    @State var prVar = ProgressViewVar()
    @Binding var customer : Customer
    let qrCode:(qrImage:Image?,orderId:String?) = getQrImage()
    
    var isNotValidForm:Bool {
        return (prVar.orderName.isEmpty ||
                prVar.description.isEmpty ||
                qrCode.orderId == nil ||
                qrCode.qrImage == nil)
    }
    
    var body: some View {
        NavigationStack {
            ZStack{
                VStack {
                    formSections
                }
                if prVar.isShowing{ LoadingView(loadingtext: $prVar.loadingText) }
            }
        }
        .opacity(prVar.closeOnTapped ? 0.0 : 1.0)
        .navigationBarBackButtonHidden(prVar.isShowing)
        .alert(isPresented: $prVar.isFormSignedResult, content: {
            onResultAlert(){
                if prVar.isEnabled{
                    withAnimation(Animation.spring().speed(0.2)) {
                        prVar.closeOnTapped.toggle()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
            }
        })
        .navigationTitle("Create order for \(customer.name)")
        .fontWeight(.regular)
        .toolbar {
            ToolbarItemGroup{
                orderButton
                    .disabled(prVar.isShowing)
            }
        }
    }
    
    var formSections: some View {
        Form{
            Section(header: Text("Order Details")) {
                TextField("Order Name", text: $prVar.orderName)
                TextField("Description", text: $prVar.description)
                Text(prVar.currentDateISO8601String)
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
                    Text("FSMP - SERVICE")
                    .font(.system(size: 40, weight: .heavy, design: .rounded))
                    .padding()
                    Section(
                        header: Text("Bekräftelse av mottagen order").font(.title2),
                        footer: Text("\(prVar.currentDateISO8601String)")){
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
                            Text(prVar.orderName + "\n" + prVar.description)
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
        prVar.setEnabled()
        firestoreVM.addNewOrderToCustomer(customer: customer, newOrder:newOrder,fileUrl:fileUrl){ result in
            if result == .FORM_SAVED_SUCCESFULLY{
                sendMailVerificationToCustomer(fileUrl: fileUrl,fileName: fileName){ sent in
                    if sent{
                        setFormResult(.FORM_SAVED_SUCCESFULLY)
                    }
                    else{
                        setFormResult(.FORM_SIGNED_BUT_NO_MAIL_WAS_SENT)
                    }
                }
            }
            else{
                setFormResult(result)
            }
        }
    }
    
    private func sendMailVerificationToCustomer(fileUrl:URL,
                                                fileName:String,
                                                completion:@escaping (Bool)->Void){
            prVar.setLoadingTextForMail()
            firestoreVM.getCredentials(){ credentials in
            guard let credentials = credentials else { completion(false);return }
            let manager = MailManager(credentials:credentials)
            manager.onResult = completion
            manager.sendOrderResponseMailTo(customer:customer,fileUrl:fileUrl)
        }
    }
    
    
    func getOrder() -> Order?{
        if isNotValidForm{
            return nil
        }
        return Order(ordername: prVar.orderName,
                     details: prVar.description,
                     customer: customer.lightVersion(),
                     orderId: qrCode.orderId ?? "",
                     assignedUser: "",
                     initDate:prVar.currentDate)
    }
    
    private func setFormResult(_ signedFormResult:SignedFormResult){
        let desc = signedFormResult.describeYourSelf
        ALERT_TITLE = desc.title
        ALERT_MESSAGE = desc.message
        if prVar.isShowing { prVar.isShowing = false }
        prVar.isFormSignedResult.toggle()
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
