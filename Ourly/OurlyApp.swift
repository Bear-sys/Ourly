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
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            LoginView()
        }
    }
}
