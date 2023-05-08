//
//  User.swift
//  FSMP_DELIVERY
//
//  Created by fredrik sundström on 2023-05-08.
//
import FirebaseFirestoreSwift
import SwiftUI
struct User: Codable,Identifiable{
    @DocumentID var id: String?
    let userId:String?
    let companyID:String?
    let name:String?
    let email:String?
   
}
