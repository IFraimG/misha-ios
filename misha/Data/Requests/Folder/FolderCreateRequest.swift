import Foundation


func folderCreateRequest(withToken token: String, with body: Folder, completion: @escaping (Result<Folder, Error>) -> Void) {
    guard let url = URL(string: "http://95.163.221.125:8080/folders/create") else {
        print("Invalid URL")
        return
    }
    
    print("token \(token) \(body.title)")
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue(token, forHTTPHeaderField: "Authorization")
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
      
    do {
        let jsonData = try JSONEncoder().encode(body)
        request.httpBody = jsonData
    } catch {
        completion(.failure(error))
        return
    }
    
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
            let responseData = try JSONDecoder().decode(Folder.self, from: data)
            completion(.success(responseData))
            print("Request Body: \(responseData)")
        } catch {
            completion(.failure(error))
        }
    }
    
    task.resume()
}
