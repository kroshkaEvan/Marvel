//
//  MainCell.swift
//  Marvel
//
//  Created by Эван Крошкин on 9.08.22.
//

import UIKit

class MainCell: UICollectionViewCell {
    static let identifier = "MainCell"
    
    // MARK: - Public properties

    lazy var iconCharacterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 20
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .black)
        label.textColor = .white
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 2
        label.sizeToFit()
        label.setContentCompressionResistancePriority(.defaultHigh,
                                                      for: .horizontal)
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Private properties
    
    private lazy var gradienLayer: CAGradientLayer = {
        let gradienLayer = CAGradientLayer()
        gradienLayer.colors = [UIColor.clear.cgColor,
                               UIColor.red.cgColor]
        gradienLayer.locations = [0.5, 1.5]
        return gradienLayer
    }()
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradienLayer.frame = iconCharacterImageView.bounds
        iconCharacterImageView.layer.addSublayer(gradienLayer)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        animateCell(isHighlighted: true)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        animateCell(isHighlighted: false)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        animateCell(isHighlighted: false)
    }
    
    // MARK: - Private Methods
    
    private func setupLayout() {
        self.backgroundColor = .lightGray
        shadowDecorate()
        [iconCharacterImageView, nameLabel].forEach { self.addSubview($0) }
        iconCharacterImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        nameLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalTo(iconCharacterImageView.snp.bottom).offset(-30)
        }
    }
    
    private func animateCell(isHighlighted: Bool,
                             completion: ((Bool) -> Void)?=nil) {
        let backgroundColours = [UIColor.darkGray.cgColor, UIColor.red.cgColor]
        var backgroundLoop = 0
        if backgroundLoop < backgroundColours.count - 1 {
            backgroundLoop += 1
        } else {
            backgroundLoop = 0
        }
        if isHighlighted {
            UIView.animate(withDuration: 0.4,
                           delay: 0,
                           usingSpringWithDamping: 1,
                           initialSpringVelocity: 0,
                           options: .allowUserInteraction, animations: {
                self.transform = .init(scaleX: 0.92, y: 0.92)
                self.layer.shadowColor = backgroundColours[backgroundLoop]
                self.gradienLayer.locations = [0.1, 1.0]
                self.nameLabel.transform = .init(translationX: 0, y: -60)
            }, completion: completion)
        } else {
            UIView.animate(withDuration: 0.4,
                           delay: 0,
                           usingSpringWithDamping: 1,
                           initialSpringVelocity: 0,
                           options: .allowUserInteraction, animations: {
                self.transform = .identity
                self.layer.shadowColor = UIColor.darkGray.cgColor
                self.gradienLayer.locations = [0.5, 1.5]
                self.nameLabel.transform = .identity
            }, completion: completion)
        }
    }
    
    private func shadowDecorate() {
        let radius: CGFloat = 20
        contentView.layer.cornerRadius = radius
        contentView.layer.masksToBounds = true
        layer.shadowColor = UIColor.darkGray.cgColor
        layer.shadowOffset = CGSize(width: 6.0, height: 6.0)
        layer.shadowRadius = 6.0
        layer.shadowOpacity = 2
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(roundedRect: bounds,
                                        cornerRadius: radius).cgPath
        layer.cornerRadius = radius
    }
}
