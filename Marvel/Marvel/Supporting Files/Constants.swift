//
//  Constants.swift
//  Marvel
//
//  Created by Эван Крошкин on 9.08.22.
//

import Foundation

class Constants {
    class API {
        static let URL = "https://gateway.marvel.com/v1/public/"
        static let apiPublicKey = "893086509a94a3130aca4a8b3260384d"
        static let apiPrivateKey = "176983ed196415b6b6611321a137b3105d3ea1ca"
        static var timestamp: String {
            return String(Date().getCurrentTimestamp())
        }
        static var hash: String {
            return String(timestamp + apiPrivateKey + apiPublicKey).md5()
        }
        static var parametrs = ["apikey": apiPublicKey,
                                "ts": timestamp,
                                "hash": hash]
    }
}