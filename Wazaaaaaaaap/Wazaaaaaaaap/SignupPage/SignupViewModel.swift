//
//  SignupViewModel.swift
//  Wazaaaaaaaap
//
//  Created by Sandro Tsitskishvili on 21.12.24.
//
import SwiftUI
import Combine

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
    
    func signUpTapped() {
        if email.contains("@") {
            statusMessage = "Sign-up successful!"
            isSuccess = true
        } else {
            statusMessage = "Invalid email address."
            isSuccess = false
        }
    }
}
