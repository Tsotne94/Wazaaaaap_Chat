import Firebase
import FirebaseAuth
import FirebaseFirestore
import SwiftUI

final class ProfileViewModel: ObservableObject {
    @Published var profile = User(uid: "", email: "", name: "", surname: "", ImageUrl: "")
    @Published var profileImage: UIImage? = nil
    @Published var isLoading: Bool = false
    @Published var shouldShowImagePicker: Bool = false
    
    init() {
        fetchUser()
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
                    print("Failed fetching user: \(error)")
                } else {
                    let user = try? snapshot?.data(as: User.self)
                    if let user = user {
                        self.profile = user
                        if !user.ImageUrl.isEmpty {
                            self.loadProfileImage(from: user.ImageUrl)
                        }
                    }
                    print("User fetched successfully")
                }
            }
    }
    
    private func loadProfileImage(from urlString: String) {
        ImageManager.shared.fetchImage(from: urlString) { [weak self] image in
            DispatchQueue.main.async {
                self?.profileImage = image
            }
        }
    }
    
    func updateProfile() {
        guard let user = Auth.auth().currentUser else { return }
        
        let changeRequest = user.createProfileChangeRequest()
        changeRequest.displayName = profile.name + " " + profile.surname
        
        changeRequest.commitChanges { error in
            if let error = error {
                print("Error updating profile: \(error.localizedDescription)")
            } else {
                print("Profile updated successfully.")
            }
        }
        storeUserInfo(uid: user.uid)
    }
    
    func uploadProfileImage() {
        guard let profileImage = profileImage else {
            print("No profile image selected")
            return
        }
        
        guard let user = Auth.auth().currentUser else { return }
        
        ImageManager.shared.uploadImage(profileImage, for: user.uid) { [weak self] url in
            if let url = url {
                DispatchQueue.main.async {
                    self?.profile.ImageUrl = url
                }
            } else {
                print("Failed to upload profile image.")
            }
        }
    }
    
    private func storeUserInfo(uid: String) {
        let db = Firestore.firestore()
        let user = User(uid: uid, email: profile.email, name: profile.name, surname: profile.surname, ImageUrl: profile.ImageUrl)
        
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





