//
//  UserCell.swift
//  GitHubExplorer
//
//  Created by Guhan on 09/01/26.
//

import SwiftUI

struct UserCell: View {
    
    let user: User
    
    var body: some View {
        VStack {
            AvatarView(urlString: user.avatarURL, size: 70)
            
//            AsyncImage(url: URL(string: user.avatarURL)) { image in
//                image
//                    .resizable()
//                    .scaledToFill()
//                    .aspectRatio(contentMode: .fill)
//                    .clipShape(.circle)
//                    .frame(width: 70, height: 70)
//            } placeholder: {
//                PlaceHolderImageView()
//                    .frame(width: 70, height: 70)
//            }
            
            Text(user.username)
                .font(.body)
                .frame(height: 45)
                .padding(.top, 10)
                .tint(.primary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.secondarySystemBackground))
        )
    }
}

#Preview {
    UserCell(user: User(id: 1, username: "Test", avatarURL: ""))
}
