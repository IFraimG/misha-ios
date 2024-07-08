
import SwiftUI

struct ChooseFolderView: View {
    @State private var userViewModel = UserViewModel()
    
    @Binding var url: URL?

    
    var body: some View {
        VStack {
            FoldersListView(title: .constant("Выберите папку"), isActiveNav: .constant(false), onItemClick: .constant({ (folderID: String) in
                chooseFolder(folderID: folderID)
            }))
        }.onAppear() {
            userViewModel.getFolders()
        }
    }
    
    private func chooseFolder(folderID: String) {
        userViewModel.saveLinkToFolder(folderID: folderID)
    }
}

#Preview {
    ChooseFolderView(url: .constant(nil))
}
