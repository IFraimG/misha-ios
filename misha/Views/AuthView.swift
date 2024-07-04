//
//  AuthView.swift
//  misha
//
//  Created by MacBook on 04.07.2024.
//

import SwiftUI

struct AuthView: View {
    @State private var isSignup = true
    
    var body: some View {
        VStack {
            HStack(alignment: .center) {
                Image("Image")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 64, height: 64)
                    .padding(.horizontal, 20)
                Image("BubbleFriend")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 245, height: 36)
                Image("Star")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
                    .offset(x: -40)
                }
                    
                HStack {
                    Button(action: {
                        isSignup = true
                    }) {
                    Text("Регистрация")
                        .foregroundColor(isSignup ? Color.black : Color.gray)
                        .padding(.horizontal, 40)
                        .padding(.vertical, 10)
                        .overlay(Rectangle()
                        .frame(height: 3)
                        .foregroundColor(isSignup ? .blue : .clear), alignment: .bottom)
                    }
                        
                    Button(action: {
                        isSignup = false
                    }) {
                        Text("Вход")
                            .foregroundColor(!isSignup ? Color.black : Color.gray)
                            .padding(.horizontal, 40)
                            .padding(.vertical, 10)
                            .overlay(Rectangle()
                            .frame(height: 2)
                            .foregroundColor(!isSignup ? .blue : .clear), alignment: .bottom)
                        }
                    }
                    .frame(width: 350)
                    .padding(.top, 40)
                    
                    Spacer()
                    
                    if isSignup {
                        SignupView()
                    } else {
                        LoginView()
                    }
                    
                    Spacer()
                }
                .padding(.top, 40)
            }
}

#Preview {
    AuthView()
}
