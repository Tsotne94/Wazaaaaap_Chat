//
//  LabelAndTextFieldView.swift
//  Wazaaaaaaaap
//
//  Created by MacBook on 21.12.24.
//

import SwiftUI

struct LabelAndTextFieldView: View {
    @State private var isSecure: Bool = true
    @Binding var text: String
    var label: String
    var placeholder: String
    var isPassword: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            titleLabel
                .padding(.leading, 4)
            
            HStack {
                if isPassword {
                    customLockImage
                }
                
                if isPassword && isSecure {
                    secureTextField
                } else {
                    regularTextField
                }
                
                if isPassword {
                    visibilityButton
                }
            }
            .padding(.leading, 16)
            .padding(.trailing, 16)
            .padding(.bottom, 17)
            .padding(.top, 17)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray.opacity(0.6), lineWidth: 1)
            )
        }
        .padding(.vertical, 17)
        .padding(.leading, 32)
        .padding(.trailing, 15)
    }
    
    private var titleLabel: some View {
        Text(label)
            .font(.inter(size: 12))
            .foregroundColor(.secondaryText)
    }
    
    private var customLockImage: some View {
        Image("customLock")
            .foregroundColor(.secondaryText)
    }
    
    private var secureTextField: some View {
        SecureField(placeholder, text: $text)
            .textFieldStyle(PlainTextFieldStyle())
            .autocapitalization(.none)
            .font(.inter(size: 15))
    }
    
    private var regularTextField: some View {
        TextField(placeholder, text: $text)
            .textFieldStyle(PlainTextFieldStyle())
            .autocapitalization(.none)
            .font(.inter(size: 15))
    }
    
    private var visibilityButton: some View {
        Button(action: {
            isSecure.toggle()
        }) {
            Image(systemName: isSecure ? "eye.slash" : "eye")
                .foregroundColor(.primaryBlack)
        }
    }
}

#Preview {
    VStack {
        LabelAndTextFieldView(
            text: .constant(""),
            label: "Email",
            placeholder: "Enter your email"
        )
        
        LabelAndTextFieldView(
            text: .constant(""),
            label: "Password",
            placeholder: "Enter your password",
            isPassword: true
        )
    }
    .padding()
}
