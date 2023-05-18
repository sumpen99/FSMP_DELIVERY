//
//  SignOfOrderView.swift
//  FSMP_DELIVERY
//
//  Created by fredrik sundström on 2023-05-17.
//

import SwiftUI

struct SignOfOrderView: View{
    let OFFSET = 10.0
    @State var pointsList:[[CGPoint]] = []
    @State var addNewPoint = true
    @State var qrCode = QrCode()
    @State var isFormSignedResult:Bool = false
    @State private var renderedImage:Image?
    @EnvironmentObject var firestoreViewModel: FirestoreViewModel
    @Environment(\.displayScale) var displayScale
    var body: some View{
        NavigationStack {
            signedForm
        }
        .alert(isPresented: $isFormSignedResult, content: {
            onResultAlert{ }
        })
        .toolbar {
            ToolbarItemGroup{
                Button(action: clearAllDrawnLines) {
                    Image(systemName: "qrcode.viewfinder")
                }
                Button(action: uploadSignedForm) {
                    Image(systemName: "square.and.arrow.up")
                }
            }
        }
    }
    
    var signedForm: some View{
        return VStack{
            Form{
                Section(header: Text("Datum")){
                    Text(Date().toISO8601String())
                    .font(.largeTitle)
                    .foregroundColor(.gray)
                }
                Section(header: Text("Verifierad Qr-Kod")){
                    Text("")
                    .font(.largeTitle)
                    .foregroundColor(.gray)
                }
                Section(header: Text("Signatur (shake device to clear)")){
                    renderedImage
                }
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
                            addNewPoint = true
                        }))
                .onShake{
                    clearAllDrawnLines()
                }
                currentSignaturePath
                Text(pointsList.isEmpty ? "Underskrift" : "")
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
        .onChange(of: addNewPoint, perform: { _ in
            renderCurrentSignaturePath()
            
        })
        .padding([.leading,.trailing],10)
               
    }
    
    var currentSignaturePath:some View{
        return Path { path in
            for i in 0..<pointsList.count {
                let pointsToDraw = pointsList[i]
                path.addPath(DrawShape(points:pointsToDraw).path())
            }
        }
        .stroke(lineWidth:2)
        .foregroundColor(.black)
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
                        Text("muraregatan")
                            .font(.caption)
                        Text("Datum")
                        Text(Date().toISO8601String())
                            .font(.caption)
                        Text("Verifierad Qr-Kod")
                        Text("123456789")
                            .font(.caption)
                           
                    }
                    Spacer()
                    Text("Signatur").foregroundColor(.gray)
                    renderedImage
                }
                .hLeading()
                .frame(width:400,height:800)
    }
    
    private func uploadSignedForm(){
        if !qrCode.verified && renderedImage == nil{
            setFormResult(.FORM_NOT_FILLED)
            return
        }
      
        guard let documentDirectory = documentDirectory else {
            setFormResult(.USER_URL_ERROR)
            return
            
        }
        let filePath = UUID().uuidString
        guard let fileUrl = formAsPdf.exportAsPdf(documentDirectory: documentDirectory,filePath:filePath) else{
            setFormResult(.USER_URL_ERROR)
            return
        }
        firestoreViewModel.uploadSignedFormPDf(url:fileUrl,orderNumber:filePath){ result in
            setFormResult(result)
        }
    }
    
    private func renderCurrentSignaturePath(){
        if pointsList.isEmpty { return }
        let boundaries = pointsList.getBoundaries()
        let uiImage =   currentSignaturePath
                        .frame(width:boundaries.x,height:boundaries.y)
                        .padding([.trailing,.bottom])
                        .snapshot()
        renderedImage = Image(uiImage: uiImage)
    }
    
    private func clearAllDrawnLines(){
        addNewPoint = true
        pointsList.removeAll()
        renderedImage = nil
    }
    
    private func addNewPoint(_ value:CGPoint){
        if addNewPoint{
            pointsList.append([])
            addNewPoint = false
        }
        let currentLine = max(0,pointsList.count - 1)
        pointsList[currentLine].append(value)
    }
       
    
    private func insideViewFrame(_ frame:CGRect,newLocation:CGPoint) ->Bool{
        return newLocation.x >= frame.minX+OFFSET && newLocation.x <= frame.minX + frame.width - OFFSET &&
               newLocation.y >= frame.minY+OFFSET && newLocation.y <= frame.minY + frame.height - OFFSET
    }
    
    private func setFormResult(_ signedFormResult:SignedFormResult){
        let desc = signedFormResult.describeYourSelf
        ALERT_TITLE = desc.title
        ALERT_MESSAGE = desc.message
        isFormSignedResult.toggle()
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



