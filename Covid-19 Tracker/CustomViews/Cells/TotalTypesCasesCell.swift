//
//  TotalTypesCasesCell.swift
//  Covid-19 Tracker
//
//  Created by Luiz on 10/04/20.
//  Copyright © 2020 Luiz Hammerli. All rights reserved.
//

import UIKit

final class TotalTypesCasesCell: UICollectionViewCell {
   static let cellID = "typerCllID"

    let typeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        label.font = .systemFont(ofSize: 15, weight: .medium)
        return label
    }()

    let countLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 15, weight: .heavy)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.9
        return label
    }()

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        return stackView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TotalTypesCasesCell: CodeView {
    func buildViewHierarchy() {
        addSubview(stackView)

        stackView.addArrangedSubview(typeLabel)
        stackView.addArrangedSubview(countLabel)
    }

    func setupConstraints() {
        stackView.anchor(leading: leadingAnchor,
                         trailing: trailingAnchor,
                         padding: UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 10))
        stackView.centerYInSuperview()
    }

    func setupAdditionalConfiguration() {
        backgroundColor = .clear
        layer.cornerRadius = 9
    }
}
