//
//  MessageBubbleView.swift
//  Wazaaaaaaaap
//
//  Created by Cotne Chubinidze on 23.12.24.
//
import SwiftUI

struct MessageBubble: View {
    var message: MessageModel
    @State private var profileImage: UIImage? = nil

    var body: some View {
        HStack {
            if message.isFromCurrentUser {
                Spacer()
                VStack(alignment: .trailing, spacing: 4) {
                    Text(message.text)
                        .foregroundColor(.black)
                        .font(.body)
                    Text(message.timeStamp.formattedTimestamp())
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .padding(10)
                .background(Color.lightPurple)
                .cornerRadius(15)
                .frame(maxWidth: 250, alignment: .trailing)
                .padding(.trailing, 8)
            } else {
                HStack(alignment: .top, spacing: 8) {
                    if let image = profileImage {
                        Image(uiImage: image)
                            .resizable()
                            .frame(width: 32, height: 32)
                            .scaledToFill()
                            .clipShape(Circle())
                            .padding(.leading, 8)
                    } else {
                        Image(systemName: "person.fill")
                            .resizable()
                            .frame(width: 32, height: 32)
                            .scaledToFill()
                            .clipShape(Circle())
                            .padding(.leading, 8)
                            .onAppear {
                                fetchProfileImage()
                            }
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Text("@\(message.username)")
                            .foregroundColor(.primaryPurple)
                            .font(.custom("Inter_28pt-SemiBold", size: 14))
                        Text(message.text)
                            .foregroundColor(.black)
                            .font(.body)
                        Text(message.timeStamp.formattedTimestamp())
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .padding(10)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(15)
                    .frame(maxWidth: 250, alignment: .leading)
                }
                Spacer()
            }
        }
    }

    private func fetchProfileImage() {
        guard let profileImageUrl = URL(string: message.profileImageUrl), !message.profileImageUrl.isEmpty else {
            return
        }
        
        let fileName = profileImageUrl.lastPathComponent
        
        if let cachedImage = ImageManager.shared.getCachedImage(fileName: fileName) {
            profileImage = cachedImage
        } else {
            ImageManager.shared.fetchImage(from: profileImageUrl.absoluteString) { image in
                DispatchQueue.main.async {
                    self.profileImage = image
                }
            }
        }
    }
}
