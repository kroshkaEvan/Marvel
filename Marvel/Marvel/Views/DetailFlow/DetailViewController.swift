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
        imageView.layer.cornerRadius = 30
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18,
                                 weight: .semibold)
        label.textColor = .white
        label.numberOfLines = 12
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var gradienLayer: CAGradientLayer = {
        let gradienLayer = CAGradientLayer()
        gradienLayer.colors = [UIColor.clear.cgColor,
                               UIColor.black.cgColor]
        gradienLayer.locations = [0.3, 1.0]
        return gradienLayer
    }()
    
    private lazy var loadingView: LoadingView = {
        let loadingView =  LoadingView()
        loadingView.layer.zPosition = 999
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        return loadingView
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect.zero)
        tableView.backgroundColor = .white
        tableView.layer.cornerRadius = 10
        tableView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        tableView.separatorStyle = .none
        tableView.register(DetailCell.self,
                           forCellReuseIdentifier: DetailCell.identifier)
        return tableView
    }()
    
    // MARK: - Public properties
    
    let viewModel = DetailViewModel()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        subscribeViewModel()
        setupLayout()
        fetchCharacter()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        gradienLayer.frame = iconCharacterImageView.bounds
        iconCharacterImageView.layer.addSublayer(gradienLayer)
    }
    
    // MARK: - Private Methods
    
    private func setupLayout() {
        configureNavigation()
        view.backgroundColor = .white
        [iconCharacterImageView, descriptionLabel, loadingView, tableView].forEach { view.addSubview($0) }
        iconCharacterImageView.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.95)
            make.height.equalTo(view.frame.size.width * 0.85)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.centerX.equalToSuperview()
        }
        descriptionLabel.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.92)
            make.bottom.equalTo(iconCharacterImageView.snp.bottom).offset(-10)
            make.centerX.equalToSuperview()
        }
        descriptionLabel.bringSubviewToFront(view)
        loadingView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        tableView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalTo(iconCharacterImageView.snp.bottom)
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    private func configureNavigation() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: Constants.Image.close?.withRenderingMode(.alwaysOriginal),
                                                           style: .done,
                                                           target: self,
                                                           action: #selector(didTapBack))
        navigationController?.navigationBar.barTintColor = .white
        let attributes = [NSAttributedString.Key.font:
                            Constants.Font.titleFont ?? UIFont.systemFont(ofSize: 30, weight: .black)]
        UINavigationBar.appearance().titleTextAttributes = attributes
    }
    
    private func fetchCharacter() {
        viewModel.character?.image?.getImageView(self.iconCharacterImageView,
                                                 size: .standard)
        navigationController?.navigationBar.topItem?.title = viewModel.character?.name
        descriptionLabel.text = viewModel.character?.description
        fetchComics()
    }
    
    private func fetchComics() {
        if let id = viewModel.character?.id {
            viewModel.fetchComics(with: String(id))
        }
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
        present(alertLogOut, animated: true)
    }
    
    private func subscribeViewModel() {
        viewModel.viewState.observe(on: self) { [weak self] (state) in
            guard let self = self else { return }
            switch state {
            case .loading:
                self.showLoadingView()
            case .loaded:
                self.tableView.reloadData()
                self.hideLoadingView()
            case .failed:
                self.showErrorAlertView()
            }
        }
    }
    
    @objc private func didTapBack() {
        self.dismiss(animated: true)
    }
}

extension DetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.resultComics.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DetailCell.identifier,
                                                 for: indexPath)
        if let cell = cell as? DetailCell {
            let title = self.viewModel.character?.comics?.items?[indexPath.row].name
            let resultComics = self.viewModel.resultComics.value[indexPath.row]
            let description = resultComics.description
            resultComics.image?.getImageView(cell.backgroundImageView,
                                             size: .landscape)
            resultComics.image?.getImageView(cell.comicsImageView,
                                             size: .portrait)
            cell.titleLabel.text = title
            cell.descriptionLabel.text = description
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 240
    }
}
