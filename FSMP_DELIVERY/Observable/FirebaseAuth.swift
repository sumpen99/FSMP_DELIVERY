//
//  FirebaseAuth.swift
//  FSMP_DELIVERY
//
//  Created by fredrik sundström on 2023-05-08.
//

import SwiftUI
import FirebaseAuth
class FirebaseAuth:ObservableObject{
    let auth = Auth.auth()
    @Published private(set) var loggedInAs: UserRole = .NOT_LOGGED_IN
    private var handleAuthState: AuthStateDidChangeListenerHandle?
    
    init(){
        listenForAuthDidChange()
    }
    
    func listenForAuthDidChange() {
        guard handleAuthState == nil else { return }
        handleAuthState = auth.addStateDidChangeListener { [weak self] auth, _ in
            guard let strongSelf = self else { return }
            strongSelf.getUserRole(){ role in
                strongSelf.loggedInAs = role
            }
        }
    }
    
    func signOut(){
        do{
            try auth.signOut()
        }
        catch{
            print(error)
        }
    }
    
    func getUserEmail() ->String? {
        return auth.currentUser?.email
    }
    
    func getUserID() ->String? {
        return auth.currentUser?.uid
    }
    
    func getUserRole(completion: @escaping (UserRole) -> Void){
        guard let user = auth.currentUser else { completion(.NOT_LOGGED_IN); return }
        user.getIDTokenResult(){ (result,error) in
            guard let role = result?.claims["role"] as? NSString else {
                completion(.ANONYMOUS)
                return
            }
            if role == "admin"{ completion(.ADMIN) }
            else if(role == "customer") { completion(.CUSTOMER) }
            else if(role == "employee") { completion(.EMPLOYEE) }
            else{ completion(.ANONYMOUS) }
        }
    }
    
    func loginWithEmail(_ email:String,password:String,completion:((AuthDataResult?,Error?)->Void)?){
        auth.signIn(withEmail: email, password: password,completion:completion)
    }
    
    func signupWithEmail(_ email:String,password:String,completion:((AuthDataResult?,Error?)->Void)?){
        auth.createUser(withEmail: email, password: password,completion: completion)
    }
 
}
