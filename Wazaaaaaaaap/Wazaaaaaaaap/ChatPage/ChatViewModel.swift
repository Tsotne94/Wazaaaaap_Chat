//
//  ChatViewModel.swift
//  Wazaaaaaaaap
//
//  Created by Cotne Chubinidze on 23.12.24.
//
import Foundation
import Firebase
import FirebaseAuth

class ChatViewModel: ObservableObject {
    @Published var messageText: String = ""
    @Published var messages = [MessageModel]()
    private var username: String = ""
    private var userId: String = ""
    
    init() {
        self.fetchMessages()
        self.getUserName()
        self.getId()
    }
    
    private func getUserName() {
        guard let fromId = Auth.auth().currentUser?.uid else {
            print("User ID not found.")
            return
        }
        
        let firestore = Firestore.firestore()
        firestore.collection("Users")
            .document(fromId)
            .getDocument { snapshot, error in
                if let error = error {
                    print("Failed fetching username: \(error)")
                } else {
                    let user = try? snapshot?.data(as: User.self)
                    self.username = user?.name ?? "iliko da sandro"
                    print("Username fetched: \(self.username)")
                }
            }
    }
    
    private func getId() {
        if let id = Auth.auth().currentUser?.uid {
            self.userId = id
            print("User ID fetched: \(self.userId)")
        } else {
            print("Failed to fetch User ID.")
        }
    }
    
    private func sendMessage() {
        let firestore = Firestore.firestore()
        
        guard !username.isEmpty else {
            print("Username is not available. Cannot send message.")
            return
        }
        
        guard let fromId = Auth.auth().currentUser?.uid else {
            print("User ID not found. Cannot send message.")
            return
        }
        
        let message = MessageModel(username: username, from: fromId, text: messageText, timeStamp: Timestamp())
        
        do {
            try firestore.collection("groupChat")
                .document("chat1")
                .collection("messages")
                .addDocument(from: message) { [weak self] error in
                    if let error = error {
                        print("Sending message failed: \(error)")
                    } else {
                        print("Message sent successfully!")
                        self?.messageText = ""
                    }
                }
        } catch {
            print("Error encoding message: \(error)")
        }
    }
    
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
                    try? document.data(as: MessageModel.self)
                } ?? []
            }
    }
    
    func sendIfNotEmpty() {
        if !messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            sendMessage()
        }
        messageText = ""
    }
}
