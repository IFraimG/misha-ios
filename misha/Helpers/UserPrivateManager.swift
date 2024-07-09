import Foundation

class UserPrivateManager {
    static let shared = UserPrivateManager()
    
    private let tokenKey = "token"
    private let userIDKey = "userID"
    
    func getUserToken() -> String {
        return UserDefaults.standard.string(forKey: tokenKey) ?? ""
    }
    
    func getUserID() -> String {
        return UserDefaults.standard.string(forKey: userIDKey) ?? ""
    }
}
