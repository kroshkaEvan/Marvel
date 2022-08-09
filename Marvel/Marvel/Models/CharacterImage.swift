//
//  CharacterImage.swift
//  Marvel
//
//  Created by Эван Крошкин on 9.08.22.
//

import UIKit

struct CharacterImage: Decodable {
    private let path: String?
    private let format: String?
    
    enum CodingKeys: String, CodingKey {
        case path
        case format = "extension"
    }
}
