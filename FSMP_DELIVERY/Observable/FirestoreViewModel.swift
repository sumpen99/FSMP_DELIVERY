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
    
    func uploadSignedFormPDf(url:URL,orderNumber:String,completion:@escaping (SignedFormResult) -> Void){
        let fileRef = repo.getSignedOrderReference(orderNumber: orderNumber)
        fileRef.putFile(from: url, metadata: nil) { metadata, error in
              guard let metadata = metadata else {
                  completion(.UPLOAD_FAILED)
                  return
              }
            //let size = metadata.size
            fileRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    completion(.DOWNLOAD_FAILED)
                    return
                }
                completion(.FORM_SAVED_SUCCESFULLY)
            }
        }
     }
    
    /*
     let uiImage = signedForm.snapshot()
     let fittedImage = uiImage.aspectFittedToHeight(200.0)
     guard let imgData = fittedImage.compressImage(0.2) else{
         setFormResult(.IMAGE_DATA_ERROR)
         return
     }
     firestoreViewModel.uploadSignedForm(imageData: imgData,orderNumber:UUID().uuidString)
     func uploadSignedFormImage(imageData:Data,orderNumber:String){
        let metadata = repo.setMetaDataAsJpg()
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

