//
//  UserData.swift
//  misha
//
//  Created by MacBook on 04.07.2024.
//

import Foundation
import SwiftData

@Model
class UserData {
    @Attribute(.unique) var id: String
    var token: String
    
    init(id: String, token: String) {
        self.id = id
        self.token = token
    }
}
