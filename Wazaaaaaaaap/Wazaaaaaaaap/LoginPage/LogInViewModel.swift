//
//  LogInViewModel.swift
//  Wazaaaaaaaap
//
//  Created by nino on 12/22/24.
//

import Foundation
import FirebaseAuth
import Firebase
import GoogleSignIn
import FirebaseCore

class LogInViewModel: ObservableObject {
    @Published var email: String
    @Published var password: String
    @Published var isLogedIn: Bool = false {
        didSet {
            saveIsLoggedInState(isLogedIn)
        }
    }
    @Published var errorMessage: String?
    @Published var showAlert: Bool = false
    
    private var userDefault = UserDefaults.standard
    
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
                self?.saveIsLoggedInState(self?.isLogedIn ?? true)
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
    
    //NOTE: ChatGPT ALERT!!
    func signInWithGmail(presentation: UIViewController, completion: @escaping (Error?) -> Void) {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            completion(NSError(domain: "SignInError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Firebase clientID not found."]))
            return
        }

        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        GIDSignIn.sharedInstance.signIn(withPresenting: presentation) { result, error in
            if let error = error {
                completion(error)
                return
            }

            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString else {
                completion(NSError(domain: "SignInError", code: -2, userInfo: [NSLocalizedDescriptionKey: "Failed to retrieve user or ID token."]))
                return
            }

            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)

            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    completion(error)
                    return
                }
                
                DispatchQueue.main.async {
                    self.isLogedIn = true
                }

                completion(nil)
            }
        }
    }
    
    func saveIsLoggedInState(_ state: Bool) {
        DispatchQueue.global(qos: .background).async {
            self.userDefault.set(state, forKey: "isLoggedIn")
            self.userDefault.synchronize()
        }
    }
    
    func fetchIsLoggedInState() -> Bool {
        return self.userDefault.bool(forKey: "isLoggedIn")
    }
}
