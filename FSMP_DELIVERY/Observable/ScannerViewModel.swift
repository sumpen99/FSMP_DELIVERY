//
//  ScannerViewModel.swift
//  FSMP_DELIVERY
//
//  Created by fredrik sundström on 2023-05-19.
//


import SwiftUI

var SCANNED_QR_CODE: String = ""
var SIMULATED_QR_CODE: String = ""
class ScannerViewModel: ObservableObject {
    @Published var torchIsOn: Bool = false
    @Published var isPrivacyResult = false
    @Published var foundQrCode = false
    let scanInterval: Double = 1.0
    var lastQrCode: String = ""
    var left:CGFloat = 1.0
    var top:CGFloat = 1.0
    var right:CGFloat = 1.0
    var bottom:CGFloat = 1.0
    
    //static var SCANNED_QR_CODE: String = ""
    /*init() {
        print("init scannerviewmodel")
    }
    
    deinit{
        print("deinit scannerviewmodel")
    }*/
    
    func onFoundQrCode(_ code: String,bounds:CGRect) {
        left = bounds.minX
        top = bounds.minY
        right = bounds.maxX
        bottom = bounds.maxY
        lastQrCode = code
        foundQrCode = true
        SCANNED_QR_CODE = code
    }
    
    /*func onResetQrCode(_ value: Bool) {
        self.foundQrCode = value
    }*/
    
    func onReset(){
        SCANNED_QR_CODE = ""
        lastQrCode = ""
        foundQrCode = false
    }
  
}
