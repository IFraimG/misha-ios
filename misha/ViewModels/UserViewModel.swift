//
//  UserViewModel.swift
//  misha
//
//  Created by MacBook on 08.07.2024.
//

import Foundation

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
    
    func saveLinkToFolder(folderID: String) {
        guard let storedToken = UserDefaults.standard.string(forKey: "token"), !storedToken.isEmpty else {
            print("error token")
            return
        }
        
        if let userDefaults = UserDefaults(suiteName: "group.com.pushok.misha") {
            
            if let storedURL = userDefaults.string(forKey: "url"), !storedURL.isEmpty {
//                if let storedTitle = userDefaults.string(forKey: "title"), !storedTitle.isEmpty {
                    let storedTitle = userDefaults.string(forKey: "title")
                    let storedImage = userDefaults.string(forKey: "image")
                    let storedDescription = userDefaults.string(forKey: "description")
                    
                    print("desc \(storedDescription)")
                    print("image \(storedURL)")
                    let link = Link(title: "", description: storedDescription ?? "", folderID: folderID, linkID: "", link: storedURL, image: storedImage ?? "")
                    
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
                    
                    print("storedTitle \(storedTitle)")
                }
//            }
        }
    }
}
