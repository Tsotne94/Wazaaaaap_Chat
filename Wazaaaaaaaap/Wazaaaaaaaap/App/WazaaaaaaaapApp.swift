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
        checkAuthenticationStatus()
    }
    
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                if isLoggedIn {
                    ChatView()
                } else {
                    LoginView()
                }
            }
            .navigationBarBackButtonHidden(true)
        }
    }
    
    private func checkAuthenticationStatus() {
        if let _ = Auth.auth().currentUser {
            isLoggedIn = true
            print("User is logged in.")
        } else {
            isLoggedIn = false
            print("No user is signed in.")
        }
    }
}






