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
            ScrollViewReader { scrollView in
                ScrollView(showsIndicators: false)  {
                    ForEach(Array(viewModel.messages.enumerated()), id: \.element) { idx, message in
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
                        .id(idx)
                    }
                    .onChange(of: viewModel.messages) { newValue in
                        scrollView.scrollTo(viewModel.messages.count - 1, anchor: .bottom)
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
}

#Preview {
    ChatView()
}

