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
    @Published private(set) var isLoggedIn: Bool = false
    private var handleAuthState: AuthStateDidChangeListenerHandle?
    
    init(){
        listenForAuthDidChange()
    }
    
    func listenForAuthDidChange() {
        guard handleAuthState == nil else { return }
        handleAuthState = auth.addStateDidChangeListener { auth, _ in
            withAnimation(.linear(duration: 0.1)){
                self.isLoggedIn = auth.currentUser != nil
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
    
    func loginWithEmail(_ email:String,password:String,completion:((AuthDataResult?,Error?)->Void)?){
        auth.signIn(withEmail: email, password: password,completion:completion)
    }
    
    func signupWithEmail(_ email:String,password:String,completion:((AuthDataResult?,Error?)->Void)?){
        auth.createUser(withEmail: email, password: password,completion: completion)
    }
}
