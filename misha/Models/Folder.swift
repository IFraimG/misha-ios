
import Foundation

struct Folder: Codable, Hashable, Identifiable {
    var title: String
    var folderID: String
    var userID: String
    var position: Int
    var dateOfCreated: String
    
    var preview: String = ""
    
    var id: String { folderID }
//    enum CodingKeys: String, CodingKey {
//        case title = "title"
//        case folderID = "folderID"
//        case userID = "userID"
//        case position = "position"
//        case dateOfCreated = "dateOfCreated"
//    }
}
