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
                    destination: DetailView(user: userDetails, isUserLoggedIn: $isUserFetched),
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
    @Binding var isUserLoggedIn: Bool
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button {
                    handleSignOut()
                } label: {
                    Image("customGear")
                        .resizable()
                        .frame(width: 50, height: 50)
                }
                .padding()

            }
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
    
    func handleSignOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            print("failed to sign out")
        }
        isUserLoggedIn.toggle()
    }
}

struct ChatView: View {
//    let currentUser:  User
    var body: some View {
        ZStack {
            VStack {
                HeaderView()
                ScrollView {
                    
                }
                Text("thats it for now")
                BottomView()
            }
        }
    }
}

struct HeaderView: View {
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
                print("i am cool")
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
            Rectangle()
                .frame(width: .infinity, height: 1)
                .foregroundStyle(.customWhite)
                .padding(.bottom, 8)
            HStack {
                TextField("", text: $text, prompt: Text("Replay To Everyone"))
                    .padding(10)
                    .background(.customWhite)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .foregroundStyle(.primaryText)
                Button {
                    print("pressed")
                } label: {
                    Image("customSend")
                        .resizable()
                        .frame(width: 34, height: 34)
                }
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
//    ChatView(currentUser: User(id: "1", uid: "1", email: "giorgi@gmail.com", name: "cotne", surname: "chubinidze"))
    ChatView()
}

