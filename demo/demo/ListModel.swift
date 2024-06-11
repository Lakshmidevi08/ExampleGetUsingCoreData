//
//  ListModel.swift
//  demo
//
//  Created by MAC on 06/06/24.
//

import Foundation


//class ListModel{
//    var id: Int64?
//    var name: String?
//    var email: String?
//    var gender: String?
//    var status: String?
//    var isFav: Bool?
//    
//    init(id: Int64? = nil, name: String? = nil, email: String? = nil, gender: String? = nil, status: String? = nil, isFav: Bool? = nil) {
//        self.id = id
//        self.name = name
//        self.email = email
//        self.gender = gender
//        self.status = status
//        self.isFav = isFav
//    }
//}

struct ListModel{
    var id: Int64?
    var name: String?
    var email: String?
    var gender: String?
    var status: String?
    var isFav: Bool?
}

struct ListModell: Codable{
    var id: Int64?
    var name: String?
    var email: String?
    var gender: String?
    var status: String?
    var isFav: Bool?
    
    enum CodingKeys: String, CodingKey{
        case id = "id"
        case name = "name"
        case email = "email"
        case gender = "gender"
        case status = "status"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(Int64.self, forKey: .id)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.email = try container.decodeIfPresent(String.self, forKey: .email)
        self.gender = try container.decodeIfPresent(String.self, forKey: .gender)
        self.status = try container.decodeIfPresent(String.self, forKey: .status)
    }
}
