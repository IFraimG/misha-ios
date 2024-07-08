import Foundation

struct User: Codable {
    var phone: String
    var password: String?
    var id: String
    
    enum CodingKeys: String, CodingKey {
        case phone = "phone"
        case password = "password"
        case id = "id"
    }
}
