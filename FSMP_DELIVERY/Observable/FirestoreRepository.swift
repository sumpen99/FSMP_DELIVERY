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
    let SIGNED_ORDER = "ORDER"
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
    
    /*func getSignedOrderImageReference(orderNumber:String) -> StorageReference{
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        return firestoreStorage.reference().child("\(SIGNED_ORDER)/\(orderNumber).jpg")
    }*/
    
    func getSignedOrderReference(orderNumber:String) -> StorageReference{
        return firestoreStorage.reference().child("\(SIGNED_ORDER)/\(orderNumber).pdf")
    }
    
    func setMetaDataAsJpg() -> StorageMetadata{
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        return metadata
    }
}
