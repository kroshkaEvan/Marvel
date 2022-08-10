//
//  DetailViewModel.swift
//  Marvel
//
//  Created by Эван Крошкин on 10.08.22.
//

import Foundation
import UIKit
import Nuke

protocol DetailViewModelProtocol: AnyObject {
    var resultComics: Observable<[Character]> {get set}
    var viewState: Observable<ViewState> {get set}
    var error: Observable<NetworkError> {get set}
    
    func fetchComics()
    func loadImageView(_ view: UIImageView, URL: URL?)
    
}

class DetailViewModel: NSObject, DetailViewModelProtocol {
    var resultComics: Observable<[Character]> = Observable([])
    var viewState: Observable<ViewState> = Observable(.loading)
    var error: Observable<NetworkError> = Observable(.serverError)
    var character: Character?
    
    func fetchComics() {
        self.viewState.value = .loading
        guard let character = character else { return }
        NetworkManager.shared.fetchComics(with: String(describing: character.id)) { [weak self] (result) in
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
    
    func loadImageView(_ view: UIImageView, URL: URL?) {
        self.viewState.value = .loading
        DispatchQueue.main.async {
            if let URL = URL {
                Nuke.loadImage(with: URL, into: view)
                self.viewState.value = .loaded
            }
        }
    }
}
