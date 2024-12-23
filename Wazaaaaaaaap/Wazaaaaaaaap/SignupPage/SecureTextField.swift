//
//  SecureTextField.swift
//  Wazaaaaaaaap
//
//  Created by Sandro Tsitskishvili on 21.12.24.
//

import SwiftUI

struct SecureTextField: View {
    let title: LocalizedStringKey
    let placeholder: LocalizedStringKey
    @Binding var text: String
    @State private var isSecure: Bool = true
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.custom("Inter", size: 12))
                .foregroundColor(.secondaryText)
            HStack {
                Image(.customLock)
                    .foregroundColor(.gray)
                if isSecure {
                    SecureField(placeholder, text: $text)
                } else {
                    TextField(placeholder, text: $text)
                }
                Button(action: { isSecure.toggle() }) {
                    Image(.customEye)
                        .foregroundColor(.gray)
                }
            }
            .padding(10)
            .frame(height: 52)
            .background(Color.white)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray, lineWidth: 1)
            )
        }
    }
}
