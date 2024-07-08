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
    @State private var folderSearch = ""
    @State private var foldersList = [Folder]()
    
    let columns = [GridItem(.flexible()), GridItem(.flexible())]

    
    @Environment(\.modelContext) private var modelContext: ModelContext
    
    var body: some View {
        NavigationStack {
            VStack {
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
                
                HStack {
                    Image("Image")
                        .resizable()
                        .frame(width: 24, height: 24)
                    Text("Misha").foregroundColor(.black).font(.system(size: 16))
                }
                
                HStack {
                    HStack {
                        Image(systemName: "magnifyingglass")
                        TextField("Поиск", text: $folderSearch).font(Font.custom("SF Pro", size: 16))
                    }
                    .padding(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(lineWidth: 1)
                            .foregroundColor(Color.gray))
                }.padding(.horizontal, 20).padding(.top, 10)
                
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach($foldersList) { folder in
                            NavigationLink(destination: LinksListView(folder: folder)) {
                                FolderItemView(title: folder.title, notesCount: .constant(230), dateOfCreate: folder.dateOfCreated)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                }
                
                
            }.onAppear() {
                getFolders()
            }
            
            Spacer()
            
            Button(action: {
                PopupFolderView().showAndStack()
            }) {
                Text("Добавить папку")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.black.opacity(0.05))
                    .foregroundColor(.blue)
                    .fontWeight(.medium)
                    .cornerRadius(10)
            }.padding(.horizontal, 20).padding(.top, 20)
        }
    }
    
    private func logout() {
        UserDefaults.standard.removeObject(forKey: "token")
        isAuthenticated = false
    }
    
    private func getFolders() {
        if let storedUserID = UserDefaults.standard.string(forKey: "userID"), !storedUserID.isEmpty {
            if let storedToken = UserDefaults.standard.string(forKey: "token"), !storedToken.isEmpty {
                getFoldersListRequest(withToken: storedToken, with: storedUserID) { result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let data):
                            foldersList = data.folders
                        case .failure(let error):
                            print("error \(error.localizedDescription)")
                        }
                        
                    }
                }
            }
        }
    }
}

#Preview {
    HomeView(isAuthenticated: .constant(true))
}
