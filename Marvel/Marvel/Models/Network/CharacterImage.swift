//
//  CharacterImage.swift
//  Marvel
//
//  Created by Эван Крошкин on 9.08.22.
//

import UIKit
import Nuke

enum SizeImage: String {
    case standard = "standard_fantastic" // 250x250px
    case landscape = "landscape_incredible" // 464x261px
    case portrait = "portrait_uncanny" //300x450px
}

struct CharacterImage: Decodable {
    private let path: String?
    private let format: String?
    
    enum CodingKeys: String, CodingKey {
        case path
        case format = "extension"
    }
    
    func getImageView(_ imageView: UIImageView, size: SizeImage) {
        guard let path = path,
              let format = format else { return }
        if let url = URL(string: "\(path)/\(size.rawValue).\(format)") {
            let options = ImageLoadingOptions(
                placeholder: Constants.Image.backgroundOptionsImage,
                transition: .fadeIn(duration: 0.5)
            )
            Nuke.loadImage(with: url, options: options, into: imageView)
        }
    }
}
