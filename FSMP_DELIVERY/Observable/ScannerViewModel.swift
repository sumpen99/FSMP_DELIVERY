//
//  ScannerViewModel.swift
//  FSMP_DELIVERY
//
//  Created by fredrik sundström on 2023-05-19.
//


import SwiftUI
class ScannerViewModel: ObservableObject {
    
    let scanInterval: Double = 1.0
    
    @Published var torchIsOn: Bool = false
    var lastQrCode: String = ""
    @Published var isPrivacyResult = false
    @Published var foundQrCode = false
 
    var left:CGFloat = 1.0
    var top:CGFloat = 1.0
    var right:CGFloat = 1.0
    var bottom:CGFloat = 1.0
    
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
    }
    
    func onResetQrCode(_ value: Bool) {
        self.foundQrCode = value
    }
    
    func onReset(){
        lastQrCode = ""
        foundQrCode = false
    }
  
}
