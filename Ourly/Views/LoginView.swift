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
    @State private var email = ""
    @State private var password = ""
    @State private var isLoggedIn = false
    
    init() {
        if FirebaseApp.app() != nil, Auth.auth().currentUser != nil {
            _isLoggedIn = State(initialValue: true)
        } else {
            _isLoggedIn = State(initialValue: false)
        }
    }
    
    var body: some View {
        NavigationStack {
            if isLoggedIn {
                FeedView()
            } else {
                ZStack {
                    // background image
                    Color(.white)
                        .ignoresSafeArea()
                    
                    VStack(spacing: 20) {
                        // image
                        Spacer()
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
                                .padding(.horizontal, 32)
                            
                            SecureField("Password", text: $password)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(8)
                                .textInputAutocapitalization(.never)
                                .padding(.horizontal, 32)
                        }
                        .padding(.horizontal, 32)
                        
                        //sign-in button
                        Button(action: {
                            Auth.auth().signIn(withEmail: email, password: password) {
                                authResult, error in
                                if let error = error {
                                    print("Sign-in failed: \(error.localizedDescription)")
                                } else {
                                    print("Signed in successfully")
                                    isLoggedIn = true
                                    //move to the feed view
                                }
                            }
                        }) {
                            Text("Sign-in")
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color(red: 19/255, green: 46/255, blue: 117/255))
                                .cornerRadius(8)
                                .padding(.horizontal, 32)
                        }
                        .padding(.horizontal, 32)
                        .padding(.top, 10)
                        
                        //sign-up button
                        Button(action: {
                            Auth.auth().createUser(withEmail: email, password: password) {
                                authResult, error in
                                if let error = error {
                                    print("Sign-up failed: \(error.localizedDescription)")
                                } else {
                                    print("Account created successfully")
                                }
                            }
                        }) {
                            Text("Don't have an account? Sign-up")
                                .foregroundColor(.white)
                                .font(.footnote)
                        }
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
    }
}
