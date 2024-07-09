

import SwiftUI

struct FoldersListView: View {
    @StateObject private var userViewModel = UserViewModel()
    
    @Binding var title: String
    
    @Binding var isActiveNav: Bool
    
    @State private var folderSearch = ""
    
    @Binding var onItemClick: ((String) -> Void)?
    
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    
    var body: some View {
        NavigationStack {
            VStack {
                HeaderView(title: $title)
                
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
                        ForEach($userViewModel.foldersList) { folder in
                            if isActiveNav {
                                NavigationLink(destination: LinksListView(folder: folder), isActive: $isActiveNav) {
                                    FolderItemView(title: folder.title, notesCount: .constant(230), dateOfCreate: folder.dateOfCreated)
                                }
                            } else {
                                FolderItemView(title: folder.title, notesCount: .constant(230), dateOfCreate: folder.dateOfCreated)
                                    .onTapGesture {
                                        onItemClick?(folder.folderID.wrappedValue)
                                    }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                }
            }.onAppear() {
                userViewModel.getFolders()
            }
        }
    }
}

#Preview {
    FoldersListView(title: .constant("Misha"), isActiveNav: .constant(true), onItemClick: .constant(nil))
}
