//
//  LinkUIView.swift
//  misha
//
//  Created by MacBook on 09.07.2024.
//

import SwiftUI

struct LinkUIView: View {
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
                Text(linkItem.description)
                        .font(.system(size: 8))
                        .foregroundStyle(Color.black.opacity(0.5))
            }.frame(width: 160, height: 160).background(
                BottomRoundedRectangle(cornerRadius: 8)
                    .fill(Color.white.opacity(0.7))
                    .frame(height: 50)
                    .offset(y: 55)
            )
        }.onTapGesture {
            if let url = URL(string: linkItem.link) {
                UIApplication.shared.open(url)
            }
        }
    }
}

#Preview {
    LinkUIView(linkItem: Link(title: "Рецепт куриных ножек", description: "Как же я обожаю их есть", folderID: "", linkID: "", link: "https://github.com/IFraimG", image: "https://avatars.githubusercontent.com/u/52083535?v=4"))
}
