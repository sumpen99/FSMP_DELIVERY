//
//  FirestoreRepository.swift
//  FSMP_DELIVERY
//
//  Created by fredrik sundström on 2023-05-08.
//

import Firebase
import FirebaseStorage

class FirestoreRepository{
    let USER_COLLECTION = "USER"
    let COMPANY_COLLECTION = "COMPANY"
    private let firestoreDB = Firestore.firestore()
    private let firestoreStorage = Storage.storage()
    
    func getCompanyDocument(_ companyId:String) -> DocumentReference {
        return firestoreDB
            .collection(COMPANY_COLLECTION)
            .document(companyId)
    }
    
    func getUserDocument(_ userId:String) -> DocumentReference {
        return firestoreDB
            .collection(USER_COLLECTION)
            .document(userId)
    }
    
}
