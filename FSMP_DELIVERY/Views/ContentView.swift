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
  
    var body: some View {
         ZStack{
             switch firebaseAuth.loggedInAs{
                 case .NOT_LOGGED_IN:
                    SignInView()
                 case .ADMIN:
                      MainView()
                      //AdminView()
                 case .EMPLOYEE:
                      MainView()
                 case .CUSTOMER:
                     EmptyView()
                 default:
                     MainView()
             }
         }
     }

     struct ContentView_Previews: PreviewProvider {
         static var previews: some View {
            ContentView()
         }
     }
 
}

struct SignInView : View {
    @EnvironmentObject var firebaseAuth: FirebaseAuth
    @State var showAlert : Bool = false
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
                firebaseAuth.loginWithEmail(email, password: password) { authResult, error in
                    if let _ = error {
                        showAlert = true
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

