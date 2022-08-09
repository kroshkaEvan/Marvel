//
//  MainViewModel.swift
//  Marvel
//
//  Created by Эван Крошкин on 9.08.22.
//

import Foundation
import UIKit
import Nuke

enum ViewState {
    case loading, loaded, failed
}

protocol MainViewModelProtocol: AnyObject {
    var characters: Observable<[Character]> {get set}
    var viewState: Observable<ViewState> {get set}
    var error: Observable<NetworkError> {get set}
    
    func fetchCharacters(with name: String?)
    func loadImageView(_ view: UIImageView, URL: URL?)
}

class MainViewModel: NSObject, MainViewModelProtocol {
    var characters: Observable<[Character]> = Observable([])
    var viewState: Observable<ViewState> = Observable(.loading)
    var error: Observable<NetworkError> = Observable(.serverError)
        
    override init() {
        super .init()
        fetchCharacters()
    }
    
    func fetchCharacters(with name: String? = nil) {
        self.viewState.value = .loading
        NetworkManager.shared.fetchCharacters(with: name) { [weak self] (result) in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case let .success(result):
                    self.characters.value = result
                    self.viewState.value = .loaded
                case let .failure(error):
                    self.error.value = error
                    self.viewState.value = .failed
                }
            }
        }
    }
    
    func loadImageView(_ view: UIImageView, URL: URL?) {
        if let URL = URL {
            Nuke.loadImage(with: URL, into: view)
        }
    }
}




