//
//  Character.swift
//  Marvel
//
//  Created by Эван Крошкин on 9.08.22.
//

import Foundation

struct Character: Decodable {
    let id: Int?
    var name: String?
    let description: String?
    let comicsImages : [CharacterImage]?
    let image: CharacterImage?
    let comics: Comics?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case comicsImages = "images"
        case image = "thumbnail"
        case comics
    }
}

struct Characters: Decodable {
    let count: Int?
    let list: [Character]

    enum CodingKeys: String, CodingKey {
        case count
        case list = "results"
    }
}

struct Comics: Decodable {
    let items: [ComicsName]?
}

struct ComicsName: Decodable {
    let name: String?
}

struct DataModel: Decodable {
    let data: Characters?
}
