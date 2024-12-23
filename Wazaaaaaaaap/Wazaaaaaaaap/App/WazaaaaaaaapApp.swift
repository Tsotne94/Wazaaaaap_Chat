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
    
    var body: some Scene {
        WindowGroup {
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






