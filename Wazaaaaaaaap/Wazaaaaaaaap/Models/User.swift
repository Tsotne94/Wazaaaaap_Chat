//
//  UserModel.swift
//  Wazaaaaaaaap
//
//  Created by Cotne Chubinidze on 21.12.24.
//
import FirebaseFirestore

struct User: Codable, Identifiable {
    @DocumentID var id: String?
    let uid: String
    let email: String
    var name: String
    var surname: String
}

struct Message: Identifiable, Codable, Equatable, Hashable {
    @DocumentID var id: String? 
    let from: String
    let text: String
    let timeStamp: Timestamp
}
