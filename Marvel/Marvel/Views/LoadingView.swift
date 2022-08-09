//
//  LoadingView.swift
//  Marvel
//
//  Created by Эван Крошкин on 9.08.22.
//

import SnapKit
import UIKit

class LoadingView: UIView {
    private lazy var loadingActivityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.style = .large
        indicator.color = .white
        indicator.startAnimating()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private lazy var blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .systemThickMaterial)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.alpha = 0.5
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        return blurEffectView
    }()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init() {
        super.init(frame: .zero)
        setupLayout()
    }
    
    private func setupLayout() {
        self.addSubview(blurEffectView)
        self.addSubview(loadingActivityIndicator)
        backgroundColor = UIColor.black.withAlphaComponent(0.3)
        blurEffectView.frame = bounds
        insertSubview(blurEffectView, at: 0)
        blurEffectView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        loadingActivityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
