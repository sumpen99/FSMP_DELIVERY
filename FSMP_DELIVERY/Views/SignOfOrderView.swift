//
//  SignOfOrderView.swift
//  FSMP_DELIVERY
//
//  Created by fredrik sundström on 2023-05-17.
//

import SwiftUI

struct LazyDestination<Destination: View>: View {
    var destination: () -> Destination
    var body: some View {
        self.destination()
    }
}

struct SignOfOrderView: View{
    @Environment(\.displayScale) var displayScale
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var firestoreViewModel: FirestoreViewModel
    @State private var renderedImage:Image?
    @State var prVar = ProgressViewVar()
    let currentOrder:Order?
   
    var body: some View{
        NavigationStack {
            ZStack{
                signedForm
                if prVar.isShowing{ LoadingView(loadingtext: "Laddar upp...") }
            }
        }
        .opacity(prVar.closeOnTapped ? 0.0 : 1.0)
        .navigationBarBackButtonHidden(prVar.isShowing)
        .alert(isPresented: $prVar.isFormSignedResult, content: {
            onResultAlert{
                if prVar.isEnabled{
                    withAnimation(Animation.spring().speed(0.2)) {
                        prVar.closeOnTapped.toggle()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                              dismiss()
                        }
                    }
                }
            }
        })
        .onAppear(){
            prVar.scannedQrCode = SCANNED_QR_CODE
        }
        .onDisappear(){
            SCANNED_QR_CODE = ""
        }
        .toolbar {
            ToolbarItemGroup{
                NavigationLink(destination:LazyDestination(destination: { QrView() })) {
                    Image(systemName: "qrcode.viewfinder")
                }.disabled(prVar.isShowing)
            }
        }
    }
    
    var signedForm: some View{
        return VStack{
            Form{
                Section(header: Text("Datum")){
                    Text(prVar.currentDateISO8601String)
                    .font(.title3)
                    .foregroundColor(.gray)
                }
                Section(header: Text("Qr-Kod")){
                    Text(prVar.scannedQrCode)
                    .font(.title3)
                    .foregroundColor(.gray)
                }
                if renderedImage != nil{
                    Section(header: Text("Signatur")){
                        renderedImage
                    }
                }
                
                uploadSignedOrderButton
            }
            Spacer()
            selfSignedCanvas
        }
    }
    
    var selfSignedCanvas: some View {
        return GeometryReader{ reader in
            ZStack(alignment:.center){
                Rectangle()
                .foregroundColor(.white)
                .gesture(DragGesture(minimumDistance: 0.0)
                        .onChanged( { value in
                            if insideViewFrame(reader.frame(in: .local),newLocation:value.location){
                                self.addNewPoint(value.location)
                            }
                        })
                        .onEnded({ value in
                            prVar.addNewPoint = true
                        }))
                .onShake{
                    clearAllDrawnLines()
                }
                currentSignaturePath
                Text(prVar.pointsList.isEmpty ? "Underskrift" : "")
                    .foregroundColor(.gray)
            }
        }
        .hLeading()
        .frame(height:80.0)
        .cornerRadius(25.0)
        .overlay(
            RoundedRectangle(cornerRadius: 25)
                .stroke(Color.gray,lineWidth: 2)
        )
        .onChange(of: prVar.addNewPoint, perform: { _ in
            renderCurrentSignaturePath()
            
        })
        .padding([.leading,.trailing],10)
               
    }
    
    var currentSignaturePath:some View{
        return Path { path in
            for i in 0..<prVar.pointsList.count {
                let pointsToDraw = prVar.pointsList[i]
                path.addPath(DrawShape(points:pointsToDraw).path())
            }
        }
        .stroke(lineWidth:2)
        .foregroundColor(.gray)
    }
    
    var formAsPdf:some View{
        return VStack(alignment:.center,spacing:5){
                    Image("delivery")
                        .resizable()
                        .frame(width:200,height:200)
                    Text("FSMP - Delivery")
                    .font(.system(size: 40, weight: .heavy, design: .rounded))
                    .padding()
                    Section(header: Text("Bekräftelse av mottagen service")){
                        Text("Order")
                        Text(currentOrder?.ordername ?? "" + "\n" + (currentOrder?.details ?? ""))
                            .font(.caption)
                        Text("Datum")
                        Text(prVar.currentDateISO8601String)
                            .font(.caption)
                        Text("Verifierad Qr-Kod")
                        Text(prVar.scannedQrCode)
                            .font(.caption)
                           
                    }
                    Spacer()
                    Text("Signatur").foregroundColor(.gray)
                    renderedImage
                }
                .hLeading()
                .frame(width:400,height:800)
    }
    
    var uploadSignedOrderButton: some View{
        HStack{
            Button(action: uploadSignedForm ) {
                Text("Spara")
            }
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(prVar.isShowing ? .accentColor : .blue)
        }
        .disabled(prVar.isShowing)
    }
    
    private func uploadSignedForm(){
        guard let currentOrder = currentOrder?.getSignedVersion() else { return }
        if !formIsSignedCorrect(orderId: currentOrder.orderId){ return }
        let fileName = "signed" + currentOrder.orderId
        guard let url = getPdfUrlPath(fileName: fileName),let fileUrl = formAsPdf.exportAsPdf(renderedUrl: url)
        else{ setFormResult(.USER_URL_ERROR); return }
        
        prVar.setEnabled()
        firestoreViewModel.moveOrderFromInProcessToSigned(currentOrder: currentOrder, fileUrl: fileUrl){ result in
            if result == .FORM_SAVED_SUCCESFULLY{
                sendMailVerificationToCustomer(currentOrder.customer,fileUrl: fileUrl,fileName: fileName){ sent in
                    if sent{
                        setFormResult(.FORM_SIGNED_SUCCESFULLY)
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
    
    private func sendMailVerificationToCustomer(_ customer:Customer,
                                                fileUrl:URL,
                                                fileName:String,
                                                completion:@escaping (Bool)->Void){
        firestoreViewModel.getCredentials(){ credentials in
            guard let credentials = credentials else { completion(false);return }
            let manager = MailManager(credentials:credentials)
            manager.onResult = completion
            manager.sendSignedResponseMailTo(customer,fileUrl:fileUrl)
        }
    }
    
    private func renderCurrentSignaturePath(){
        if prVar.pointsList.isEmpty { return }
        let boundaries = prVar.pointsList.getBoundaries()
        let uiImage =   currentSignaturePath
                        .frame(width:boundaries.x,height:boundaries.y)
                        .padding([.trailing,.bottom])
                        .snapshot()
        renderedImage = Image(uiImage: uiImage)
    }
    
    private func clearAllDrawnLines(){
        prVar.addNewPoint = true
        prVar.pointsList.removeAll()
        renderedImage = nil
    }
    
    private func addNewPoint(_ value:CGPoint){
        if prVar.addNewPoint{
            prVar.pointsList.append([])
            prVar.addNewPoint = false
        }
        let currentLine = max(0,prVar.pointsList.count - 1)
        prVar.pointsList[currentLine].append(value)
    }
    
    private func formIsSignedCorrect(orderId:String) -> Bool{
        var validSignature = false
        var validQrCode = false
        
        if !prVar.pointsList.isEmpty{
            var signatureCount = 0
            for p in prVar.pointsList{
                signatureCount += p.count
            }
            validSignature = signatureCount >= 50
        }
        
        if  renderedImage == nil && SCANNED_QR_CODE.isEmpty{
            setFormResult(.FORM_NOT_FILLED)
            return false
        }
        
        else if renderedImage != nil && SCANNED_QR_CODE.isEmpty{
            if !validSignature{
                setFormResult(.SIGNATURE_IS_NOT_VALID)
                return false
            }
        }
        
        else if !SCANNED_QR_CODE.isEmpty && renderedImage == nil{
            validQrCode = (SCANNED_QR_CODE == orderId)
            if !validQrCode{
                setFormResult(.QR_CODE_IS_NOT_A_MATCH)
                return false
            }
        }
        
        if !validSignature && !validQrCode{
            setFormResult(.SIGNATURE_AND_QRCODE_MISSMATCH)
            return false
        }
        
        return true
    }
    
    private func insideViewFrame(_ frame:CGRect,newLocation:CGPoint) ->Bool{
        let OFFSET = 10.0
        return newLocation.x >= frame.minX+OFFSET && newLocation.x <= frame.minX + frame.width - OFFSET &&
               newLocation.y >= frame.minY+OFFSET && newLocation.y <= frame.minY + frame.height - OFFSET
    }
    
    private func setFormResult(_ signedFormResult:SignedFormResult){
        let desc = signedFormResult.describeYourSelf
        ALERT_TITLE = desc.title
        ALERT_MESSAGE = desc.message
        if prVar.isShowing { prVar.isShowing = false }
        prVar.isFormSignedResult.toggle()
    }
    
}

struct DrawShape{
    var points:[CGPoint]
    
    func path() -> Path{
        var path = Path()
        guard let firstPoint = points.first else { return path}
        
        path.move(to: firstPoint)
        for pointIndex in 1..<points.count{
            path.addLine(to: points[pointIndex])
        }
        
        return path
    }
}




struct SizePreferenceKey: PreferenceKey {
  static var defaultValue: CGSize = .zero
  static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
}



