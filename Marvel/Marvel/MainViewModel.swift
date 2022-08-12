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
    var resultCharacters: Observable<[Character]> {get set}
    var viewState: Observable<ViewState> {get set}
    var error: Observable<NetworkError> {get set}
    
    func fetchCharacters(with name: String?)
    func produceCharacterToViewModel(_ vc: UIViewController, character: Character)
}

class MainViewModel: NSObject, MainViewModelProtocol {
    
    // MARK: - Properties

    var resultCharacters: Observable<[Character]> = Observable([])
    var viewState: Observable<ViewState> = Observable(.loading)
    var error: Observable<NetworkError> = Observable(.serverError)
    
    // MARK: - Initializer
    
    override init() {
        super .init()
        fetchCharacters()
    }
    
    // MARK: - Methods
    
    func fetchCharacters(with name: String? = nil) {
        viewState.value = .loading
        NetworkManager.shared.fetchCharacters(with: name) { [weak self] (result) in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case let .success(result):
                    self.resultCharacters.value = result
                    self.viewState.value = .loaded
                case let .failure(error):
                    self.error.value = error
                    self.viewState.value = .failed
                }
            }
        }
    }
    
    func produceCharacterToViewModel(_ vc: UIViewController, character: Character) {
        let viewController = DetailViewController()
        let detailViewModel = viewController.viewModel
        detailViewModel.character = character
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.modalPresentationStyle = .fullScreen
        vc.navigationController?.present(navigationController, animated: true)
    }
}




