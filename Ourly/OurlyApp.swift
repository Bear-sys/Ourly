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
    
    #if !DEBUG
    init() {
        FirebaseApp.configure()
    }
    #endif
    
    var body: some Scene {
        WindowGroup {
            SplashScreen()
        }
    }
}
