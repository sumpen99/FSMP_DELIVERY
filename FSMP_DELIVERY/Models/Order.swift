//
//  Order.swift
//  FSMP_DELIVERY
//
//  Created by Philip Andersson on 2023-05-11.
//
import SwiftUI
import Foundation
import FirebaseFirestoreSwift


struct Order : Encodable, Decodable, Identifiable, Hashable {

    
    @DocumentID var id: String?

    var ordername : String
    var details : String
    var customer : Customer
    // var verificationQrCode : QRCode or Image ?
    // var orderDestination : latLng or smthin
    
    var assignedUser : UUID
    
    var isActivated : Bool = false
    var isCompleted : Bool = false
    
    var initDate : Date
    var dateOfCompletion : Date = Date()
    
}
