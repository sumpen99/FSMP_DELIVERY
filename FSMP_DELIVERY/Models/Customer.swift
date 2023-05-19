//
//  Customer.swift
//  FSMP_DELIVERY
//
//  Created by Philip Andersson on 2023-05-11.
//
import FirebaseFirestoreSwift
import SwiftUI
import Foundation

struct Customer : Encodable, Decodable, Identifiable, Hashable {
    
    @DocumentID var id : String?
    
    var name : String
    var email : String
//    var addres : latLng or smthin
    var phoneNumber : Int
    var description : String = ""
    var taxnumber : Int
}
