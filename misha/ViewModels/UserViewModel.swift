//
//  UserViewModel.swift
//  misha
//
//  Created by MacBook on 08.07.2024.
//

import Foundation
import HTMLReader
import UIKit

@Observable
class UserViewModel {
    var foldersList: [Folder] = []
    
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
        guard let storedToken = UserDefaults.standard.string(forKey: "token"), !storedToken.isEmpty else {
            print("error token")
            return
        }
        
        if let userDefaults = UserDefaults(suiteName: "group.com.pushok.misha") {
            
            if let storedURL = userDefaults.string(forKey: "url"), !storedURL.isEmpty {
                if let url = URL(string: storedURL) {
                    let (title, image) = await self.fetchWebsiteData(from: url)
                    let storedDescription = userDefaults.string(forKey: "description")
                    
                    let link = Link(title: title, description: storedDescription ?? "", folderid: folderID, linkID: "", link: storedURL, image: "", loadImage: image)
                    linkCreateRequest(withToken: storedToken, with: link) { result in
                        DispatchQueue.main.async {
                            switch result {
                            case .success(let data):
                                print(".....")
                            case .failure(let error):
                                print("error \(error.localizedDescription)")
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
                    if imageURLString.hasPrefix("http://") || imageURLString.hasPrefix("https://") {
                        imageData = try await loadPreviewImage(from: imageURL)
                    } else {
                        if let host = url.host {
                            var isHttps: String = url.absoluteString.hasPrefix("https://") ? "https://" : "http://"
                            let resResult: String = isHttps + host + imageURLString
                            if let fullImageURL = URL(string: resResult) {
                                imageData = try await loadPreviewImage(from: fullImageURL)
                            }
                        }
                    }
            }
        } catch {
            print("Failed to fetch website data: \(error.localizedDescription)")
        }
        
        return (title, imageData)
    }

     
    func loadPreviewImage(from url: URL) async throws -> Data? {
        let (data, _) = try await URLSession.shared.data(from: url)
        return data
    }
}
