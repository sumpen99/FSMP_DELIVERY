//
//  QrView.swift
//  FSMP_DELIVERY
//
//  Created by fredrik sundström on 2023-05-19.
//

import SwiftUI

struct QrView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var isPrivacyResult = false
    @EnvironmentObject var scannerViewModel: ScannerViewModel
    let qrQodeScannerView = QrScannerView()
    
    var body: some View {
        ZStack {
            qrQodeScannerView
            .found(r: scannerViewModel.onFoundQrCode)
            .reset(r: scannerViewModel.onResetQrCode)
            .torchLight(isOn: scannerViewModel.torchIsOn)
            .interval(delay: scannerViewModel.scanInterval)
            scannerBox
            /*VStack {
                Spacer()
                lightButton
            }.padding()*/
        }
        .alert(isPresented: $scannerViewModel.isPrivacyResult, content: {
            onPrivacyAlert(actionPrimary: openPrivacySettings,
                           actionSecondary: closeScannerView)
        })
        .onAppear{
            scannerViewModel.reset()
        }
        .toolbar {
            ToolbarItemGroup{
                lightButton
            }
        }
        .navigationTitle(scannerViewModel.lastQrCode)
        .navigationBarTitleDisplayMode(.inline)
        //.ignoresSafeArea(.all)
        
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
                //.aspectRatio(1, contentMode: .fit)
                
            }
        }
    }
    
    /*var lightButton: some View{
        HStack{
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
        .background(Color.white)
        .cornerRadius(10)
    }*/
    
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
            let width = right-left
            let top = scannerViewModel.top
            let bottom = scannerViewModel.bottom
            let radius = width/20.0 / 2.0
            let cornerLength = width/10.0
        
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

            // top right
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

            // bottom left
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

            // bottom right
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
