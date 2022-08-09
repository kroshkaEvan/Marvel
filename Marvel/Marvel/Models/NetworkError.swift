//
//  NetworkError.swift
//  Marvel
//
//  Created by Эван Крошкин on 9.08.22.
//

import Foundation

enum NetworkError: Error, LocalizedError {
    case badURL, badJSON, serverError
    
    var errorDescription: String? {
        switch self {
        case .badURL:
            return "Invalid URL"
        case .badJSON:
            return "Can't load data"
        case .serverError:
            return "Server not responding. Try again later"
        }
    }
}
