
import SwiftUI

struct ChooseFolderView: View {
    @ObservedObject var viewModel: UserViewModel
    
    var body: some View {
        VStack {
            FoldersListView(title: .constant("Выберите папку"), isActiveNav: .constant(false), onItemClick: .constant({ (folderID: String) in
                chooseFolder(folderID: folderID)
            }))
        }.onAppear() {
            viewModel.getFolders()
        }
    }
    
    private func chooseFolder(folderID: String) {
        Task {
            await viewModel.saveLinkToFolder(folderID: folderID)
        }
    }
}

#Preview {
    ChooseFolderView(viewModel: UserViewModel())
}
