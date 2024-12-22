//
//  SignupViewModel.swift
//  Wazaaaaaaaap
//
//  Created by Sandro Tsitskishvili on 21.12.24.
//
import SwiftUI
import Combine
import FirebaseAuth

class SignUpViewModel: ObservableObject {
    @Published var fullName: String = ""
    @Published var userName: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var statusMessage: String? = nil
    @Published var isSuccess: Bool = false
    @Published var isSignUpEnabled: Bool = false
    
    func validateForm() {
        isSignUpEnabled = !fullName.isEmpty && !userName.isEmpty && !email.isEmpty && !password.isEmpty && password == confirmPassword
    }
    
  
    func SignUp() async {
        do {
            try await Auth.auth().createUser(withEmail: email, password: password)
        } catch {
            print("Error during sign-up: \(error.localizedDescription)")
        }
    }
}
