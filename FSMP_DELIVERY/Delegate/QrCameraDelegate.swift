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
    
    var onResult: (String,CGRect) -> Void = { _,_  in }
    var onReset: (Bool) -> Void = { _  in }
    var mockData: String?
    var onTransform: ((AVMetadataObject) -> AVMetadataObject?)? = nil
    var timer:Timer?
    var simulatedRec:CGRect?
    /*override init() {
        super.init()
        print("init camera delegate")
    }
    
    deinit{
        print("deinit camera delegate")
    }*/
    
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let transformed = onTransform?(readableObject) else { return }
            guard let stringValue = readableObject.stringValue else { return }
            foundBarcode(stringValue,bounds:transformed.bounds)
        }
    }
    
    @objc func onSimulateScanning(){
        guard let rec = simulatedRec else { return }
        self.onResult(mockData ?? "Simulated QR-code result.",rec)
    }
    
    func foundBarcode(_ stringValue: String,bounds:CGRect) {
        let now = Date()
        if now.timeIntervalSince(lastTime) >= scanInterval {
            lastTime = now
            setTimer()
            self.onResult(stringValue,bounds)
        }
    }
    
    func setTimer(){
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { [weak self] _ in
            guard let strongSelf = self else { return }
            strongSelf.onReset(false)
        })
    }
    
    func closeTimer(){
        timer?.invalidate()
    }
    
}

