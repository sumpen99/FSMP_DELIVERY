//
//  QrScannerView.swift
//  FSMP_DELIVERY
//
//  Created by fredrik sundström on 2023-05-18.
//

import SwiftUI

class ScannerViewModel: ObservableObject {
    
    let scanInterval: Double = 1.0
    
    @Published var torchIsOn: Bool = false
    @Published var lastQrCode: String = "Qr-code goes here"
    @Published var isPrivacyResult = false
    
    
    func onFoundQrCode(_ code: String) {
        self.lastQrCode = code
    }
}

struct QrScannerView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var isPrivacyResult = false
    @ObservedObject var scannerViewModel = ScannerViewModel()
    let qrQodeScannerView = QrCodeScannerView()
    
    var body: some View {
        ZStack {
            qrQodeScannerView
            .found(r: self.scannerViewModel.onFoundQrCode)
            .torchLight(isOn: self.scannerViewModel.torchIsOn)
            .interval(delay: self.scannerViewModel.scanInterval)
            VStack {
                captureBox
                //scannerBox
                Spacer()
                lightButton
            }.padding()
        }
        .alert(isPresented: $scannerViewModel.isPrivacyResult, content: {
            onPrivacyAlert(actionPrimary: openPrivacySettings,
                           actionSecondary: closeScannerView)
        })
        .onAppear{
            print("appear")
        }
        .environmentObject(scannerViewModel)
    }
    
    var body2: some View{
        NavigationStack {
            VStack {
                getQrImage()?.resizable().frame(width: 200, height: 200)
            }
        }
    }
    
    var scannerBox: some View{
        GeometryReader { geometry in
            let cutoutWidth: CGFloat = min(geometry.size.width, geometry.size.height) / 2.5

            Path { path in
                
                let left = (geometry.size.width - cutoutWidth) / 2.0
                let right = left + cutoutWidth
                let top = (geometry.size.height - cutoutWidth) / 2.0
                let bottom = top + cutoutWidth
                
                path.addPath(
                    createCornersPath(
                        left: left, top: top,
                        right: right, bottom: bottom,
                        cornerRadius: 40, cornerLength: 20
                    )
                )
            }
            .stroke(Color.blue, lineWidth: 8)
            .frame(width: cutoutWidth, height: cutoutWidth, alignment: .center)
            .aspectRatio(1, contentMode: .fit)
        }
    }
    
    var captureBox: some View{
        VStack {
            Text("Keep scanning for QR-codes")
                .font(.subheadline)
            Text(self.scannerViewModel.lastQrCode)
                .bold()
                .lineLimit(5)
                .padding()
        }
        .padding(.vertical, 20)
    }
    
    var lightButton: some View{
        HStack {
            Button(action: {
                if QrCodeScannerView.cameraPermissionIsAllowed(){
                    self.scannerViewModel.torchIsOn.toggle()
                }
            }, label: {
                Image(systemName: self.scannerViewModel.torchIsOn ? "bolt.fill" : "bolt.slash.fill")
                    .imageScale(.large)
                    .foregroundColor(self.scannerViewModel.torchIsOn ? Color.yellow : Color.blue)
                    .padding()
            })
        }
        .background(Color.white)
        .cornerRadius(10)
    }
    
    func closeScannerView(){
        dismiss()
    }
    
    func openPrivacySettings(){
        guard let url = URL(string: UIApplication.openSettingsURLString),
                UIApplication.shared.canOpenURL(url) else {
                    assertionFailure("Not able to open App privacy settings")
                    return
            }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    private func createCornersPath(
            left: CGFloat,
            top: CGFloat,
            right: CGFloat,
            bottom: CGFloat,
            cornerRadius: CGFloat,
            cornerLength: CGFloat
        ) -> Path {
            var path = Path()

            // top left
            path.move(to: CGPoint(x: left, y: (top + cornerRadius / 2.0)))
            path.addArc(
                center: CGPoint(x: (left + cornerRadius / 2.0), y: (top + cornerRadius / 2.0)),
                radius: cornerRadius / 2.0,
                startAngle: Angle(degrees: 180.0),
                endAngle: Angle(degrees: 270.0),
                clockwise: false
            )

            path.move(to: CGPoint(x: left + (cornerRadius / 2.0), y: top))
            path.addLine(to: CGPoint(x: left + (cornerRadius / 2.0) + cornerLength, y: top))

            path.move(to: CGPoint(x: left, y: top + (cornerRadius / 2.0)))
            path.addLine(to: CGPoint(x: left, y: top + (cornerRadius / 2.0) + cornerLength))

            // top right
            path.move(to: CGPoint(x: right - cornerRadius / 2.0, y: top))
            path.addArc(
                center: CGPoint(x: (right - cornerRadius / 2.0), y: (top + cornerRadius / 2.0)),
                radius: cornerRadius / 2.0,
                startAngle: Angle(degrees: 270.0),
                endAngle: Angle(degrees: 360.0),
                clockwise: false
            )

            path.move(to: CGPoint(x: right - (cornerRadius / 2.0), y: top))
            path.addLine(to: CGPoint(x: right - (cornerRadius / 2.0) - cornerLength, y: top))

            path.move(to: CGPoint(x: right, y: top + (cornerRadius / 2.0)))
            path.addLine(to: CGPoint(x: right, y: top + (cornerRadius / 2.0) + cornerLength))

            // bottom left
            path.move(to: CGPoint(x: left + cornerRadius / 2.0, y: bottom))
            path.addArc(
                center: CGPoint(x: (left + cornerRadius / 2.0), y: (bottom - cornerRadius / 2.0)),
                radius: cornerRadius / 2.0,
                startAngle: Angle(degrees: 90.0),
                endAngle: Angle(degrees: 180.0),
                clockwise: false
            )
            
            path.move(to: CGPoint(x: left + (cornerRadius / 2.0), y: bottom))
            path.addLine(to: CGPoint(x: left + (cornerRadius / 2.0) + cornerLength, y: bottom))

            path.move(to: CGPoint(x: left, y: bottom - (cornerRadius / 2.0)))
            path.addLine(to: CGPoint(x: left, y: bottom - (cornerRadius / 2.0) - cornerLength))

            // bottom right
            path.move(to: CGPoint(x: right, y: bottom - cornerRadius / 2.0))
            path.addArc(
                center: CGPoint(x: (right - cornerRadius / 2.0), y: (bottom - cornerRadius / 2.0)),
                radius: cornerRadius / 2.0,
                startAngle: Angle(degrees: 0.0),
                endAngle: Angle(degrees: 90.0),
                clockwise: false
            )
            
            path.move(to: CGPoint(x: right - (cornerRadius / 2.0), y: bottom))
            path.addLine(to: CGPoint(x: right - (cornerRadius / 2.0) - cornerLength, y: bottom))

            path.move(to: CGPoint(x: right, y: bottom - (cornerRadius / 2.0)))
            path.addLine(to: CGPoint(x: right, y: bottom - (cornerRadius / 2.0) - cornerLength))

            return path
        }
    
    
    
    func getQrImage() -> Image?{
        guard let data = generateQrCode(strValue:UUID().uuidString),
              let uiImage = UIImage(data: data) else { return nil}
              
        return Image(uiImage:uiImage)
    }
    
    func generateQrCode(strValue:String) -> Data?{
        guard let filter = CIFilter(name: "CIQRCodeGenerator") else { return nil }
        let data = strValue.data(using: .ascii, allowLossyConversion: false)
        filter.setValue(data, forKey: "inputMessage")
        guard let ciimage = filter.outputImage else { return nil }
        let transform = CGAffineTransform(scaleX: 10, y: 10)
        let scaledCIImage = ciimage.transformed(by: transform)
        let uiimage = UIImage(ciImage: scaledCIImage)
        return uiimage.pngData()
    }
}
