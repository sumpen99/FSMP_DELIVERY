//
//  FirestoreRepository.swift
//  FSMP_DELIVERY
//
//  Created by fredrik sundström on 2023-05-08.
//

import Firebase
import FirebaseStorage

class FirestoreRepository{
    let USER_COLLECTION = "user"
    let COMPANY_COLLECTION = "company"
    let CUSTOMER_COLLECTION = "customers"
    let CREDENTIALS_COLLECTION = "credentials"
    let ORDER_SIGNED_COLLECTION = "orders_signed"
    let ORDER_IN_PROCESS_COLLECTION = "orders_in_process"
    
    let ORDER_SIGNED = "ORDER/SIGNED"
    let ORDER_IN_PROCESS = "ORDER/PROCESS"
    
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
    
    func getCredentialsDocument(_ token:String) -> DocumentReference {
        return firestoreDB
            .collection(CREDENTIALS_COLLECTION)
            .document(token)
    }
    
    func getOrderInProcessCollection() -> CollectionReference{
        return firestoreDB.collection(ORDER_IN_PROCESS_COLLECTION)
    }
    
    func getCustomerCollection() -> CollectionReference{
        return firestoreDB.collection(CUSTOMER_COLLECTION)
    }
    
    
    func getOrderReference(orderType:OrderType,orderNumber:String) -> StorageReference{
        switch orderType{
            case .ORDER_SIGNED:
                return firestoreStorage.reference().child("\(ORDER_SIGNED)/\(orderNumber).pdf")
                    
            case .ORDER_IN_PROCESS:
                return firestoreStorage.reference().child("\(ORDER_IN_PROCESS)/\(orderNumber).pdf")
        }
    }
    
    func setMetaDataAs(_ dataType:String) -> StorageMetadata{
        // ex. "image/jpg"
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        return metadata
    }
    
    /*func getSignedOrderImageReference(orderNumber:String) -> StorageReference{
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        return firestoreStorage.reference().child("\(SIGNED_ORDER)/\(orderNumber).jpg")
    }*/
}
