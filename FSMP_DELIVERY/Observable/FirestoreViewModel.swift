//
//  FirestoreViewModel.swift
//  FSMP_DELIVERY
//
//  Created by fredrik sundström on 2023-05-08.
//
import Foundation
import Firebase
import SwiftUI

class FirestoreViewModel: ObservableObject{
    let repo = FirestoreRepository()
    @Published var customers = [Customer]()
    var listenerCustomers: ListenerRegistration?
    //var listenerUser: ListenerRegistration?
    
    func closeAllListener(){
        closeListenerCustomer()
    }
    
    func closeListenerCustomer(){
        listenerCustomers?.remove()
    }
    
    
    func removeCustomer(_ customer:Customer){
        removeCustomerOrderHistory(customer.orderIds)
        let doc = repo.getCustomerDocument(customer.customerId)
        doc.delete(){ err in
            if let err = err {
              print("Error removing document: \(err)")
            }
            else {
              print("Customer successfully removed!")
            }
        }
    }
    
    func removeCustomerOrderHistory(_ orderIds:[String]?){
        guard let orderIds = orderIds else { return }
        let collectionOrderInProcess = repo.getOrderInProcessCollection()
        let collectionOrderSigned = repo.getOrderSignedCollection()
        DispatchQueue.global(qos:.background).async {
            for id in orderIds{
                collectionOrderInProcess.document(id).delete()
                collectionOrderSigned.document(id).delete()
            }
        }
    }
    
    func setCustomerDocument(_ customer : Customer) {
        let doc = repo.getCustomerDocument(customer.customerId)
        do{
            try doc.setData(from:customer){ err in
                if let err = err { print("err ... \(err)") }
            }
        }
        catch{
            print("Caught error")
        }
    }
    
    func listenToFirestoreCustomers() {
        let customers = repo.getCustomerCollection()
        listenerCustomers = customers.addSnapshotListener() {
            snapshot, err in
            guard let snapshot = snapshot else {print("1"); return}
            if let _ = err {
                print("error fetching customers")
            } else {
                self.customers.removeAll()
                for document in snapshot.documents {
                    do{
                        let customer = try document.data(as : Customer.self)
                        self.customers.append(customer)
                    } catch {
                        print("error reading DB")
                    }
                }
            }
        }
    }
    
    func setOrderInProcessDocument(_ order : Order) {
        let doc = repo.getOrderInProcessDocument(order.orderId)
        do{
            try doc.setData(from:order){ err in
                if let err = err { print("err ... \(err)") }
            }
        }
        catch{
            print("Caught error")
        }
    }
    
    func updateCustomerWithNewOrder(_ customer:Customer,orderId:String){
        let customer = repo.getCustomerDocument(customer.customerId)
        customer.updateData(["orderIds": FieldValue.arrayUnion([orderId])])
    }
    
    func uploadFormPDf(url:URL,orderType:OrderType,orderNumber:String,completion:@escaping (SignedFormResult) -> Void){
        
        let fileRef = repo.getOrderReference(orderType: orderType,orderNumber: orderNumber)
        fileRef.putFile(from: url, metadata: nil) { metadata, error in
            guard metadata != nil else {
                  completion(.UPLOAD_FAILED)
                  return
            }
            fileRef.downloadURL { (url, error) in
                guard url != nil else {
                    completion(.DOWNLOAD_FAILED)
                    return
                }
                completion(.FORM_SAVED_SUCCESFULLY)
            }
        }
     }
    
    func downloadFormPdf(orderType:OrderType,localUrl:URL,orderNumber:String){
        let fileRef = repo.getOrderReference(orderType:orderType,orderNumber: orderNumber)
        fileRef.write(toFile: localUrl) { url, error in
            if let error = error {
                print("Error: \(error)")
            } else {
                print("PDF downloaded and written to device at path : \(localUrl)")
                // Local file URL for "images/island.jpg" is returned
            }
        }  
    }
    
    func getCredentials(completion: @escaping (Credentials?) -> Void){
        repo.getCredentialsDocument("n3mwjwh4dSK20s4FF6w7").getDocument{ (snapshot,error) in
            do{
                let cred = try snapshot?.data(as : Credentials.self)
                completion(cred)
            } catch {
                completion(nil)
            }
        }
    }
    
    
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
    /*
     // File located on disk
     let localFile = URL(string: "path/to/docs/rivers.pdf")!

         // Create a reference to the file you want to upload
         let riversRef = storageRef.child("docs/rivers.pdf")

         // Upload the file to the path "docs/rivers.pdf"
         let uploadTask = riversRef.putFile(from: localFile, metadata: nil) { metadata, error in
           guard let metadata = metadata else {
             // Uh-oh, an error occurred!
             return
           }
           // Metadata contains file metadata such as size, content-type.
           let size = metadata.size
           // You can also access to download URL after upload.
           storageRef.downloadURL { (url, error) in
             guard let downloadURL = url else {
               // Uh-oh, an error occurred!
               return
             }
           }
         }
     
     */
    
    /*func downloadFormImage(orderNumber:String){
        let fileRef = repo.getSignedOrderReference(orderNumber: orderNumber)
        fileRef.getData(maxSize: (1 * 1024 * 1024)) { (data, error) in
                if let err = error {
                   print(err)
              } else {
                if let image  = data {
                     let myImage: UIImage! = UIImage(data: image)
                }
             }
        }
    }*/
    
    /*
     let uiImage = signedForm.snapshot()
     let fittedImage = uiImage.aspectFittedToHeight(200.0)
     guard let imgData = fittedImage.compressImage(0.2) else{
         setFormResult(.IMAGE_DATA_ERROR)
         return
     }
     firestoreViewModel.uploadSignedForm(imageData: imgData,orderNumber:UUID().uuidString)
     func uploadSignedFormImage(imageData:Data,orderNumber:String){
        let metadata = repo.setMetaDataAs("image/jpg")
        repo.getSignedOrderReference(orderNumber: orderNumber)
        .putData(imageData, metadata: metadata) { (metadata, error) in
            if let error = error {
                print("Error while uploading file: ", error)
            }

            if let metadata = metadata {
                print("Metadata: ", metadata)
            }
        }
    }*/
    
}

