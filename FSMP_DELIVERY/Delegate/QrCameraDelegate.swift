//
//  QrCameraDelegate.swift
//  FSMP_DELIVERY
//
//  Created by fredrik sundström on 2023-05-19.
//

import Foundation
import AVFoundation


class QrCameraDelegate: NSObject, AVCaptureMetadataOutputObjectsDelegate {
    
    var scanInterval: Double = 1.0
    var lastTime = Date(timeIntervalSince1970: 0)
    
    var onResult: (String) -> Void = { _  in }
    var mockData: String?
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            let pos = readableObject.bounds
            foundBarcode(stringValue,position:pos)
        }
    }
    
    @objc func onSimulateScanning(){
        foundBarcode(mockData ?? "Simulated QR-code result.",
                     position:CGRect(x: 0.0, y: 0.0, width: 100.0, height:100.0))
    }
    
    func foundBarcode(_ stringValue: String,position:CGRect) {
        //(0.12487192451953888, 0.5333784818649292, 0.1464139074087143, 0.17969995737075806)
        let now = Date()
        if now.timeIntervalSince(lastTime) >= scanInterval {
            lastTime = now
            self.onResult(stringValue)
        }
    }
}

