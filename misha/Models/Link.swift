//
//  Link.swift
//  misha
//
//  Created by MacBook on 08.07.2024.
//

import Foundation

struct Link: Codable, Hashable, Identifiable {
    var title: String
    var description: String
    var folderid: String
    var linkID: String = ""
    var link: String
    var image: String
    
    var loadImage: Data?
    
    var id: String { linkID }
}
