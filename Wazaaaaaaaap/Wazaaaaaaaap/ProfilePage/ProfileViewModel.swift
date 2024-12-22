import Firebase
import FirebaseAuth
import FirebaseStorage
import SwiftUI
import PhotosUI

final class ProfileViewModel: ObservableObject {
    @Published var profile: ProfileModel
    @Published var profileImage: Image? = nil
    @Published var selectedItem: PhotosPickerItem? = nil
    @Published var isLoading: Bool = false
    
    init() {
        self.profile = ProfileModel(
            fullName: "John Doe",
            username: "@jondexa",
            imageUrl: "",
            language: .english
        )
    }
    
    var localizedTexts: [String: String] {
        switch profile.language {
        case .georgian:
            return [
                "save": "შენახვა",
                "profile": "შენი პროფილი",
                "choosePicture": "აირჩიე პროფილის სურათი",
                "fullName": "სახელი",
                "username": "იუზერის სახელი",
                "language": "ენა",
                "logout": "გამოსვლა"
            ]
        case .english:
            return [
                "save": "Save",
                "profile": "Your Profile",
                "choosePicture": "Choose Profile Picture",
                "fullName": "Full Name",
                "username": "Username",
                "language": "Language",
                "logout": "Log out"
            ]
        }
    }
    
    func updateProfile() {
        guard let user = Auth.auth().currentUser else { return }
        
        let changeRequest = user.createProfileChangeRequest()
        changeRequest.displayName = profile.fullName
        
        changeRequest.commitChanges { error in
            if let error = error {
                print("Error updating profile: \(error.localizedDescription)")
            } else {
                print("Profile updated successfully.")
            }
        }
        
        storeUserInfo(uid: user.uid)
    }
    
    func setImage(from data: Data) {
        if let uiImage = UIImage(data: data) {
            profileImage = Image(uiImage: uiImage)
            uploadProfileImage(uiImage)
        }
    }
    
    func uploadProfileImage(_ image: UIImage) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else { return }
        let storageRef = Storage.storage().reference().child("profile_images/\(UUID().uuidString).jpg")
        
        isLoading = true
        storageRef.putData(imageData, metadata: nil) { metadata, error in
            self.isLoading = false
            if let error = error {
                print("Error uploading image: \(error.localizedDescription)")
                return
            }
            
            storageRef.downloadURL { url, error in
                if let url = url {
                    DispatchQueue.main.async {
                        self.profile.imageUrl = url.absoluteString
                    }
                }
            }
        }
    }
    
    func loadImage() {
        guard let url = URL(string: profile.imageUrl), !profile.imageUrl.isEmpty else {
            self.profileImage = nil
            return
        }
        
        isLoading = true
        Task {
            do {
                let imageData = try await fetchImageData(from: url)
                if let uiImage = UIImage(data: imageData) {
                    profileImage = Image(uiImage: uiImage)
                } else {
                    profileImage = nil
                }
            } catch {
                profileImage = nil
            }
            isLoading = false
        }
    }
    
    private func fetchImageData(from url: URL) async throws -> Data {
        let (data, _) = try await URLSession.shared.data(from: url)
        return data
    }
    
    func changeLanguage(to language: ProfileModel.Language) {
        profile.language = language
    }
    
    private func storeUserInfo(uid: String) {
        let db = Firestore.firestore()
        
        db.collection("users").document(uid).setData([
            "fullName": profile.fullName,
            "username": profile.username,
            "language": profile.language.rawValue
        ]) { error in
            if let error = error {
                print("Error saving user info: \(error.localizedDescription)")
            } else {
                print("User info saved successfully.")
            }
        }
    }
}
