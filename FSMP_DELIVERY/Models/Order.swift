//
//  Order.swift
//  FSMP_DELIVERY
//
//  Created by Philip Andersson on 2023-05-11.
//
import SwiftUI
import Foundation
import FirebaseFirestoreSwift


struct Order : Identifiable {

    
    @DocumentID var id: String?


//    @DocumentID var id: String?
//    var id = UUID()

    var customer : Customer
    // var verificationQrCode : QRCode or Image ?
    // var orderDestination : latLng or smthin
    
    var assignedUser : String = ""
    
    var isActivated : Bool = false
    var isCompleted : Bool = false
    
    var initDate : Date
    var dateOfCompletion : Date = Date()
    
}
