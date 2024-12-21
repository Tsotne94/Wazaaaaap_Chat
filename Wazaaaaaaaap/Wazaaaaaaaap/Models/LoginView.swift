//
//  LoginView.swift
//  Wazaaaaaaaap
//
//  Created by MacBook on 21.12.24.
//

import SwiftUI

struct LoginView: View {
    var body: some View {
        ZStack{
            backgroundColor
                .ignoresSafeArea()
            
            VStack {
                wazapLabel
                
                LabelAndTextFieldView(
                    text: .constant(""),
                    label: "Email",
                    placeholder: "Your email address"
                )
                .padding(.top)
                
                LabelAndTextFieldView(
                    text: .constant(""),
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
        Button("Sign Up") {}
            .foregroundColor(.secondaryText)
            .font(.anekDevanagariBold(size: 18))
    }
    
    private var continueWithGoogleButton: some View {
        Button(action: {
            
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
            .padding(.horizontal, 49)
            .padding(.top, 15)
            .padding(.bottom, 15)
            .background(.primaryWhite)
            .cornerRadius(10)
        }
    }
    
    private var loginButton: some View {
        Button("Log In") {}
            .font(.interSemiBold(size: 20))
            .padding(.horizontal, 134)
            .padding(.top, 20)
            .padding(.bottom, 20)
            .foregroundColor(.primaryWhite)
            .background(.primaryPurple)
            .cornerRadius(12)
    }
}

#Preview {
    LoginView()
}
