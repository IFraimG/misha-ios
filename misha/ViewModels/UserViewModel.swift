

import Foundation
import HTMLReader
import UIKit


class UserViewModel: ObservableObject {
    @Published var url: URL?
    
    @Published var foldersList: [Folder] = []
    @Published var resultLinkCreateState: LinkCreateState = LinkCreateState.GETTING
    
    func getFolders() {
        guard let storedUserID = UserDefaults.standard.string(forKey: "userID"), !storedUserID.isEmpty else {
            print("error userID")
            return
        }
        
        guard let storedToken = UserDefaults.standard.string(forKey: "token"), !storedToken.isEmpty else {
            print("error token")
            return
        }
        
        getFoldersListRequest(withToken: storedToken, with: storedUserID) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    self.foldersList = data.folders
                case .failure(let error):
                    print("error \(error.localizedDescription)")
                }
            }
        }
    }
    
    func saveLinkToFolder(folderID: String) async {
        self.resultLinkCreateState = LinkCreateState.GETTING
        
        guard let storedToken = UserDefaults.standard.string(forKey: "token"), !storedToken.isEmpty else {
            print("error token")
            self.resultLinkCreateState = LinkCreateState.FAILURE
            return
        }
        
        if let userDefaults = UserDefaults(suiteName: "group.com.pushok.misha") {
            
            if let storedURL = userDefaults.string(forKey: "url"), !storedURL.isEmpty {
                if let url = URL(string: storedURL) {
                    let (title, image) = await self.fetchWebsiteData(from: url)
                    let storedDescription = userDefaults.string(forKey: "description")
                    
                    let link = Link(title: title, description: storedDescription ?? "", folderid: folderID, folderID: folderID, linkID: "", link: storedURL, image: "", loadImage: image)
                    linkCreateRequest(withToken: storedToken, with: link) { result in
                        DispatchQueue.main.async {
                            switch result {
                            case .success(let data):
                                self.resultLinkCreateState = LinkCreateState.CREATED
                                self.url = nil
                            case .failure(let error):
                                print("error \(error.localizedDescription)")
                                self.resultLinkCreateState = LinkCreateState.FAILURE
                            }
                        }
                    }
                    
                }
            }
        }
    }
    
    func fetchWebsiteData(from url: URL) async -> (String, Data?) {
        var title: String = ""
        var imageData: Data?
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            let htmlString = String(data: data, encoding: .utf8) ?? ""
            let document = HTMLDocument(string: htmlString)
            
            if let titleElement = document.firstNode(matchingSelector: "title") {
                title = titleElement.textContent.trimmingCharacters(in: .whitespacesAndNewlines)
            }
            
                if let metaElement = document.firstNode(matchingSelector: "meta[property='og:image']"),
                   let imageURLString = metaElement.attributes["content"],
                   let imageURL = URL(string: imageURLString) {
                    
                    imageData = try await loadPreviewImage(imageURLString: imageURLString, imageURL: imageURL, url: url)
                } else if let metaElement = document.firstNode(matchingSelector: "link[rel='apple-touch-icon']"),
                    let imageURLString = metaElement.attributes["href"],
                    let imageURL = URL(string: imageURLString) {
                    
                    imageData = try await loadPreviewImage(imageURLString: imageURLString, imageURL: imageURL, url: url)
                } else if let metaElement = document.firstNode(matchingSelector: "link[rel='icon']"),
                    let imageURLString = metaElement.attributes["href"],
                    let imageURL = URL(string: imageURLString) {
                        imageData = try await loadPreviewImage(imageURLString: imageURLString, imageURL: imageURL, url: url)
                }
        } catch {
            print("Failed to fetch website data: \(error.localizedDescription)")
        }
        
        return (title, imageData)
    }

     
    private func loadPreviewImage(imageURLString: String, imageURL: URL, url: URL) async throws -> Data? {
        var imageData: Data?
        
        if imageURLString.hasPrefix("http://") || imageURLString.hasPrefix("https://") {
            let (data, _) = try await URLSession.shared.data(from: imageURL)
            imageData = data
        } else {
            if let host = url.host {
                var isHttps: String = url.absoluteString.hasPrefix("https://") ? "https://" : "http://"
                
                var isSlash: String = ""
                if let firstCharacter = imageURLString.first, firstCharacter == "/" {
                    isSlash = ""
                } else {
                    isSlash = "/"
                }
                
                let resResult: String = isHttps + host + isSlash + imageURLString
                if let fullImageURL = URL(string: resResult) {
                    let (data, _) = try await URLSession.shared.data(from: fullImageURL)
                    imageData = data
                }
            }
        }
        return imageData
    }
    
    func getResultLinkCreateState() -> LinkCreateState {
        return resultLinkCreateState
    }
    
    func setUrlForLink(url: URL?) {
        self.url = url
    }
    
    func searchFolders(folderTitle: String) {
        guard let storedUserID = UserDefaults.standard.string(forKey: "userID"), !storedUserID.isEmpty else {
            print("error userID")
            return
        }
        
        guard let storedToken = UserDefaults.standard.string(forKey: "token"), !storedToken.isEmpty else {
            print("error token")
            return
        }
        
        folderFindRequest(withToken: storedToken, withID: storedUserID, withTitle: folderTitle) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    self.foldersList = data.folders
                case .failure(let error):
                    print("error \(error.localizedDescription)")
                }
            }
        }
    }
}
