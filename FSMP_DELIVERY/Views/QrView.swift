//
//  QrView.swift
//  FSMP_DELIVERY
//
//  Created by fredrik sundström on 2023-05-19.
//

import SwiftUI

struct QrView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var scannerViewModel = ScannerViewModel()
    @State private var isPrivacyResult = false
    @State private var closeOnTappedToast:Bool = false
    let scannerView = QrScannerView()
    
    /*init(){
        print("init qrview")
    }*/
    
    var body: some View {
        ZStack {
            scannerView
            .found(r: scannerViewModel.onFoundQrCode)
            //.reset(r: scannerViewModel.onResetQrCode)
            .torchLight(isOn: scannerViewModel.torchIsOn)
            .interval(delay: scannerViewModel.scanInterval)
            .environmentObject(scannerViewModel)
            scannerBox
            toastLastReadQrCode
        }
        .opacity(closeOnTappedToast ? 0.0 : 1.0)
        .alert(isPresented: $scannerViewModel.isPrivacyResult, content: {
            onConditionalAlert(actionPrimary: openPrivacySettings,
                           actionSecondary: closeScannerView)
        })
        .toolbar {
            ToolbarItemGroup{
                lightButton
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    var scannerBox: some View{
        GeometryReader { geometry in
            if scannerViewModel.foundQrCode{
                Path { path in
                    path.addPath(
                        createCornersPath()
                    )
                }
                .stroke(Color.green, lineWidth:4)
            }
        }
    }
    
    var toastLastReadQrCode: some View {
        withAnimation(.linear(duration: 5)){
            VStack{
                if scannerViewModel.lastQrCode != ""{
                    Spacer()
                    VStack{
                        Text(scannerViewModel.lastQrCode)
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color.white)
                            .font(.system(size: 14))
                            .padding(20)
                        HStack(){
                            foundQrCloseButton
                            Spacer()
                            foundQrOkButton
                        }
                        .padding()
                    }
                    .background(Color.black.opacity(0.588))
                    .cornerRadius(8)
                    .padding()
                }
            }
            
        }
        
    }
    
    var lightButton: some View{
        Button(action: {
            if QrScannerView.cameraPermissionIsAllowed(){
                scannerViewModel.torchIsOn.toggle()
            }
        }, label: {
            Image(systemName: scannerViewModel.torchIsOn ? "bolt.fill" : "bolt.slash.fill")
                .imageScale(.large)
                .foregroundColor(scannerViewModel.torchIsOn ? Color.yellow : Color.blue)
                .padding()
        })
    }
    
    var foundQrOkButton: some View{
        Button(action: {
            withAnimation(Animation.spring().speed(0.2)) {
                closeOnTappedToast.toggle()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                      closeScannerView()
                }
            }
        }, label: {
            Image(systemName:"checkmark.circle")
                .font(.largeTitle)
                .foregroundColor(Color.green)
        })
        .padding(.trailing)
    }
    
    var foundQrCloseButton: some View{
        Button(action: {
            scannerViewModel.onReset()
        }, label: {
            Image(systemName:"xmark.circle")
                .font(.largeTitle)
                .foregroundColor(Color.red)
        })
        .padding(.leading)
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
    
    private func createCornersPath() -> Path {
            var path = Path()

            let left = scannerViewModel.left
            let right = scannerViewModel.right
            let top = scannerViewModel.top
            let bottom = scannerViewModel.bottom
            let width = right - left
            let radius = width / 20.0 / 2.0
            let cornerLength = width / 10.0
        
            path.move(to: CGPoint(x: left, y: top + radius))
            path.addArc(
                center: CGPoint(x: left + radius, y: top + radius),
                radius: radius,
                startAngle: Angle(degrees: 180.0),
                endAngle: Angle(degrees: 270.0),
                clockwise: false
            )

            path.move(to: CGPoint(x: left + radius, y: top))
            path.addLine(to: CGPoint(x: left + radius + cornerLength, y: top))

            path.move(to: CGPoint(x: left, y: top + radius))
            path.addLine(to: CGPoint(x: left, y: top + radius + cornerLength))

            path.move(to: CGPoint(x: right - radius, y: top))
            path.addArc(
                center: CGPoint(x: right - radius, y: top + radius),
                radius: radius,
                startAngle: Angle(degrees: 270.0),
                endAngle: Angle(degrees: 360.0),
                clockwise: false
            )

            path.move(to: CGPoint(x: right - radius, y: top))
            path.addLine(to: CGPoint(x: right - radius - cornerLength, y: top))

            path.move(to: CGPoint(x: right, y: top + radius))
            path.addLine(to: CGPoint(x: right, y: top + radius + cornerLength))

            path.move(to: CGPoint(x: left + radius, y: bottom))
            path.addArc(
                center: CGPoint(x: left + radius, y: bottom - radius),
                radius: radius,
                startAngle: Angle(degrees: 90.0),
                endAngle: Angle(degrees: 180.0),
                clockwise: false
            )
            
            path.move(to: CGPoint(x: left + radius, y: bottom))
            path.addLine(to: CGPoint(x: left + radius + cornerLength, y: bottom))

            path.move(to: CGPoint(x: left, y: bottom - radius))
            path.addLine(to: CGPoint(x: left, y: bottom - radius - cornerLength))

            path.move(to: CGPoint(x: right, y: bottom - radius))
            path.addArc(
                center: CGPoint(x: right - radius, y: bottom - radius),
                radius: radius,
                startAngle: Angle(degrees: 0.0),
                endAngle: Angle(degrees: 90.0),
                clockwise: false
            )
            
            path.move(to: CGPoint(x: right - radius, y: bottom))
            path.addLine(to: CGPoint(x: right - radius - cornerLength, y: bottom))

            path.move(to: CGPoint(x: right, y: bottom - radius))
            path.addLine(to: CGPoint(x: right, y: bottom - radius - cornerLength))

            return path
        }
    
   
    
}
