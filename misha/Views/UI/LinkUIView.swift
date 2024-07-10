//
//  LinkUIView.swift
//  misha
//
//  Created by MacBook on 09.07.2024.
//

import SwiftUI

struct LinkUIView: View {
    @ObservedObject var viewModel: LinkViewModel
    
    let linkItem: Link
    
    var body: some View {
        ZStack {
            LinkPreviewImage(url: "http://95.163.221.125:8080/image/\(linkItem.image)")
            
            VStack(alignment: .leading) {
                Spacer()
                Text(linkItem.title)
                    .font(.system(size: 14))
                    .fontWeight(.bold)
                    .foregroundStyle(Color.black)
                    .multilineTextAlignment(.leading)
                    .lineLimit(1)
                    .truncationMode(.tail)
                Text(linkItem.description)
                    .font(.system(size: 12))
                    .foregroundStyle(Color.black.opacity(0.5))
                    .multilineTextAlignment(.leading)
                    .lineLimit(1)
                    .truncationMode(.tail)
            }
            .frame(width: 160, height: 160)
                .background(
                BottomRoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 55)
                    .offset(y: 55))
                .background(viewModel.isDeleteLink ? Color.red.opacity(0.7) : Color.clear)
        }
        .onTapGesture {
            print("http://95.163.221.125:8080/image/\(linkItem.image)")
            if let url = URL(string: linkItem.link) {
                UIApplication.shared.open(url)
            }
        }
    }
}

#Preview {
    LinkUIView(viewModel: LinkViewModel(), linkItem: Link(title: "Рецепт куриных ножек", description: "Как же я обожаю их есть", folderID: "", linkID: "", link: "https://github.com/IFraimG", image: "09072024-220712_543-image.png"))
}
