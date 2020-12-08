//
//  FeatureHeaderView.swift
//  SwiftExampleApp
//
//  Created by Mihai Petrenco on 12/8/20.
//  Copyright © 2020 Judopay. All rights reserved.
//

import UIKit

class FeatureHeaderView: UIView {
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayout()
        setupConstraints()
    }
    
    // MARK: - Layout setup
    
    private func setupLayout() {
        backgroundColor = .systemBackground
        addSubview(titleLabel)
    }
    
    private func setupConstraints() {
        let constraints = [
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 30.0),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10.0),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20.0),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10.0),
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    // MARK: - Lazy instantiations
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Features"
        return label
    }()
}
