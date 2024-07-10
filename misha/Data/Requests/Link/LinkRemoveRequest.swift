
import Foundation

func linkRemoveRequest(withToken token: String, with linkID: String, completion: @escaping (Result<ResponseLinkRemove, Error>) -> Void) {
    guard let url = URL(string: "http://95.163.221.125:8080/links/deleteLinkByLinkID?linkID=\(linkID)") else {
        print("Invalid URL")
        return
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "DELETE"
    request.setValue(token, forHTTPHeaderField: "Authorization")
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    URLSession.shared.dataTask(with: request) { data, response, error in
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
            let responseData = try JSONDecoder().decode(ResponseLinkRemove.self, from: data)
            completion(.success(responseData))
            print("Request Data: \(responseData)")
        } catch {
            completion(.failure(error))
        }
    }.resume()
}
