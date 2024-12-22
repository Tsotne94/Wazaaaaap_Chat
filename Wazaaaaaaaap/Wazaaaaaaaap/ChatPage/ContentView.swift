//
//  ContentView.swift
//  Wazaaaaaaaap
//
//  Created by Cotne Chubinidze on 21.12.24.
//
import SwiftUI

struct ChatView: View {
    @StateObject var viewModel = ChatViewModel()
    @State private var messages: [MessageModel] = []
    @State var showProfile: Bool = false
    
    var body: some View {
        VStack {
            HeaderView(profile: $showProfile)
            ScrollView {
                ForEach(viewModel.messages) { message in
                    HStack {
                        if message.isFromCurrentUser {
                            Spacer()
                            Text(message.text)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(10)
                                .foregroundColor(.white)
                                .frame(maxWidth: 250, alignment: .trailing)
                        } else {
                            Text(message.text)
                                .padding()
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(10)
                                .frame(maxWidth: 250, alignment: .leading)
                            Spacer()
                        }
                    }
                    .padding(5)
                }
            }
            BottomView()
        }
        .navigationDestination(isPresented: $showProfile) {
            ProfileView(showProfile: $showProfile)
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    ChatView()
}

