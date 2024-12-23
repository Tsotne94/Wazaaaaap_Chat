//
//  LoginView.swift
//  Wazaaaaaaaap
//
//  Created by MacBook on 21.12.24.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var viewModel = LogInViewModel()
    @State private var navigateToRegisterPage = false
    
    var body: some View {
        NavigationStack {
            ZStack{
                backgroundColor
                    .ignoresSafeArea()
                
                VStack {
                    wazapLabel
                    
                    LabelAndTextFieldView(
                        text: $viewModel.email,
                        label: "Email",
                        placeholder: "Your email address"
                    )
                    .padding(.top)
                    
                    LabelAndTextFieldView(
                        text: $viewModel.password,
                        label: "Password",
                        placeholder: "Your password",
                        isPassword: true
                    )
                    
                    HStack {
                        newUserQuestionLabel
                        
                        Spacer()
                        
                        signUpButton
                    }
                    .padding(.leading, 32)
                    .padding(.trailing, 18)
                    
                    continueWithGoogleButton
                        .padding(.horizontal)
                        .padding(.top, 100)
                    
                    loginButton
                        .padding()
                }
                .padding()
            }
            .alert(isPresented: $viewModel.showAlert) {
                Alert(
                    title: Text("Login Error"),
                    message: Text(viewModel.errorMessage ?? "An unknown error occurred."),
                    dismissButton: .default(Text("OK"))
                )
            }
            .navigationDestination(isPresented: $viewModel.isLogedIn) {
                ChatView()
            }
            .navigationDestination(isPresented: $navigateToRegisterPage) {
                SignupView()
            }
        }
    }
    
    private var backgroundColor: some View {
        Color.customWhite
    }
    
    private var wazapLabel: some View {
        Text("Wazaaaaap")
            .foregroundStyle(.primaryPurple)
            .font(.pacificoRegular(size: 48))
    }
    
    private var newUserQuestionLabel: some View {
        Text("New To Wazaaaaap?")
            .foregroundStyle(.secondaryText)
            .font(.inter(size: 12))
    }
    
    private var signUpButton: some View {
        Button("Sign Up") {
            navigateToRegisterPage = true
        }
            .foregroundColor(.secondaryText)
            .font(.anekDevanagariBold(size: 18))
    }
    
    private var continueWithGoogleButton: some View {
        Button(action: {
            viewModel.signInWithGmail(presentation: getRootViewController()) { error in
                if let error = error {
                    print("Sign-In Failed: \(error.localizedDescription)")
                } else {
                    viewModel.isLogedIn = true
                    print("Sign-In Successful!")
                }
            }
        }) {
            HStack {
                Image("google")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 23, height: 23)
                
                Text("Continue With Google")
                    .font(.robotoMedium(size: 20))
                    .foregroundColor(.primaryBlack).opacity(0.54)
            }
            .frame(width: 327)
            .padding(.top, 15)
            .padding(.bottom, 15)
            .background(.primaryWhite)
            .cornerRadius(10)
        }
    }
    
    private var loginButton: some View {
        Button(action: {
            viewModel.logIn()
        }) {
            Text("Log In")
                .frame(width: 327)
                .font(.interSemiBold(size: 20))
                .padding(.top, 20)
                .padding(.bottom, 20)
                .foregroundColor(.primaryWhite)
                .background(.primaryPurple)
                .cornerRadius(12)
        }
    }
}

#Preview("English") {
    LoginView()
}

#Preview("ქართული") {
    LoginView()
        .environment(\.locale, Locale(identifier: "ka-GE"))
}

