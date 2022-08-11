//
//  CharacterImage.swift
//  Marvel
//
//  Created by Эван Крошкин on 9.08.22.
//

import UIKit

enum SizeImage: String {
    case standardMedium = "standard_medium" // 100x100px
    case standardLarge = "standard_large" // 140x140px
    case landscapeLarge = "landscape_large" // 190x140px
    case landscapeMedium = "landscape_medium" // 175x130px
    case portraitMedium = "portrait_medium" // 100x150px
    case portraitUncanny = "portrait_uncanny" //300x450px
}

struct CharacterImage: Codable {
    private let path: String?
    private let format: String?
    
    enum CodingKeys: String, CodingKey {
        case path
        case format = "extension"
    }
    
    func getImageURL(size: SizeImage) -> URL? {
        guard let path = path,
              let format = format else { return nil }
        return URL(string: "\(path)/\(size.rawValue).\(format)")
    }
}
