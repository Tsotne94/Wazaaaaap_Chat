import SwiftUI
import PhotosUI
import FirebaseStorage
import FirebaseAuth

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    @Binding var showProfile: Bool
    @State var isNavigatingToLogin: Bool = false
    
    var body: some View {
        VStack(spacing: 20) {
            if viewModel.isLoading {
                ProgressView("Loading...")
                    .frame(width: 120, height: 120)
            } else if let image = viewModel.profileImage {
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 120, height: 120)
                    .clipShape(Circle())
            } else {
                Image("Avatar")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 120, height: 120)
                    .clipShape(Circle())
            }
            
            PhotosPicker(
                selection: $viewModel.selectedItem,
                matching: .images,
                photoLibrary: .shared()
            ) {
                Text("Choose Profile Picture")
                    .foregroundColor(.blue)
            }
            .onChange(of: viewModel.selectedItem) { newItem in
                Task {
                    if let data = try? await newItem?.loadTransferable(type: Data.self) {
                        viewModel.setImage(from: data)
                    }
                }
            }
            
            VStack(spacing: 5) {
                Text("Full Name")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                
                TextField("", text: $viewModel.profile.name, prompt: Text("Full Name")
                )
                .padding(20)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .foregroundStyle(.primaryText)
                .padding(.horizontal)
            }
            
            VStack(spacing: 5) {
                Text("Username")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                
                TextField("", text: $viewModel.profile.surname, prompt: Text("Username"))
                .padding(20)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .foregroundStyle(.primaryText)
                .padding(.horizontal)
            }
            
            HStack {
                Text("Language")
            }
            .padding()
            .foregroundColor(.gray)
            
            HStack {
                ForEach(ProfileModel.Language.allCases, id: \.self) { language in
                    Button(language.rawValue) {
                        viewModel.changeLanguage(to: language)
                    }
                    .padding()
                    .frame(width: 123)
                    .background(viewModel.profile.language == language ? Color(red: 81/255, green: 89/255, blue: 246/255) : Color(red: 255/255, green: 255/255, blue: 255/255))
                    .foregroundColor(viewModel.profile.language == language ? .white : .black)
                    .cornerRadius(10)
                }
            }
            
            Spacer()
            
            Button(viewModel.localizedTexts["logout"] ?? "Log out") {
                try? Auth.auth().signOut()
                print("User logged out")
                
            }
            .padding()
            .font(.system(size: 20))
            .fontWeight(.bold)
            .frame(maxWidth: 135)
            .background(Color.red)
            .foregroundColor(.white)
            .cornerRadius(12)
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    showProfile.toggle()
                }) {
                    Image(systemName: "chevron.left")
                }
                .foregroundColor(Color(red: 81/255, green: 89/255, blue: 246/255))
            }
            ToolbarItem(placement: .principal) {
                Text("Your Profile")
                    .font(.system(size: 20))
                    .foregroundColor(Color(red: 17/255, green: 21/255, blue: 57/255))
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save") {
                    viewModel.updateProfile()
                    print("Profile saved")
                }
                .foregroundColor(Color(red: 81/255, green: 89/255, blue: 246/255))
                .fontWeight(.bold)
            }
        }
        .background(Color(red: 241/255, green: 242/255, blue: 246/255))
    }
}



