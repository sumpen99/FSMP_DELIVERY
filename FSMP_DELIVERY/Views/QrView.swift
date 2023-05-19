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
            .torchLight(isOn: scannerViewModel.torchIsOn)
            .interval(delay: scannerViewModel.scanInterval)
            .pointOfInterest()
            VStack {
                scannerBox
                Spacer()
                lightButton
            }.padding()
        }
        .alert(isPresented: $scannerViewModel.isPrivacyResult, content: {
            onPrivacyAlert(actionPrimary: openPrivacySettings,
                           actionSecondary: closeScannerView)
        })
        .onAppear{
            scannerViewModel.reset()
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
            .stroke(scannerViewModel.foundQrCode ? Color.green : Color.blue, lineWidth: 8)
            .frame(width: cutoutWidth, height: cutoutWidth, alignment: .center)
            .aspectRatio(1, contentMode: .fit)
        }
    }
    
    var lightButton: some View{
        HStack {
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
    
}

