//
//  NetworkManager.swift
//  Marvel
//
//  Created by Эван Крошкин on 9.08.22.
//

import Foundation
import Alamofire

typealias CompletionClosure = ((Result<[Character], NetworkError>) -> Void)

class NetworkManager {
    static let shared = NetworkManager()
    
    private var parameters = Constants.API.parametrs
    
    func fetchCharacters(with name: String?, completion: @escaping CompletionClosure) {
        
        if let name = name {
            if !name.isEmpty {
                parameters["nameStartsWith"] = name
            } else {
                parameters.removeValue(forKey: "nameStartsWith")
            }
        }
        
        let url = "\(Constants.API.URL)characters"

        AF.sessionConfiguration.timeoutIntervalForRequest = 50
        AF.request(url,
                   method: .get,
                   parameters: parameters,
                   encoding: URLEncoding.default)
            .validate(statusCode: 200..<299)
            .validate(contentType: ["application/json"])
            .responseData { (responseData) in
                guard let responce = responseData.response
                else {
                    return completion(.failure(.serverError)) }
                if responce.statusCode >= 300 {
                    completion(.failure(.badURL))
                }
            }
            .responseDecodable(of: DataModel.self) { (response) in
                guard let characters = response.value?.data
                else {
                    return completion(.failure(.badJSON)) }
                completion(.success(characters.list))
            }
    }
    
    func fetchComics(with id: String, completion: @escaping CompletionClosure) {
        
        let url = "\(Constants.API.URL)characters/\(id)/comics"
        
        AF.sessionConfiguration.timeoutIntervalForRequest = 50
        AF.request(url,
                   method: .get,
                   parameters: parameters,
                   encoding: URLEncoding.default)
            .validate(statusCode: 200..<299)
            .validate(contentType: ["application/json"])
            .responseData { (responseData) in
                guard let responce = responseData.response
                else {
                    return completion(.failure(.serverError)) }
                if responce.statusCode >= 300 {
                    completion(.failure(.badURL))
                }
            }
            .responseDecodable(of: DataModel.self) { (response) in
                guard let characters = response.value?.data
                else {
                    return completion(.failure(.badJSON)) }
                
                completion(.success(characters.list))
            }
    }
}