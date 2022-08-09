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
                                           right: cellsSpacing )
        let numberOfItemsInSection = 2
        let cellWidth = (view.bounds.width
                         - cellsSpacing
                         * (CGFloat(numberOfItemsInSection) + 1)) / CGFloat(numberOfItemsInSection)
        let cellHeight = cellWidth * 1.2
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
        return searchController
    }()
    
    private lazy var loadingView: LoadingView = {
        let loading =  LoadingView()
        loading.layer.zPosition = 999
        return loading
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    private func setupLayout() {
        view.backgroundColor = .cyan
        [collectionView].forEach { view.addSubview($0) }
        
    }


}

