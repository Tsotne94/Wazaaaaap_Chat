//
//  ChatHeaderView.swift
//  Wazaaaaaaaap
//
//  Created by Cotne Chubinidze on 23.12.24.
//
import SwiftUI

struct HeaderView: View {
    @Binding var profile: Bool
    var body: some View {
        ZStack(alignment: .trailing) {
            HStack {
                Spacer()
                Image("logo")
                    .frame(width: 166, height: 22)
                    .scaledToFit()
                    .padding()
                Spacer()
            }
            Button {
                profile.toggle()
            } label: {
                Image("customGear")
                    .resizable()
                    .frame(width: 22, height: 22)
            }
            .padding(.trailing, 15)
        }
        .padding(.bottom, 8)
        .background(.customWhite)
    }
}
