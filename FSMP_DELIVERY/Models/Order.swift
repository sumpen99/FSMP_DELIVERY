//
//  Order.swift
//  FSMP_DELIVERY
//
//  Created by Philip Andersson on 2023-05-11.
//
import SwiftUI
import Foundation
import FirebaseFirestoreSwift

struct Order : Codable,Identifiable {
    @DocumentID var id: String?
    var ordername : String
    var details : String
    var customer : Customer
    var orderId:String
    var assignedUser : String?
    var isActivated : Bool = false
    var isCompleted : Bool = false
    var initDate : Date
    var dateOfCompletion : Date?
    
    func getSignedVersion() ->Order{
        return Order(id:id,
                     ordername: ordername,
                     details: details,
                     customer: customer,
                     orderId: orderId,
                     assignedUser: assignedUser,
                     isActivated: false,
                     isCompleted: true,
                     initDate: initDate,
                     dateOfCompletion: Date())
    }
    
    func getYearMontDay() -> (year:Int,month:Int,day:Int){
        guard let date = dateOfCompletion else { return (year:0,month:0,day:0)}
        let year = date.year()
        let month = date.month()
        let day = date.day()
        return (year:year,month:month,day:day)
    }
    
}
