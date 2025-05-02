//
//  LoginView.swift
//  Ourly
//
//  Created by Sean Rhee on 4/11/25.
//

import SwiftUI
import Firebase
import FirebaseAuth


struct LoginView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var email = ""
    @State private var password = ""
    
    
    var body: some View {
        NavigationStack {
            if authViewModel.isLoggedIn {
                FeedView()
            } else {
                ZStack {
                    // background image
                    Color(.white)
                        .ignoresSafeArea()
                    
                    VStack(spacing: 20) {
                        // image
                        Image("SplashScreen")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 400, height: 400)
                        
                        
                        
                        // form fields
                        VStack(spacing: 16) {
                            
                            TextField("Email", text: $email)
                                .textInputAutocapitalization(.never)
                                .keyboardType(.emailAddress)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(8)
                            
                            SecureField("Password", text: $password)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(8)
                                .textInputAutocapitalization(.never)
                                
                        }
                        .padding(.horizontal, 32)
                        
                        //sign-in button
                        Button {
                            authViewModel.signIn(email: email, password: password)
                        } label: {
                            Text("Sign-in")
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color(red: 19/255, green: 46/255, blue: 117/255))
                                .cornerRadius(8)
                                .padding(.horizontal, 32)
                        }
                            .disabled(email.isEmpty || password.isEmpty)
                            .padding(.top, 10)
                    
                        .padding(.top, 8)
                    }
                }
            }
        }
    }
}



struct LoginView_Preview: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(AuthViewModel())
    }
}
