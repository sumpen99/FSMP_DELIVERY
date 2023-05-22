//
//  QrCameraPreView.swift
//  FSMP_DELIVERY
//
//  Created by fredrik sundström on 2023-05-19.
//

import UIKit
import AVFoundation
import SwiftUI

class QrCameraPreView: UIView {
    
    private var imageView = UIImageView()
    
    var previewLayer: AVCaptureVideoPreviewLayer?
    var session:AVCaptureSession?
    weak var delegate: QrCameraDelegate?
    
    init(session: AVCaptureSession) {
        super.init(frame: .zero)
        self.session = session
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*deinit{
        print("deinit camera preview")
    }*/
    
    func createSimulatorView(delegate: QrCameraDelegate){
        let qrCodeStr = UUID().uuidString
        self.delegate = delegate
        self.delegate?.mockData = qrCodeStr
        guard let imgView = getQrUIImageView(qrCodeStr:qrCodeStr) else { return }
        imageView = imgView
        addSubview(imageView)
        DispatchQueue.main.asyncAfter(deadline: .now()+1.0){
            self.delegate?.onSimulateScanning()
        }
    }
    
    func getQrUIImageView(qrCodeStr:String) -> UIImageView?{
        guard let data = generateQrCode(qrCodeStr:qrCodeStr),
              let uiImage = UIImage(data: data) else { return nil}
      
        let imageView = UIImageView(image: uiImage)
        return imageView
    }
    
    func getQrImage() -> Image?{
        guard let data = generateQrCode(qrCodeStr:UUID().uuidString),
              let uiImage = UIImage(data: data) else { return nil}
        
        return Image(uiImage:uiImage)
    }
    
    func generateQrCode(qrCodeStr:String) -> Data?{
        guard let filter = CIFilter(name: "CIQRCodeGenerator") else { return nil }
        let data = qrCodeStr.data(using: .ascii, allowLossyConversion: false)
        filter.setValue(data, forKey: "inputMessage")
        guard let ciimage = filter.outputImage else { return nil }
        let transform = CGAffineTransform(scaleX: 10, y: 10)
        let scaledCIImage = ciimage.transformed(by: transform)
        let uiimage = UIImage(ciImage: scaledCIImage)
        return uiimage.pngData()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        #if targetEnvironment(simulator)
            let p = CGPoint(x: self.center.x - 50.0, y: self.center.y - 75.0)
            let rec = CGRect(origin: p, size: CGSize(width: 100.0, height:100.0))
            delegate?.simulatedRec = rec
            imageView.frame = rec
        #else
            previewLayer?.frame = self.bounds
        #endif
    }
}

