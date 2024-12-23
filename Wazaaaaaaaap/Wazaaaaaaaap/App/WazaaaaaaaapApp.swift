//
//  WazaaaaaaaapApp.swift
//  Wazaaaaaaaap
//
//  Created by Cotne Chubinidze on 21.12.24.
//
import SwiftUI
import FirebaseCore
import GoogleSignIn
import FirebaseAuth

@main
struct WazaaaaaaaapApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    @State private var showSplash = true 

    var body: some Scene {
        WindowGroup {
            if showSplash {
                SplashView(onFinish: {
                    showSplash = false
                })
            } else {
                NavigationStack {
                    if Auth.auth().currentUser != nil {
                        ChatView()
                    } else {
                        LoginView()
                    }
                }
                .navigationBarBackButtonHidden(true)
            }
        }
    }
}






