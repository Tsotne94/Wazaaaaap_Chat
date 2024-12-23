//
//  Message.swift
//  Wazaaaaaaaap
//
//  Created by Cotne Chubinidze on 23.12.24.
//
import FirebaseFirestore
import FirebaseAuth
import Firebase

struct MessageModel: Identifiable, Codable, Hashable, Equatable {
    @DocumentID var id: String?
    let username: String
    let from: String
    let text: String
    var timeStamp = Timestamp().dateValue()
    var profileImageUrl: String
    
    var isFromCurrentUser: Bool {
        from == Auth.auth().currentUser?.uid
    }
}

