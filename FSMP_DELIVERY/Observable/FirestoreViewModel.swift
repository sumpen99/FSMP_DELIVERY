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
    @Published var ordersInProcess = [Order]()
    @Published var ordersSigned = [Order]()
    var listenerCustomers: ListenerRegistration?
    var listenerOrdersInProcess: ListenerRegistration?
    var listenerOrdersSigned: ListenerRegistration?
        
    // MARK: - FIREBASE LISTENER-REGISTRATION
    func initializeListener(){
        listenToCustomers()
        listenToOrdersInProcess()
        listenToOrdersSigned()
    }
    
    func initializeListenerCustomers(){
        listenToCustomers()
    }
    
    func initializeListenerOrdersInProcess(){
        listenToOrdersInProcess()
    }
    
    func initializeListenerOrdersSigned(){
        listenToOrdersSigned()
    }
    
    func closeAllListener(){
        closeListenerCustomers()
        closeListenerOrdersInProcess()
        closeListenerOrdersSigned()
    }
    
    func closeListenerCustomers(){
        listenerCustomers?.remove()
    }
    
    func closeListenerOrdersInProcess(){
        listenerOrdersInProcess?.remove()
    }
    
    func closeListenerOrdersSigned(){
        listenerOrdersSigned?.remove()
    }
    
    // MARK: - FIREBASE LISTENER-FUNCTIONS
    func listenToCustomers() {
        let customers = repo.getCustomerCollection()
        listenerCustomers = customers.addSnapshotListener() { [weak self] (snapshot, err) in
            guard let documents = snapshot?.documents,let strongSelf = self else { return }
            var newCustomers = [Customer]()
            for document in documents {
                guard let customer = try? document.data(as : Customer.self) else { continue }
                newCustomers.append(customer)
            }
            strongSelf.customers = newCustomers
        }
        
    }
    
    
    func listenToOrdersInProcess() {
        let orders = repo.getOrderInProcessCollection()
        listenerOrdersInProcess = orders.addSnapshotListener() { [weak self] (snapshot, err) in
            guard let documents = snapshot?.documents,
                  let strongSelf = self else { return }
            var newOrders = [Order]()
            for document in documents {
                guard let order = try? document.data(as : Order.self) else { continue }
                if order.isActivated && order.assignedUser != FirebaseAuth.currentUserId { continue }
                newOrders.append(order)
            }
            strongSelf.ordersInProcess = newOrders
        }
    }
    
    func listenToOrdersSigned() {
        let orders = repo.getOrderSignedCollection()
        listenerOrdersSigned = orders.addSnapshotListener() { [weak self] (snapshot, err) in
            guard let documents = snapshot?.documents,
                  let strongSelf = self else { return }
            var newOrders = [Order]()
            for document in documents {
                guard let order = try? document.data(as : Order.self) else { continue }
                newOrders.append(order)
            }
            strongSelf.ordersSigned = newOrders
        }
    }
    
    // MARK: - FIREBASE REMOVE-FUNCTIONS
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
    
    func removeOrderInProcess(_ orderId:String){
        let doc = repo.getOrderInProcessDocument(orderId)
        doc.delete(){ err in
            if let err = err {
              print("Error removing document: \(err)")
            }
            else {
              print("Order successfully removed!")
            }
        }
    }
    
    func removeOrderPdfFromStorage(orderType:OrderType,orderNumber:String){
        let fileRef = repo.getOrderReference(orderType: orderType,orderNumber: orderNumber)
        fileRef.delete { error in
            if let error = error {
                print(error)
            } else {
                print("order deleted from storage")
            }
        }
    }
    
    // MARK: - FIREBASE SETDATA-FUNCTIONS
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
    
    func setOrderSignedDocument(_ order : Order) {
        let doc = repo.getOrderSignedDocument(order.orderId)
        do{
            try doc.setData(from:order){ err in
                if let err = err { print("err ... \(err)") }
            }
        }
        catch{
            print("Caught error")
        }
    }
    
    func activateOrderInProcess(_ orderId:String){
        guard let employeeId = FirebaseAuth.currentUserId else { return }
        let orderDoc = repo.getOrderInProcessDocument(orderId)
        orderDoc.updateData(["isActivated": true,"assignedUser":employeeId])
        
    }
    
    func deActivateOrderInProcess(_ orderId:String){
        let orderDoc = repo.getOrderInProcessDocument(orderId)
        orderDoc.updateData(["isActivated": false,"assignedUser":""])
        
    }
    func editOrder(_ order: Order, _ customer: Customer, _ details: String, orderName: String){
        let orderDoc = repo.getOrderInProcessDocument(order.orderId)
        orderDoc.updateData(["customer": customer, "ordername": orderName, "details": details])
    }
   
    // MARK: - FIREBASE ARRAY-FUNCTIONS
    func updateCustomerWithNewOrder(_ customer:Customer,orderId:String){
        let customer = repo.getCustomerDocument(customer.customerId)
        customer.updateData(["orderIds": FieldValue.arrayUnion([orderId])])
    }
    
    func updateCustomerWithRemovedOrder(_ customer:Customer,orderId:String){
        let customer = repo.getCustomerDocument(customer.customerId)
        customer.updateData(["orderIds": FieldValue.arrayRemove([orderId])])
    }
    
    // MARK: - FIREBASE PDF-FUNCTIONS
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
    
    func downloadFormPdf(orderType:OrderType,localUrl:URL,orderNumber:String,callback: @escaping (URL?) -> Void){
        let fileRef = repo.getOrderReference(orderType:orderType,orderNumber: orderNumber)
        fileRef.write(toFile: localUrl) { url, error in
            if let error = error {
                callback(nil)
                //print("Error: \(error)")
            } else {
                callback(url)
                //print("PDF downloaded and written to device at path : \(localUrl)")
            }
        }  
    }
    
    // MARK: - FIREBASE EMAIL-FUNCTIONS
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
    
    
    
}

