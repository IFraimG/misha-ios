import Foundation

func linkCreateRequest(withToken token: String, with body: Link, completion: @escaping (Result<Link, Error>) -> Void) {
    guard let url = URL(string: "http://95.163.221.125:8080/links/create") else {
        print("Invalid URL")
        return
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue(token, forHTTPHeaderField: "Authorization")
    
    let boundary = UUID().uuidString
    request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
    
    var bodyData = Data()
    
    do {
        let jsonEncoder = JSONEncoder()
        let linkData = try jsonEncoder.encode(body)
        
        bodyData.append("--\(boundary)\r\n".data(using: .utf8)!)
        bodyData.append("Content-Disposition: form-data; name=\"body\"\r\n".data(using: .utf8)!)
        bodyData.append("Content-Type: application/json\r\n\r\n".data(using: .utf8)!)
        bodyData.append(linkData)
        bodyData.append("\r\n".data(using: .utf8)!)
    } catch {
        completion(.failure(error))
        return 
    }
    
    if let imageData = body.loadImage {
        bodyData.append("--\(boundary)\r\n".data(using: .utf8)!)
        bodyData.append("Content-Disposition: form-data; name=\"img\"; filename=\"image.png\"\r\n".data(using: .utf8)!)
        bodyData.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
        bodyData.append(imageData)
        bodyData.append("\r\n".data(using: .utf8)!)
    }
    
    bodyData.append("--\(boundary)--\r\n".data(using: .utf8)!)
    request.httpBody = bodyData
    
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
        } catch {
            completion(.failure(error))
        }
    }
    
    task.resume()
}
