//
//  ContentView.swift
//  Wazaaaaaaaap
//
//  Created by Cotne Chubinidze on 21.12.24.
//
import SwiftUI
import Firebase

struct ChatView: View {
    @StateObject var viewModel = ChatViewModel()
    @State private var messages: [MessageModel] = []
    @State var showProfile: Bool = false
    
    var body: some View {
        VStack {
            HeaderView(profile: $showProfile)
            ScrollViewReader { scrollView in
                ScrollView(showsIndicators: false) {
                    ForEach(Array(viewModel.messages.enumerated()), id: \.element) { idx, message in
                        MessageBubble(message: message)
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



