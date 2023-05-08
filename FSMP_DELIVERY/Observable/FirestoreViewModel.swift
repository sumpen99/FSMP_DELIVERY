//
//  FirestoreViewModel.swift
//  FSMP_DELIVERY
//
//  Created by fredrik sundström on 2023-05-08.
//

import Firebase
import SwiftUI
class FirestoreViewModel: ObservableObject{
    let repo = FirestoreRepository()
    //var listenerCompany: ListenerRegistration?
    //var listenerUser: ListenerRegistration?
    
    func initializeCompanyData(_ cmp:Company,completion: @escaping ((Bool,String) -> Void )){
        do{
            guard let cmpId = cmp.companyID else {
                completion(false,"Company ID is null")
                return
                
            }
            try repo.getCompanyDocument(cmpId).setData(from:cmp)
            completion(true,"")
        }
        catch {
            completion(false,error.localizedDescription)
        }
    }
    
    func initializeUserData(_ user:User,completion: @escaping ((Bool,String) -> Void )){
        do{
            guard let userId = user.userId else {
                completion(false,"UserId is null")
                return
                
            }
            try repo.getUserDocument(userId).setData(from:user)
            completion(true,"")
        }
        catch {
            completion(false,error.localizedDescription)
        }
    }
    
}

