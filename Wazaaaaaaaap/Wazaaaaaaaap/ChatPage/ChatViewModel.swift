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
    
    init() {
        self.fetchMessages()
    }
    
    func sendMessage() {
        let firestore = Firestore.firestore()
        guard let fromId = Auth.auth().currentUser?.uid else { return }
        
        let message = MessageModel (from: fromId, text: messageText, timeStamp: Timestamp())
        
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
                    try? document.data(as: MessageModel.self)
                } ?? []
            }
    }
}
