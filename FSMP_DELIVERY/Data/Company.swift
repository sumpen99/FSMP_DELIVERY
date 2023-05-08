//
//  Company.swift
//  FSMP_DELIVERY
//
//  Created by fredrik sundström on 2023-05-08.
//

import FirebaseFirestoreSwift
import SwiftUI
struct Company: Codable,Identifiable{
    @DocumentID var id: String?
    let companyID:String?
    let name:String?
    
    
    static func getTestData() -> Company{
        return Company(companyID: UUID().uuidString, name: "TestFöretag")
    }
}
