//
//  QrScannerView.swift
//  FSMP_DELIVERY
//
//  Created by fredrik sundström on 2023-05-19.
//

import SwiftUI
import UIKit
import AVFoundation

struct QrScannerView: UIViewRepresentable {
    @EnvironmentObject var scannerViewModel: ScannerViewModel
    typealias UIViewType = QrCameraPreView
    private let session = AVCaptureSession()
    private let delegate = QrCameraDelegate()
    private let metadataOutput = AVCaptureMetadataOutput()
    
    /*init(){
        print("init qrscannerview")
    }*/
    
    func torchLight(isOn: Bool) -> QrScannerView {
        if let backCamera = AVCaptureDevice.default(for: AVMediaType.video) {
            if backCamera.hasTorch {
                try? backCamera.lockForConfiguration()
                if isOn {
                    backCamera.torchMode = .on
                } else {
                    backCamera.torchMode = .off
                }
                backCamera.unlockForConfiguration()
            }
        }
        return self
    }
    
    func pointOfInterest() -> QrScannerView {
        if let backCamera = AVCaptureDevice.default(for: AVMediaType.video) {
            if backCamera.isFocusModeSupported(.continuousAutoFocus){
                try? backCamera.lockForConfiguration()
                backCamera.focusPointOfInterest = CGPointMake(0.51,0.51)
                backCamera.focusMode = .continuousAutoFocus
                backCamera.unlockForConfiguration()
            }
        }
        return self
    }
    
    func interval(delay: Double) -> QrScannerView {
        delegate.scanInterval = delay
        return self
    }
    
    func found(r: @escaping (String,CGRect) -> Void) -> QrScannerView {
        delegate.onResult = r
        return self
    }
    
    func reset(r: @escaping (Bool) -> Void) -> QrScannerView {
        delegate.onReset = r
        return self
    }
    
    func setupCamera(_ uiView: QrCameraPreView) {
        if let backCamera = AVCaptureDevice.default(for: AVMediaType.video) {
            if let input = try? AVCaptureDeviceInput(device: backCamera) {
                session.sessionPreset = .photo
                
                if session.canAddInput(input) {
                    session.addInput(input)
                }
                if session.canAddOutput(metadataOutput) {
                    session.addOutput(metadataOutput)
                    metadataOutput.metadataObjectTypes = metadataOutput.availableMetadataObjectTypes
                    metadataOutput.setMetadataObjectsDelegate(delegate, queue: DispatchQueue.main)
                }
                let previewLayer = AVCaptureVideoPreviewLayer(session: session)
                uiView.backgroundColor = UIColor.gray
                previewLayer.videoGravity = .resizeAspectFill
                uiView.layer.addSublayer(previewLayer)
                uiView.previewLayer = previewLayer
                
                delegate.onTransform = previewLayer.transformedMetadataObject
                
                DispatchQueue.global(qos: .background).async {
                    //print("start running")
                    session.startRunning()
                }
            }
        }
        
    }
    
    func makeUIView(context: UIViewRepresentableContext<QrScannerView>) -> QrScannerView.UIViewType {
        let cameraView = QrCameraPreView(session: session)
        #if targetEnvironment(simulator)
        cameraView.createSimulatorView(delegate: self.delegate)
        #else
        checkCameraAuthorizationStatus(cameraView)
        #endif
        
        return cameraView
    }
    
    static func dismantleUIView(_ uiView: QrCameraPreView, coordinator: ()) {
        //print("dismantle")
        uiView.session?.stopRunning()
    }
    
    
    private func checkCameraAuthorizationStatus(_ uiView: QrCameraPreView) {
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch cameraAuthorizationStatus {
            case .denied:
                setCameraPermissionDenied()
            case .restricted:
                setCameraPermissionRestricted()
            case .authorized:
                setupCamera(uiView)
            case .notDetermined:
                setCameraPermissionNotDetermined(uiView)
            @unknown default:
                fatalError("AVCaptureDevice::execute - \"Unknown case\"")
        }
           
    }
    
    static func cameraPermissionIsAllowed() -> Bool{
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
        return cameraAuthorizationStatus == .authorized
    }
    
    private func setCameraPermissionNotDetermined(_ uiView: QrCameraPreView){
        AVCaptureDevice.requestAccess(for: .video) { granted in
            DispatchQueue.main.sync {
                if granted {
                    self.setupCamera(uiView)
                }
            }
        }
    }
    
    private func setCameraPermissionDenied(){
        DispatchQueue.main.async {
            ALERT_TITLE = "Permission to access camera is denied"
            ALERT_MESSAGE = "If you want to scan qr-code, please go to settings and enable it"
            scannerViewModel.isPrivacyResult.toggle()
        }
    }
    
    private func setCameraPermissionRestricted(){
        DispatchQueue.main.async {
            ALERT_TITLE = "Permission to access camera is restricted"
            ALERT_MESSAGE = "If you want to scan qr-code device owner must approve, our guess is you can do that from settings"
            scannerViewModel.isPrivacyResult.toggle()
        }
    }
    
    
    func updateUIView(_ uiView: QrCameraPreView, context: UIViewRepresentableContext<QrScannerView>) {
        uiView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        uiView.setContentHuggingPriority(.defaultLow, for: .horizontal)
    }
    
}

