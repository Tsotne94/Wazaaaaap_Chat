//
//  Message.swift
//  Wazaaaaaaaap
//
//  Created by Cotne Chubinidze on 23.12.24.
//
import FirebaseFirestore
import FirebaseAuth

struct MessageModel: Identifiable, Codable, Hashable, Equatable {
    @DocumentID var id: String?
    let username: String
    let from: String
    let text: String
    let timeStamp: Timestamp
    
    var isFromCurrentUser: Bool {
        from == Auth.auth().currentUser?.uid
    }
}
