//
//  createAccountView.swift
//  FSMP_DELIVERY
//
//  Created by Kanyaton Somjit on 2023-05-22.
//

import SwiftUI
import FirebaseAuth
struct createAccountView: View {
    
    @State private var email: String = ""
    @State private var password: String = ""
    
    var body: some View {

            VStack{
                HStack{
                    Image(systemName: "person.crop.circle.fill")
                        .font(.largeTitle)
                        .bold()
                    Text("Create an Account!")
                        .font(.largeTitle)
                        .bold()
                }
                Image ("delivery")
                    .resizable()
                    .padding(.leading, 20.0)
                    .scaledToFit()
                HStack{
                    Image(systemName: "person.circle")
                        .foregroundColor(.black)
                        .font(.largeTitle)
                    TextField("Email", text: $email)
                        .font(.title)
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
                    Auth.auth().createUser(withEmail: email, password: password) { result, error in 
                        if let _ = error {
                            print("error create account")
                        } else {
                            print("created account")
                        }
                    }
                }){
                    Text("Create New Account")
                        .font(.title2)
                        .bold ()
                        .foregroundColor(.black)
                        .padding()
                        .background(Color(red: 239/256, green: 167/256, blue: 62/256))
                        .cornerRadius(40.0)
                }
                Spacer()
                Spacer()
            }
    }
}

struct createAccountView_Previews: PreviewProvider {
    static var previews: some View {
        createAccountView()
    }
}
