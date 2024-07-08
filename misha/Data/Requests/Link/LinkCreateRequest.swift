import Foundation


func linkCreateRequest(withToken token: String, with body: Link, completion: @escaping (Result<Link, Error>) -> Void) {
    guard let url = URL(string: "http://95.163.221.125:8080/links/create") else {
        print("Invalid URL")
        return
    }
    
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
            let responseData = try JSONDecoder().decode(Link.self, from: data)
            completion(.success(responseData))
            print("Request Body: \(responseData)")
        } catch {
            completion(.failure(error))
        }
    }
    
    task.resume()
}
