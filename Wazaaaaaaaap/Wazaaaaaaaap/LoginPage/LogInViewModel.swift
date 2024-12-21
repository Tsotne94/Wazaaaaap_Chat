//
//  LogInViewModel.swift
//  Wazaaaaaaaap
//
//  Created by nino on 12/22/24.
//

import Foundation
import FirebaseAuth
import Firebase

class LogInViewModel: ObservableObject {
    @Published var email: String
    @Published var password: String
    @Published var isLogedIn: Bool = false
    @Published var errorMessage: String?
    @Published var showAlert: Bool = false
    
    init(email: String = "", password: String = "") {
        self.email = email
        self.password = password
        self.isLogedIn = isLogedIn
    }
    
    func logIn() {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                self?.handleError(error)
                return
            }

            DispatchQueue.main.async {
                self?.isLogedIn = true
            }
        }
    }
    
    private func handleError(_ error: Error) {
        if let authError = error as NSError? {
            switch AuthErrorCode(rawValue: authError.code) {
            case .networkError:
                errorMessage = "Network error. Please check your internet connection."
            case .userNotFound:
                errorMessage = "No user found with this email address."
            case .wrongPassword:
                errorMessage = "Incorrect password. Please try again."
            case .invalidEmail:
                errorMessage = "The email address is not valid."
            case .tooManyRequests:
                errorMessage = "Too many login attempts. Please try again later."
            default:
                errorMessage = "An unknown error occurred. Please try again."
            }
        } else {
            errorMessage = error.localizedDescription
        }
        
        showAlert = true
        print("Login Error: \(errorMessage ?? error.localizedDescription)")
    }
}
