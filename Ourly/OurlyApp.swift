//
//  OurlyApp.swift
//  Ourly
//
//  Created by Sean Rhee on 4/11/25.
//

import SwiftUI
import Firebase

@main
struct OurlyApp: App {
    
    @StateObject var authViewModel = AuthViewModel()
    @State private var Splash = false
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            Group {
                if (Splash) {
                    if authViewModel.isLoggedIn {
                        FeedView()
                    } else {
                        LoginView()
                    }
                } else {
                    SplashScreen(isActive: $Splash)
                }
            }
            .environmentObject(authViewModel)
        }
    }
}
