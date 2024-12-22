//
//  ChatBottomView.swift
//  Wazaaaaaaaap
//
//  Created by Cotne Chubinidze on 23.12.24.
//
import SwiftUI
import Firebase
import FirebaseAuth

struct BottomView: View {
    @ObservedObject var viewModel = ChatViewModel()
    var body: some View {
        VStack(spacing: 0) {
            
            Divider()
                .foregroundStyle(.customWhite)
                .padding(.bottom, 8)
            
            HStack {
                Button {
                    print("pressed")
                } label: {
                    Image(systemName: "photo.on.rectangle")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .tint(.primaryPurple)
                }
                
                TextField("", text: $viewModel.messageText, prompt: Text("Replay To Everyone..."), axis: .vertical)
                    .padding(10)
                    .background(.customWhite)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .foregroundStyle(.primaryText)
                    .onSubmit {
                        viewModel.sendIfNotEmpty()
                     }
                
                Button {
                    viewModel.sendIfNotEmpty()
                } label: {
                    Image("customSend")
                        .resizable()
                        .frame(width: 34, height: 34)
                }
                
            }
            .padding(.horizontal)
        }
    }
}
