//
//  ContentView.swift
//  Wazaaaaaaaap
//
//  Created by Cotne Chubinidze on 21.12.24.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct ContentView: View {
    
    @StateObject var viewModel = LogInViewModel()
    
    var body: some View {
        if !viewModel.fetchIsLoggedInState() {
            LoginView()
        } else {
            ProfileView()
        }
    }
}

#Preview {
    ContentView()
}
