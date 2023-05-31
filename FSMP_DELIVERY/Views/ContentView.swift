//  ContentView.swift
//  FSMP_DELIVERY
//
//  Created by fredrik sundström on 2023-05-08.
//

import SwiftUI
import FirebaseCore
import Firebase

struct ContentView: View {
 
 @EnvironmentObject var firebaseAuth: FirebaseAuth
 @EnvironmentObject var firestoreViewModel: FirestoreViewModel
 @State var isMemoryWarning: Bool = false
 private let memoryWarningPublisher = NotificationCenter.default.publisher(for: UIApplication.didReceiveMemoryWarningNotification)
 
 @State var signedIn : Bool = true
 
    var body: some View {
         ZStack{
             Color(red: 70/256, green: 89/256, blue: 116/256)
                 .ignoresSafeArea()
             switch firebaseAuth.loggedInAs{
                 case .NOT_LOGGED_IN:
                    SignInView(signedIn: $signedIn)
                 case .ADMIN:
                      MainView()
//                    AdminView()
                 case .EMPLOYEE:
                      MainView()
                 case .CUSTOMER:
                     EmptyView()
                 default:
                     MainView()
             }
         }
         .onAppear{
             removeAllOrdersFromFolder()
         }
         .onDisappear{
             //removeAllOrdersFromFolder()
         }
         .onReceive(memoryWarningPublisher) { warn in
             print(warn.debugDescription)
         }
     }

 struct ContentView_Previews: PreviewProvider {
     static var previews: some View {
        ContentView()
     }
 }
 
}

struct SignInView : View {
    @Binding var signedIn : Bool
    @State var showAlert : Bool = false
    
    var auth = Auth.auth()
    
    @State private var email: String = ""
    @State private var password: String = ""
    
    var body: some View {
        VStack{
            HStack{
                Image(systemName: "wrench.and.screwdriver.fill")
                    .font(.largeTitle)
                    .bold()
                Text("FSMP Service")
                    .font(.largeTitle)
                    .bold()
                Image(systemName: "wrench.and.screwdriver.fill")
                    .font(.largeTitle)
                    .bold()
            }
            Spacer()
            Image ("delivery")
                    .resizable()
                    .scaledToFill()
                    .padding()
                    .frame(width: 550, height: 350)
            HStack{
                Image(systemName: "person.circle")
                    .foregroundColor(.black)
                    .font(.largeTitle)
                TextField("Email", text: $email)
                    .font(.title)
                    .frame(width: 280, height: 10) 
            }
            .padding()
            .overlay {
                RoundedRectangle(cornerRadius: 40)
                    .stroke(lineWidth: 3)
                    .foregroundColor(.black)
            }
            .padding()
            HStack{
                Image(systemName: "lock")
                    .foregroundColor(.black)
                    .font(.largeTitle)
                SecureField("Password", text: $password)
                    .font(.title)
                    .frame(width: 280, height: 10)
            }
            .padding()
            .overlay {
                RoundedRectangle(cornerRadius: 40)
                    .stroke(lineWidth: 3)
                    .foregroundColor(.black)
            }
            .padding()
            Spacer()
            
            Button(action: {
                auth.signIn(withEmail: email, password: password) { authResult, error in
                    if let _ = error {
                        print("error signing in")
                        showAlert = true
                    } else {
                        print("signed in")
                        signedIn = true
                    }
                }
            }){
                Text("Sign in")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .padding()
                    .background(Color(red: 239/256, green: 167/256, blue: 62/256))
                    .cornerRadius(40.0)
            }
            Spacer()
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Felaktig Login"),
                      message: Text("Fel lösenord eller email"),
                      dismissButton: .default(Text("OK")))
                
            }
        }
    }

}

