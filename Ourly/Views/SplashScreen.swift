//
//  SplashScreen.swift
//  Ourly
//
//  Created by Sean Rhee on 4/14/25.
//

import SwiftUI

struct SplashScreen: View {
    
    @Binding var isActive: Bool
    
    var body: some View {
        ZStack {
            //background image
            Color(.white)
                .ignoresSafeArea()
            
            VStack {
                Image("SplashScreen")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 300)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation {
                    isActive = true
                }
            }
        }
    }
}




struct SplashScreen_Preview: PreviewProvider {
    static var previews: some View {
        SplashScreen(isActive: .constant(false))
    }
}
