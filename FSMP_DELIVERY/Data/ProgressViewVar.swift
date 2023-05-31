//
//  ProgressViewVar.swift
//  FSMP_DELIVERY
//
//  Created by fredrik sundström on 2023-05-30.
//
import SwiftUI
struct ProgressViewVar{
    let currentDate = Date()
    let currentDateISO8601String = Date().toISO8601String()
    var isEnabled = false
    var isShowing = false
    var closeOnTapped = false
    var isFormSignedResult = false
    var scannedQrCode = ""
    var orderName = ""
    var description = ""
    var addNewPoint = true
    var pointsList:[[CGPoint]] = []
    
    mutating func setEnabled(){
        isEnabled = true
        isShowing = true
    }
}
