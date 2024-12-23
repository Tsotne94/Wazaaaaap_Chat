import Firebase
import FirebaseAuth
import FirebaseStorage
import SwiftUI
import PhotosUI

final class ProfileViewModel: ObservableObject {
    @Published var profile = User(uid: "", email: "", name: "", surname: "")
    @Published var profileImage: Image? = nil
    @Published var selectedItem: PhotosPickerItem? = nil
    @Published var isLoading: Bool = false
    
    init() {
        fetchUser()
    }
    
    
    func setImage(from data: Data) {
        if let uiImage = UIImage(data: data) {
            profileImage = Image(uiImage: uiImage)
        }
    }
    
    private func fetchUser() {
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
                    if let user = user {
                        self.profile = user
                    }
                    print("User fetched:)")
                }
            }
    }
    
//    var localizedTexts: [String: String] {
//        switch profile.language {
//        case .georgian:
//            return [
//                "save": "შენახვა",
//                "profile": "შენი პროფილი",
//                "choosePicture": "აირჩიე პროფილის სურათი",
//                "fullName": "სახელი",
//                "username": "იუზერის სახელი",
//                "language": "ენა",
//                "logout": "გამოსვლა"
//            ]
//        case .english:
//            return [
//                "save": "Save",
//                "profile": "Your Profile",
//                "choosePicture": "Choose Profile Picture",
//                "fullName": "Full Name",
//                "username": "Username",
//                "language": "Language",
//                "logout": "Log out"
//            ]
//        }
//    }
    
    func updateProfile() {
        guard let user = Auth.auth().currentUser else { return }

        let changeRequest = user.createProfileChangeRequest()
        changeRequest.displayName = profile.name +  " " + profile.surname
        
        changeRequest.commitChanges { error in
            if let error = error {
                print("Error updating profile: \(error.localizedDescription)")
            } else {
                print("Profile updated successfully.")
            }
        }
        
        storeUserInfo(uid: user.uid)
    }
    
    private func fetchImageData(from url: URL) async throws -> Data {
        let (data, _) = try await URLSession.shared.data(from: url)
        return data
    }
    
    private func storeUserInfo(uid: String) {
        let db = Firestore.firestore()
        let user = User(uid: uid, email:profile.email, name: profile.name, surname: profile.surname)
        
        try? db.collection("Users").document(uid)
            .setData(from: user) { error in
            if let error = error {
                print("Error saving user info: \(error.localizedDescription)")
            } else {
                print("User info saved successfully.")
            }
        }
    }
}
