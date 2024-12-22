//
//  ContentView.swift
//  Wazaaaaaaaap
//
//  Created by Cotne Chubinidze on 21.12.24.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore

struct ChatView: View {
    @State private var messages: [Message] = []
    @State var showProfile: Bool = false
    
    var body: some View {
        VStack {
            HeaderView(profile: $showProfile)
            ScrollViewReader { scrollView in
                ScrollView(showsIndicators: false) {
                    ForEach(Array(messages.enumerated()), id: \.element) { idx, message in
                        HStack {
                            if message.from == Auth.auth().currentUser?.uid {
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
                    .onChange(of: messages) { newValue in
                        scrollView.scrollTo(messages.count - 1, anchor: .bottom)
                    }
                }
            }
            BottomView()
        }
        .onAppear {
            fetchMessages()
        }
        .navigationDestination(isPresented: $showProfile) {
            ProfileView(showProfile: $showProfile)
        }
        .navigationBarBackButtonHidden(true)
    }
    
#warning("gpt has been used here!")
    func fetchMessages() {
        let firestore = Firestore.firestore()
        firestore.collection("groupChat")
            .document("chat1")
            .collection("messages")
            .order(by: "timeStamp", descending: false)
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    print("Failed to fetch messages: \(error)")
                    return
                }
                self.messages = snapshot?.documents.compactMap { document in
                    try? document.data(as: Message.self)
                } ?? []
            }
    }
}

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

struct BottomView: View {
    @State var text: String = ""
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
                TextField("", text: $text, prompt: Text("Replay To Everyone..."), axis: .vertical)
                    .padding(10)
                    .background(.customWhite)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .foregroundStyle(.primaryText)
                Button {
                    if !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        sendMessage()
                    }
                    
                } label: {
                    Image("customSend")
                        .resizable()
                        .frame(width: 34, height: 34)
                }
            }
            .padding(.horizontal)
        }
    }
    
    func sendMessage() {
        let firestore = Firestore.firestore()
        guard let fromId = Auth.auth().currentUser?.uid else { return }

        let messageData = [
            "from": fromId,
            "text": text.trimmingCharacters(in: .whitespacesAndNewlines),
            "timeStamp": Timestamp()
        ] as [String: Any]
        
        firestore.collection("groupChat")
            .document("chat1")
            .collection("messages")
            .addDocument(data: messageData) { error in
                if let error = error {
                    print("Sending message failed: \(error)")
                } else {
                    print("Message sent successfully!")
                    text = ""
                }
            }
    }
}

#Preview {
    ChatView()
}

