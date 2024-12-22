//
//  ContentView.swift
//  Wazaaaaaaaap
//
//  Created by Cotne Chubinidze on 21.12.24.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct ContentView: View {
    @State var username: String = ""
    @State var password: String = ""
    var body: some View {
        VStack {
            Image(systemName: "person.fill")
                .resizable()
                .frame(width: 120, height: 120)
                .scaledToFill()
            TextField("", text: $username, prompt: Text("Username"))
                .padding()
                .foregroundStyle(.green)
                .background(.white)
            TextField("", text: $password, prompt: Text("Username"))
                .padding()
                .foregroundStyle(.green)
                .background(.white)
            Button("press") {
//                signUp()
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
