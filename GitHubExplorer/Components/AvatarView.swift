//
//  AvatarView.swift
//  GitHubExplorer
//
//  Created by Guhan on 11/01/26.
//

import SwiftUI

struct AvatarView: View {
    
    @State var imageLoader = ImageLoader()
    let urlString: String
    let size: CGFloat
    
    var body: some View {
        Group {
            if let image = imageLoader.image {
                image
                    .resizable()
                    .scaledToFill()
                    .aspectRatio(contentMode: .fill)
                
            } else {
                PlaceHolderImageView()
            }
        }
        .clipShape(.circle)
        .task(id: urlString) {
            await imageLoader.loadImage(from: urlString)
        }
        .frame(width: size, height: size)
    }
}

struct PlaceHolderImageView: View {
    var body: some View {
        ZStack {
            Circle()
                .foregroundStyle(.tertiary)
            Image(systemName: "person")
                .resizable()
                .padding(20)
                .foregroundStyle(.gray)
        }
    }
}
