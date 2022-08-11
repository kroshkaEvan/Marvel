//
//  DetailViewController.swift
//  Marvel
//
//  Created by Эван Крошкин on 10.08.22.
//

import UIKit

class DetailViewController: UIViewController {
    
    // MARK: - Private properties

    private lazy var iconCharacterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.textColor = .white
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [iconCharacterImageView,
                                                       nameLabel])
        stackView.axis = .vertical
//        stackView.spacing = 3
        stackView.distribution = .fillProportionally
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var loadingView: LoadingView = {
        let loadingView =  LoadingView()
        loadingView.layer.zPosition = 999
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        return loadingView
    }()
    
    // MARK: - Public properties
    
    let viewModel = DetailViewModel()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        subscribeViewModel()
        setupLayout()
        fetchCharacter()
    }
    
    // MARK: - Private Methods
    
    private func setupLayout() {
        view.backgroundColor = .red
        [stackView, loadingView].forEach { view.addSubview($0) }
        
        stackView.snp.makeConstraints { make in
          make.leading.equalToSuperview()
          make.top.equalToSuperview()
          make.trailing.equalToSuperview()
          make.bottom.equalToSuperview()
        }
        loadingView.snp.makeConstraints { make in
          make.leading.equalToSuperview()
          make.top.equalToSuperview()
          make.trailing.equalToSuperview()
          make.bottom.equalToSuperview()
        }
    }
    
    private func fetchCharacter() {
        // image
        let URL = viewModel.character?.image?.getImageURL(size: .portraitUncanny)
        viewModel.loadImageView(self.iconCharacterImageView, URL: URL)
        // label
        nameLabel.text = viewModel.character?.name
        // tableView
        
    }
    
    private func showLoadingView() {
        loadingView.isHidden = false
    }
    
    private func hideLoadingView() {
        DispatchQueue.main.async {
            self.loadingView.isHidden = true
        }
    }
    
    private func showErrorAlertView() {
        let message = "\(viewModel.error.value.localizedDescription) \nTry again"
        let alertLogOut = UIAlertController(title: "Oops!",
                                            message: message,
                                            preferredStyle: .alert)
        alertLogOut.addAction(UIAlertAction(title: "OK",
                                            style: .cancel,
                                            handler: nil))
        viewModel.fetchComics()
        present(alertLogOut, animated: true)
    }
    
    private func subscribeViewModel() {
        viewModel.viewState.observe(on: self) { [weak self] (state) in
            guard let self = self else { return }
            switch state {
            case .loading:
                self.showLoadingView()
            case .loaded:
                self.hideLoadingView()
            case .failed:
                self.showErrorAlertView()
            }
        }
    }
}
