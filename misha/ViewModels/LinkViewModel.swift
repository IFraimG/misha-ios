
import Foundation

class LinkViewModel: ObservableObject {
    @Published var linksList: [Link] = []
    @Published var isDeleteLink = false
    
    func getListLinks(folderID: String) {
        let token: String = UserPrivateManager.shared.getUserToken()
        if !token.isEmpty {
            linkGetByFolderIdRequest(withToken: token, with: folderID) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let data):
                        self.linksList = data.links
                    case .failure(let error):
                        print("error \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
    func setDeleteLink(isDeleteLink: Bool) {
        self.isDeleteLink = isDeleteLink
    }
    
    func removeLink(linkID: String) {
        let token: String = UserPrivateManager.shared.getUserToken()
        if !token.isEmpty {
            linkRemoveRequest(withToken: token, with: linkID) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(_):
                        self.linksList = self.linksList.filter({ $0.linkID != linkID })
                        self.isDeleteLink = false
                    case .failure(let error):
                        print("error \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
    func deleteFolder(folderID: String) {
        let token: String = UserPrivateManager.shared.getUserToken()
        
        if !token.isEmpty {
            folderRemoveRequest(withToken: token, withFolderID: folderID) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(_):
                        print("success")
                    case .failure(let error):
                        print("error \(error.localizedDescription)")
                    }
                }
            }
        }
    }
}
