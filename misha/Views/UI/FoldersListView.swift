

import SwiftUI

struct FoldersListView: View {
    @StateObject private var userViewModel = UserViewModel()
    
    @Binding var title: String
    
    @Binding var isActiveNav: Bool
    
    @State private var folderSearch = ""
    
    @Binding var onItemClick: ((String) -> Void)?
    
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        HeaderView(title: $title)
        NavigationStack {
            VStack {
                HStack {
                    HStack {
                        Image(systemName: "magnifyingglass")
                        TextField("Поиск", text: $folderSearch)
                            .font(Font.custom("SFProDisplay-Medium", size: 16))
                            .onSubmit {
                                searchFolder()
                            }
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
                                    FolderItemView(title: folder.title, preview: folder.preview, dateOfCreate: folder.dateOfCreated)
                                }
                           } else {
                               FolderItemView(title: folder.title, preview: folder.preview, dateOfCreate: folder.dateOfCreated).onTapGesture {
                                    onItemClick?(folder.folderID.wrappedValue)
                               }
                           }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                }
            }
            .onAppear() {
                userViewModel.getFolders()
            }
            
            Spacer()
                
            Button(action: {
                PopupFolderView(viewModel: userViewModel).showAndStack()
            }) {
                Text("Добавить папку")
                    .frame(maxWidth: .infinity)
                    .font(Font.custom("SFProDisplay-Semibold", size: 18))
                    .padding()
                        .background(Color.black.opacity(0.05))
                        .foregroundColor(.blue)
                        .fontWeight(.medium)
                        .cornerRadius(10)
                }.padding(.horizontal, 20).padding(.top, 20)
        }
//        .searchable(text: $folderSearch)
    }
    
    private func searchFolder() {
        if !folderSearch.isEmpty {
            userViewModel.searchFolders(folderTitle: folderSearch)
        }
    }
}

#Preview {
    FoldersListView(title: .constant("Misha"), isActiveNav: .constant(true), onItemClick: .constant(nil))
}
