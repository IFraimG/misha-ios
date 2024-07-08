//
//  HeaderView.swift
//  misha
//
//  Created by MacBook on 08.07.2024.
//

import SwiftUI

struct HeaderView: View {
    @Binding var title: String
    
    var body: some View {
        HStack {
            Image("Image")
                .resizable()
                .frame(width: 24, height: 24)
            Text(title).foregroundColor(.black).font(.system(size: 16))
        }
    }
}

#Preview {
    HeaderView(title: .constant("Misha"))
}
