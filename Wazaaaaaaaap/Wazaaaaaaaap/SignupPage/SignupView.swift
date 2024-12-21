//
//  SignupView.swift
//  Wazaaaaaaaap
//
//  Created by Sandro Tsitskishvili on 21.12.24.
//

import SwiftUI

struct SignupView: View {
    @StateObject private var viewModel = SignUpViewModel()
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Sign up")
                .font(.title)
                .padding(.top, 20)
            
            VStack(spacing: 16) {
                CustomTextField(title: "Full Name", placeholder: "Your Full Name", text: $viewModel.fullName)
                CustomTextField(title: "Username", placeholder: "Your Username", text: $viewModel.userName)
                CustomTextField(title: "Email", placeholder: "Your Email Address", text: $viewModel.email, keyboardType: .emailAddress)
                SecureTextField(title: "Enter Password", placeholder: "*******", text: $viewModel.password)
                SecureTextField(title: "Confirm Password", placeholder: "*******", text: $viewModel.confirmPassword)
            }
            
            Spacer()
            
            if let errorMessage = viewModel.statusMessage {
                Text(errorMessage)
                    .font(.footnote)
                    .foregroundColor(viewModel.isSuccess ? .green : .red)
                    .padding(.bottom, 10)
            }
            
            Button(action: viewModel.signUpTapped) {
                Text("Sign Up")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color(red: 81 / 255, green: 89 / 255, blue: 246 / 255))
                    .cornerRadius(8)
            }
            .padding(.bottom, 20)
        }
        .padding(.horizontal, 16)
        .background(Color.white)
       
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SignupView()
    }
}
