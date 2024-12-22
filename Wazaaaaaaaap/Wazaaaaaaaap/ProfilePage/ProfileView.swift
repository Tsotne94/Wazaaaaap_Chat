import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    @Binding var isNavigatingToLogin: Bool
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                if viewModel.isLoading {
                    ProgressView("Loading...")
                        .frame(width: 120, height: 120)
                } else if let image = viewModel.profileImage {
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120)
                        .clipShape(Circle())
                } else {
                    Image("Avatar")
                        .frame(width: 120, height: 120)
                }
                
                VStack(spacing: 5) {
                    Text("Full Name")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                    
                    TextField("Full Name", text: $viewModel.profile.fullName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                }
                
                VStack(spacing: 5) {
                    Text("Username")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                    
                    TextField("Username", text: $viewModel.profile.username)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
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
                        .background(viewModel.profile.language == language ? Color(red: 81/255, green: 89/255, blue: 246/255) : Color.gray.opacity(0.3))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                }
                
                Spacer()
                
                Button("Log out") {
                    print("User logged out")
                }
                .padding()
                .frame(width: 128)
                .background(Color.red)
                .foregroundColor(.white)
                .cornerRadius(12)
                
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        print("Back pressed")
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
                        print("Profile saved")
                    }
                    .foregroundColor(Color(red: 81/255, green: 89/255, blue: 246/255))
                    .fontWeight(.bold)
                }
            }
        }
    }
}



