import SwiftUI

class ProfileViewModel: ObservableObject {
    @Published var profile: ProfileModel
    @Published var profileImage: Image? = nil
    @Published var isLoading: Bool = false
    
    init() {
        self.profile = ProfileModel(
            fullName: "John Doe",
            username: "@jondexa",
            imageUrl: "",
            language: .english
        )
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
}
