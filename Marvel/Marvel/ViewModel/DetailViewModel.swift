//
//  DetailViewModel.swift
//  Marvel
//
//  Created by Эван Крошкин on 10.08.22.
//

import Foundation
import UIKit

protocol DetailViewModelProtocol: AnyObject {
    var resultComics: Observable<[Character]> {get set}
    var viewState: Observable<ViewState> {get set}
    var error: Observable<NetworkError> {get set}
    
    func fetchComics(with id: String)
}

class DetailViewModel: NSObject, DetailViewModelProtocol {
    
    // MARK: - Properties
    
    var resultComics: Observable<[Character]> = Observable([])
    var viewState: Observable<ViewState> = Observable(.loading)
    var error: Observable<NetworkError> = Observable(.serverError)
    var character: Character?
    
    // MARK: - Methods
    
    func fetchComics(with id: String) {
        self.viewState.value = .loading
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
