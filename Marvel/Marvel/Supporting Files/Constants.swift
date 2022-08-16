//
//  Constants.swift
//  Marvel
//
//  Created by Эван Крошкин on 9.08.22.
//

import Foundation
import UIKit

class Constants {
    struct API {
        static let URL = "https://gateway.marvel.com/v1/public/"
        static let apiPublicKey = "893086509a94a3130aca4a8b3260384d"
        static let apiPrivateKey = "176983ed196415b6b6611321a137b3105d3ea1ca"
        static var timestamp: String {
            return String(Date().getTimeIntervalSince1970())
        }
        static var hash: String {
            return String(timestamp + apiPrivateKey + apiPublicKey).md5()
        }
        static var parametrs = ["apikey": apiPublicKey,
                                "ts": timestamp,
                                "hash": hash]
    }
    
    class Strings {
        static let placeholder = "Enter a Marvel character"
    }
    
    class Image {
        static let backgroundOptionsImage = UIImage(named: "shield")
    }
}
