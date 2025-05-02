//
//  AuthViewModel.swift
//  Ourly
//
//  Created by Sean Rhee on 4/11/25.
//


import FirebaseAuth
import SwiftUI

@MainActor
class AuthViewModel: ObservableObject {
    @Published var isLoggedIn: Bool = false
    
    init() {
        self.isLoggedIn = Auth.auth().currentUser != nil
    }
    
    func signIn(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            if result != nil {
                print("signed in")
                self?.isLoggedIn = true
            } else {
                print ("Login failed")
            }
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            DispatchQueue.main.async{
                self.isLoggedIn = false
            }
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
}
