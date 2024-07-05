//
//  HomeView.swift
//  misha
//
//  Created by MacBook on 05.07.2024.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @Binding var isAuthenticated: Bool
    
    @Environment(\.modelContext) private var modelContext: ModelContext
    
    var body: some View {
        Button(action: {
            logout()
        }) {
            Text("Покинуть MISHA")
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
        }
    }
    
    private func logout() {
        UserDefaults.standard.removeObject(forKey: "token")
        isAuthenticated = false
    }
}

#Preview {
    HomeView(isAuthenticated: .constant(true))
}
