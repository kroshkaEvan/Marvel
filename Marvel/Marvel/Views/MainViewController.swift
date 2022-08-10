//
//  ViewController.swift
//  Marvel
//
//  Created by Эван Крошкин on 9.08.22.
//

import UIKit
import SnapKit

class MainViewController: UIViewController {
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cellsSpacing = CGFloat(10)
        layout.sectionInset = UIEdgeInsets(top: cellsSpacing ,
                                           left: cellsSpacing ,
                                           bottom: cellsSpacing,
                                           right: cellsSpacing)
        var numberOfItemsInSection = 2
        // for iPad
        if view.frame.size.width > 500 {
            numberOfItemsInSection = 5
        }
        let cellWidth = (view.bounds.width
                         - cellsSpacing
                         * (CGFloat(numberOfItemsInSection) + 1)) / CGFloat(numberOfItemsInSection)
        let cellHeight = cellWidth * 1.7
        layout.minimumLineSpacing = cellsSpacing
        layout.minimumInteritemSpacing = cellsSpacing
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        let sectionHeight = CGFloat(4)
        layout.headerReferenceSize = CGSize(width: self.view.frame.size.width,
                                            height: sectionHeight)
        let collectionView = UICollectionView(frame: self.view.frame,
                                              collectionViewLayout: layout)
        collectionView.register(MainCell.self,
                                forCellWithReuseIdentifier: MainCell.identifier)
        collectionView.backgroundColor = .lightGray
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = Constants.Strings.placeholder
        searchController.searchBar.autocapitalizationType = .none
        searchController.searchBar.tintColor = .white
        searchController.searchBar.backgroundColor = .red
        return searchController
    }()
    
    private lazy var loadingView: LoadingView = {
        let loadingView =  LoadingView()
        loadingView.layer.zPosition = 999
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        return loadingView
    }()
    
    private let viewModel = MainViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        setupLayout()
        subscribeViewModel()
    }
    
    private func setupLayout() {
        configureNavigation()
        showLoadingView()
        [collectionView, loadingView].forEach { view.addSubview($0) }
        view.bringSubviewToFront(loadingView)
        
        collectionView.snp.makeConstraints { make in
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
    
    private func configureNavigation() {
        navigationController?.navigationBar.backgroundColor = .red
        let imageContainer = UIView(frame: CGRect(x: 0, y: 0, width: 270, height: 50))
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 270, height: 50))
        imageView.contentMode = .scaleAspectFit
        let image = UIImage(named: "Marvel")
        imageView.image = image
        imageContainer.addSubview(imageView)
        navigationItem.titleView = imageContainer
        navigationItem.searchController = searchController
        self.navigationController?.navigationBar.isTranslucent = false
        self.definesPresentationContext = true
        navigationItem.hidesSearchBarWhenScrolling = false
    }

    
    private func showErrorAlertView() {
        
    }
    
    private func showLoadingView() {
        loadingView.isHidden = false
    }
    
    private func hideLoadingView() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(1), execute: { () -> Void in
            self.loadingView.isHidden = true
        })
    }
    
    private func subscribeViewModel() {
        viewModel.resultCharacters.observe(on: self) { [weak self] _ in
            self?.collectionView.reloadData()
        }
        
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

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.resultCharacters.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainCell.identifier,
                                                      for: indexPath)
        if let cell = cell as? MainCell {
            let character = viewModel.resultCharacters.value[indexPath.row]
            cell.nameLabel.text = character.name
            let cellURL = character.image?.getImageURL(size: .portraitUncanny)
            viewModel.loadImageView(cell.iconCharacterImageView, URL: cellURL)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath,
                                    animated: true)
        let character = viewModel.resultCharacters.value[indexPath.row]
        viewModel.produceCharacterToViewModel(self, character: character)
    }
}

extension MainViewController: UISearchResultsUpdating, UISearchControllerDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        viewModel.viewState.observe(on: self) { [weak self] (state) in
            guard let self = self else { return }
            if state == .loading {
                self.showLoadingView()
            } else {
                self.hideLoadingView()
            }
        }
        viewModel.fetchCharacters(with: text)
    }
}

