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
import Nuke

struct ContentView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var isUserFetched: Bool = false
    @State private var userDetails: User? = nil
    
    private let firestore = Firestore.firestore()
    
    var body: some View {
        NavigationView {
            VStack {
                Image(systemName: "person.fill")
                    .resizable()
                    .frame(width: 120, height: 120)
                    .scaledToFill()
                
                TextField("Username", text: $username)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(5)
                    .shadow(radius: 2)
                
                SecureField("Password", text: $password)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(5)
                    .shadow(radius: 2)
                
                HStack {
                    Button("Sign Up") {
                        signUp()
                    }
                    .padding()
                    
                    Button("Log In") {
                        signIn()
                    }
                    .padding()
                }
                .padding()
            }
            .padding()
            .navigationTitle("Authentication")
            .background(
                NavigationLink(
                    destination: DetailView(user: userDetails),
                    isActive: $isUserFetched,
                    label: { EmptyView() }
                )
            )
        }
    }
    
    func signUp() {
        Auth.auth().createUser(withEmail: username, password: password) { result, error in
            if let error = error {
                print("Sign up failed: \(error)")
            } else if let user = result?.user {
                print("Sign up successful: \(user.uid)")
                storeUserInfo(uid: user.uid)
            }
        }
    }
    
    func signIn() {
        Auth.auth().signIn(withEmail: username, password: password) { result, error in
            if let error = error {
                print("Sign in failed: \(error)")
            } else if let user = result?.user {
                print("Sign in successful: \(user.uid)")
                fetchCurrentUser(uid: user.uid)
            }
        }
    }
    
    func storeUserInfo(uid: String) {
        let newUser = User(uid: uid, email: username, name: "", surname: "")
        do {
            try firestore.collection("Users").document(uid).setData(from: newUser)
        } catch {
            print("Error storing user info: \(error)")
        }
    }
    
    func fetchCurrentUser(uid: String) {
        let docRef = firestore.collection("Users").document(uid)
        docRef.getDocument { snapshot, error in
            if let error = error {
                print("Failed to fetch user: \(error)")
            } else if let snapshot = snapshot {
                do {
                    let user = try snapshot.data(as: User.self)
                    print("User fetched successfully: \(user)")
                    self.userDetails = user
                    self.isUserFetched = true
                } catch {
                    print("Error decoding user data: \(error)")
                }
            } else {
                print("No such document.")
            }
        }
    }
}

struct DetailView: View {
    let user: User?
    
    var body: some View {
        VStack {
            if let user = user {
                Text("Email: \(user.email)")
                Text("UID: \(user.uid)")
                Text("Name: \(user.name)")
                Text("Surname: \(user.surname)")
            } else {
                Text("No user details available.")
            }
        }
        .padding()
        .navigationTitle("User Details")
    }
}

#Preview {
    ContentView()
}
