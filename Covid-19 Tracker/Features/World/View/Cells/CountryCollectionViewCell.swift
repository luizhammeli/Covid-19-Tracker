//
//  CountryCollectionViewCell.swift
//  Covid-19 Tracker
//
//  Created by Luiz on 12/04/20.
//  Copyright © 2020 Luiz Hammerli. All rights reserved.
//

import UIKit

class CountryCollectionViewCell: UICollectionViewCell {
    static let cellID = "CountryCollectionViewCellID"

    let flagImageView = AvatarImageView()

    let chvronImage: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 3
        imageView.tintColor = .white
        imageView.image = UIImage(systemName: "arrow.right",
                                  withConfiguration: UIImage.SymbolConfiguration(pointSize: 16, weight: .semibold))
        return imageView
    }()

    let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.text = "Brazil"
        return label
    }()

    let totalCasesLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 13)
        label.text = "Total Cases: 19"
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func set(item: CountryCasesViewModelItem) {
        nameLabel.text = item.countryName
        totalCasesLabel.text = item.totalCases
        flagImageView.fetchImage(stringUrl: item.countryFlagUrl)
    }
}

extension CountryCollectionViewCell: CodeView {
    func buildViewHierarchy() {
        addSubview(flagImageView)
        addSubview(chvronImage)
    }

    func setupConstraints() {
        setupFlagImage()
        setupLabels()

        chvronImage.anchor(trailing: trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 16))
        chvronImage.centerYInSuperview()
        chvronImage.anchor(height: 19, width: 19)
    }

    func setupLabels() {
        let stackView = UIStackView(arrangedSubviews: [nameLabel, totalCasesLabel, UIView()])
        stackView.spacing = 3
        stackView.axis = .vertical

        addSubview(stackView)

        stackView.centerYInSuperview()
        stackView.anchor(leading: flagImageView.trailingAnchor,
                         trailing: chvronImage.leadingAnchor,
                         padding: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 6))
    }

    func setupFlagImage() {
        let flagHeight = bounds.height-34
        flagImageView.anchor(leading: leadingAnchor, padding: UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0))
        flagImageView.centerYInSuperview()
        flagImageView.anchor(height:flagHeight, width: flagHeight*1.7)
    }

    func setupAdditionalConfiguration() {
        backgroundColor = UIColor(named: "Foreground")
        layer.cornerRadius = 6
    }
}
