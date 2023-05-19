//
//  QrCodeScannerView.swift
//  FSMP_DELIVERY
//
//  Created by fredrik sundström on 2023-05-18.
//

import SwiftUI
import UIKit
import AVFoundation

struct QrCodeScannerView: UIViewRepresentable {
    @EnvironmentObject var scannerViewModel: ScannerViewModel
    typealias UIViewType = QrCameraPreView
    private let session = AVCaptureSession()
    private let delegate = QrCodeCameraDelegate()
    private let metadataOutput = AVCaptureMetadataOutput()
    
    func torchLight(isOn: Bool) -> QrCodeScannerView {
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
    
    func interval(delay: Double) -> QrCodeScannerView {
        delegate.scanInterval = delay
        return self
    }
    
    func found(r: @escaping (String) -> Void) -> QrCodeScannerView {
        delegate.onResult = r
        return self
    }
    
    func simulator(mockBarCode: String)-> QrCodeScannerView{
        delegate.mockData = mockBarCode
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
                DispatchQueue.global(qos: .background).async {
                    session.startRunning()
                }
                
            }
        }
        
    }
    
    func makeUIView(context: UIViewRepresentableContext<QrCodeScannerView>) -> QrCodeScannerView.UIViewType {
        let cameraView = QrCameraPreView(session: session)
        
        #if targetEnvironment(simulator)
        cameraView.createSimulatorView(delegate: self.delegate)
        #else
        checkCameraAuthorizationStatus(cameraView)
        #endif
        
        return cameraView
    }
    
    static func dismantleUIView(_ uiView: QrCameraPreView, coordinator: ()) {
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
    
    
    func updateUIView(_ uiView: QrCameraPreView, context: UIViewRepresentableContext<QrCodeScannerView>) {
        uiView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        uiView.setContentHuggingPriority(.defaultLow, for: .horizontal)
    }
    
}
