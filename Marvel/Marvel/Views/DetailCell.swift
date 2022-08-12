//
//  DetailCell.swift
//  Marvel
//
//  Created by Эван Крошкин on 10.08.22.
//

import UIKit

class DetailCell: UITableViewCell {
    static let identifier = "DetailCell"
    
    // MARK: - Private properties
    
    private lazy var blurEffectView: UIVisualEffectView = {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.layer.cornerRadius = 30
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Public properties
    
    lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        imageView.layer.cornerRadius = 30
        imageView.layer.masksToBounds = false
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var comicsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20,
                                 weight: .bold)
        label.textColor = .white
        label.numberOfLines = 2
        label.sizeToFit()
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15,
                                 weight: .medium)
        label.textColor = .white
        label.numberOfLines = .zero
        label.sizeToFit()
        label.minimumScaleFactor = 0.15
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initializers

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    
    private func setupLayout() {
        backgroundColor = .clear
        selectionStyle = .none
        [backgroundImageView, blurEffectView, comicsImageView, titleLabel, descriptionLabel].forEach { self.addSubview($0) }
        backgroundImageView.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.95)
            make.height.equalToSuperview().multipliedBy(0.95)
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        blurEffectView.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.95)
            make.height.equalToSuperview().multipliedBy(0.95)
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        comicsImageView.snp.makeConstraints { make in
            make.top.equalTo(blurEffectView.snp.top).offset(10)
            make.leading.equalTo(blurEffectView.snp.leading).offset(10)
            make.bottom.equalTo(blurEffectView.snp.bottom).offset(-10)
            make.width.equalTo(150)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(blurEffectView.snp.top).offset(5)
            make.trailing.equalTo(blurEffectView.snp.trailing).offset(-5)
            make.leading.equalTo(comicsImageView.snp.trailing).offset(5)
        }
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.trailing.equalTo(blurEffectView.snp.trailing).offset(-5)
            make.leading.equalTo(comicsImageView.snp.trailing).offset(5)
            make.bottom.equalTo(comicsImageView.snp.bottom)
        }
    }
}
