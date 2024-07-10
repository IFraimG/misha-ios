//
//  LinkPreviewImage.swift
//  misha
//
//  Created by MacBook on 09.07.2024.
//

import SwiftUI

struct LinkPreviewImage: View {
    let url: String
    
    var body: some View {
        if let url = URL(string: url) {
            AsyncImage(url: url) { phase in
                switch phase {
                case .empty:
                    ZStack {
                        Color.gray.frame(width: 160, height: 160)
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(1.5)
                    }
                case .success(let image):
                    image.resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 160, height: 160)
                        .frame(maxWidth: 160, maxHeight: 160)
                        .cornerRadius(8)
                        .shadow(color: Color.black.opacity(0.15), radius: 8, x: 0, y: 2)
                case .failure(_):
                    Image("Empty").resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 160, height: 160)
                        .cornerRadius(8)
                @unknown default:
                    EmptyView()
                }

            }
        }
    }
}

#Preview {
    LinkPreviewImage(url: "https://avatars.githubusercontent.com/u/52083535?v=4")
}
