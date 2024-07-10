//
//  FolderFindRequest.swift
//  misha
//
//  Created by MacBook on 10.07.2024.
//

import Foundation

func folderFindRequest(withToken token: String, withID userID: String, withTitle folderTitle: String, completion: @escaping (Result<ResponseFoldersListDto, Error>) -> Void) {
    guard let url = URL(string: "http://95.163.221.125:8080/folders/findFoldersByTitle?userID=\(userID)&title=\(folderTitle)") else {
        print("Invalid URL")
        return
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.setValue(token, forHTTPHeaderField: "Authorization")
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            completion(.failure(error))
            return
        }
        
        guard let data = data else {
            let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data"])
            completion(.failure(error))
            return
        }
        
        do {
            let responseData = try JSONDecoder().decode(ResponseFoldersListDto.self, from: data)
            completion(.success(responseData))
            print("Request Data: \(responseData)")
        } catch {
            completion(.failure(error))
        }
    }
    
    task.resume()
}
