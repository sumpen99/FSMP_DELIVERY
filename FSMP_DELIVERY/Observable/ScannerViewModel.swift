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
    @Published var lastQrCode: String = ""
    @Published var isPrivacyResult = false
    @Published var foundQrCode: Bool = false
    
    
    func onFoundQrCode(_ code: String) {
        foundQrCode = true
        self.lastQrCode = code
    }
    
    func reset(){
        foundQrCode = false
        lastQrCode = ""
    }
  
}
