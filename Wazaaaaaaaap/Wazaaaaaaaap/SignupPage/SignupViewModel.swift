//
//  SignupViewModel.swift
//  Wazaaaaaaaap
//
//  Created by Sandro Tsitskishvili on 21.12.24.
//
import SwiftUI
import Combine
import FirebaseAuth

final class SignUpViewModel: ObservableObject {
    @Published var fullName: String = ""
    @Published var userName: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var statusMessage: String? = nil
    @Published var isSuccess: Bool = false
    @Published var shouldNavigateToLogin: Bool = false
    
    func validateForm() -> (isValid: Bool, message: String?) {
        guard !fullName.isEmpty, !userName.isEmpty, !email.isEmpty, !password.isEmpty, !confirmPassword.isEmpty else {
            return (false, "All fields are required.")
        }
        guard isValidEmail(email) else {
            return (false, "Please enter a valid email address.")
        }
        guard password.count >= 6 else {
            return (false, "Password must be at least 6 characters long.")
        }
        guard password == confirmPassword else {
            return (false, "Passwords do not match.")
        }
        return (true, nil)
    }
    
    
    
    func SignUp() async {
        let validationResult = validateForm()
        
        DispatchQueue.main.async {
            self.statusMessage = validationResult.message
        }
        if !validationResult.isValid {
            return
        }
        do {
            try await Auth.auth().createUser(withEmail: email, password: password)
            
            DispatchQueue.main.async {
                self.statusMessage = "Sign-up successful!"
                self.isSuccess = true
                self.shouldNavigateToLogin = true
            }
            
        }
        catch {
            DispatchQueue.main.async {
                self.statusMessage = "Error during sign-up: \(error.localizedDescription)"
            }
        }
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: email)
    }
}
