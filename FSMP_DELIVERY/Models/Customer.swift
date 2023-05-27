//
//  Customer.swift
//  FSMP_DELIVERY
//
//  Created by Philip Andersson on 2023-05-11.
//
import FirebaseFirestoreSwift
import SwiftUI
import Foundation

struct Customer : Codable,Identifiable {
    @DocumentID var id : String?
    var customerId:String
    var name : String = ""
    var adress : String = ""
    var postcode : String = ""
    var email : String = ""
    var lat : Double?
    var lon : Double?
    var orderIds:[String]?
    var phoneNumber : Int = 0
    var description : String = ""
    var taxnumber : Int = 0
    
    func isNotValid() -> Bool{
        return (name.isEmpty ||
                adress.isEmpty ||
                postcode.isEmpty ||
                email.isEmpty)
    }
        
}
