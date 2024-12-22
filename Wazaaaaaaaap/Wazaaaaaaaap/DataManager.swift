//
//  DataManager.swift
//  Wazaaaaaaaap
//
//  Created by Cotne Chubinidze on 21.12.24.
//
//import SwiftUI
//import Firebase
//
//class DataManager: ObservableObject {
//    @Published var user: User?
//    
//    init() {
//        fetchUser()
//    }
//    
//    func fetchUser() {
//        Firestore.firestore()
//            .collection("Users")
//            .document("1")
//            .getDocument { document, error in
//                guard let data = document?.data(), error == nil else { return }
//                DispatchQueue.main.async {
//                    self.user = User(
//                        email: data["email"] as? String ?? "",
//                        uid: data["id"] as? String ?? "",
//                        name: data["name"] as? String ?? "",
//                        surname: data["surname"] as? String ?? "",
//                        username: data["username"] as? String ?? ""
//                    )
//                }
//            }
//    }
//}

