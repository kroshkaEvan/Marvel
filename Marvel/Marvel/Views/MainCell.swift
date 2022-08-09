//
//  MainCell.swift
//  Marvel
//
//  Created by Эван Крошкин on 9.08.22.
//

import UIKit

class MainCell: UICollectionViewCell {
    static let identifier = "MainCell"
    
    lazy var iconCharacterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = UIColor.white
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 2
        label.setContentCompressionResistancePriority(
            .defaultHigh,
            for: .horizontal)
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [iconCharacterImageView,
                                                       nameLabel])
        stackView.axis = .vertical
        stackView.spacing = 3
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    
    private func animateCell(isHighlighted: Bool,
                             completion: ((Bool) -> Void)?=nil) {
        if isHighlighted {
            self.animateBackgroundColour ()
            UIView.animate(withDuration: 0.45,
                           delay: 0,
                           usingSpringWithDamping: 1,
                           initialSpringVelocity: 0,
                           options: .allowUserInteraction, animations: {
                self.transform = .init(scaleX: 0.92, y: 0.92)
            }, completion: completion)
        } else {
            self.backgroundColor = .lightGray
            UIView.animate(withDuration: 0.45,
                           delay: 0,
                           usingSpringWithDamping: 1,
                           initialSpringVelocity: 0,
                           options: .allowUserInteraction, animations: {
                self.transform = .identity
            }, completion: completion)
        }
    }
    
    private func animateBackgroundColour() {
        let backgroundColours = [UIColor.lightGray, UIColor.red]
        var backgroundLoop = 0
        if backgroundLoop < backgroundColours.count - 1 {
            backgroundLoop += 1
        } else {
            backgroundLoop = 0
        }
        UIView.animate(withDuration: 0.45,
                       delay: 0,
                       options: .allowUserInteraction,
                       animations: {
            self.backgroundColor = backgroundColours[ backgroundLoop]
        })
    }
    
    private func shadowDecorate() {
        let radius: CGFloat = 10
        contentView.layer.cornerRadius = radius
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.white.cgColor
        contentView.layer.masksToBounds = true
        layer.shadowColor = UIColor.red.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 1.0)
        layer.shadowRadius = 4.5
        layer.shadowOpacity = 3
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(roundedRect: bounds,
                                        cornerRadius: radius).cgPath
        layer.cornerRadius = radius
    }
    
    private func setupLayout() {
        self.backgroundColor = .lightGray
        shadowDecorate()
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
