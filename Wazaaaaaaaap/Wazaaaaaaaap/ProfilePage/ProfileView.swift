import SwiftUI
import PhotosUI
import FirebaseStorage
import FirebaseAuth

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    @Binding var showProfile: Bool
    @State private var isImagePickerPresented = false
    
    var body: some View {
        VStack(spacing: 20) {
            if viewModel.isLoading {
                ProgressView("Loading...")
                    .frame(width: 120, height: 120)
            } else if let profileImage = viewModel.profileImage {
                Image(uiImage: profileImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 120, height: 120)
                    .clipShape(Circle())
                    .onTapGesture {
                        isImagePickerPresented.toggle()
                    }
            } else {
                Image("Avatar")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 120, height: 120)
                    .clipShape(Circle())
                    .onTapGesture {
                        isImagePickerPresented.toggle()
                    }
            }
            
            VStack(spacing: 5) {
                Text("Full Name")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                
                TextField("", text: $viewModel.profile.name, prompt: Text("Full Name"))
                    .padding(20)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
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
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(.horizontal)
            }
            
            HStack {
                Text("Language")
                    .foregroundColor(.gray)
                    .padding(.leading)
            }
            .padding()
            
            HStack(spacing: 20) {
                Button("ქართული") {
                    print("pressed")
                }
                .padding()
                .frame(width: 123)
                .background(.white)
                .foregroundColor(.black)
                .cornerRadius(10)
                
                Button("English") {
                    print("pressed")
                }
                .padding()
                .frame(width: 123)
                .background(.primaryPurple)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            
            Spacer()
        
            HStack {
                Button("Log out") {
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
        .sheet(isPresented: $isImagePickerPresented) {
            ImagePicker(image: $viewModel.profileImage)
                .onChange(of: viewModel.profileImage) { newImage in
                    if let newImage = newImage {
                        viewModel.uploadProfileImage()
                    }
                }
        }
    }
}






