//
//  DetailViewModel.swift
//  Marvel
//
//  Created by Эван Крошкин on 10.08.22.
//

import Foundation
import UIKit

protocol DetailViewModelProtocol: AnyObject {
    var resultCharacters: Observable<[Character]> {get set}
    var resultComics: Observable<[Character]> {get set}
    var viewState: Observable<ViewState> {get set}
    var error: Observable<NetworkError> {get set}
    
    func fetchCharacters()
    func fetchComics(with id: String)
}

class DetailViewModel: NSObject, DetailViewModelProtocol {
    var resultCharacters: Observable<[Character]> = Observable([])
    var resultComics: Observable<[Character]> = Observable([])
    var viewState: Observable<ViewState> = Observable(.loading)
    var error: Observable<NetworkError> = Observable(.serverError)
    var id: Int?
    var name: String?
    
    func fetchCharacters() {
        guard let name = name else { return }
        self.viewState.value = .loading
        NetworkManager.shared.fetchCharacters(with: name) { [weak self] (result) in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case let .success(result):
                    self.resultCharacters.value = result
                    guard let id = self.id else { return }
                    self.fetchComics(with: String(describing: id))
                    self.viewState.value = .loaded
                case let .failure(error):
                    self.error.value = error
                    self.viewState.value = .failed
                }
            }
        }
    }
    
    func fetchComics(with id: String) {
        NetworkManager.shared.fetchComics(with: id) { [weak self] (result) in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case let .success(result):
                    self.resultComics.value = result
                    self.viewState.value = .loaded
                case let .failure(error):
                    self.error.value = error
                    self.viewState.value = .failed
                }
            }
        }
    }
}
