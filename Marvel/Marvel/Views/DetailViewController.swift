//
//  DetailViewController.swift
//  Marvel
//
//  Created by Эван Крошкин on 10.08.22.
//

import UIKit

class DetailViewController: UIViewController {
    
    let viewModel = DetailViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        subscribeViewModel()
    }
    
    private func subscribeViewModel() {
//        viewModel.viewState.observe(on: self) { [weak self] (state) in
//            guard let self = self else { return }
//            switch state {
//            case .loading:
//            case .loaded:
//            case .failed:
//            }
//        }
    }
}
