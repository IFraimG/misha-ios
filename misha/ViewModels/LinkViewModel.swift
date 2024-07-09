
import Foundation

class LinkViewModel: ObservableObject {
    @Published var linksList: [Link] = []

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
}
