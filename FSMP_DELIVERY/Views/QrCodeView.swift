//
//  QrCodeView.swift
//  FSMP_DELIVERY
//
//  Created by fredrik sundström on 2023-05-18.
//

import SwiftUI
import CoreImage.CIFilterBuiltins

struct QrCodeView: View{
    
    var body: some View{
        //ScannerView()
        NavigationStack {
            VStack {
                getQrImage()?.resizable().frame(width: 200, height: 200)
            }
        }
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
