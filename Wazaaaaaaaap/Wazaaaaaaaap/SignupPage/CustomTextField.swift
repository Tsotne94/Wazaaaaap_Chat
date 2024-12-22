//
//  CustomTextField.swift
//  Wazaaaaaaaap
//
//  Created by Sandro Tsitskishvili on 21.12.24.
//

import SwiftUI

struct CustomTextField: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.custom("Inter", size: 12))
                .foregroundColor(.secondaryText)
            
            ZStack(alignment: .leading) {
                if text.isEmpty {
                    Text(placeholder)
                        .foregroundColor(.secondaryText)
                        .font(.custom("Inter", size: 15))
                        .padding(.horizontal, 10)
                }
                TextField("", text: $text)
                    .padding(10)
                    .frame(height: 52)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                    .keyboardType(keyboardType)
                    .font(.custom("Inter", size: 15))
            }
        }
    }
}
