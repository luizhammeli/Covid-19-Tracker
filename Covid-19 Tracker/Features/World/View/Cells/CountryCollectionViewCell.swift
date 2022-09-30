//
//  CountryCollectionViewCell.swift
//  Covid-19 Tracker
//
//  Created by Luiz on 12/04/20.
//  Copyright © 2020 Luiz Hammerli. All rights reserved.
//

import UIKit

protocol CountryCollectionViewCellDelegate: AnyObject {
    func didRefresh()
}

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
        return label
    }()

    let totalCasesLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 13)        
        return label
    }()
    
    lazy var refreshButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "arrow.clockwise.circle.fill"),
                        for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(didRefresh), for: .touchUpInside)
        return button
    }()
    
    weak var delegate: CountryCollectionViewCellDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        flagImageView.image = nil
        refreshButton.isHidden = true
        totalCasesLabel.text = ""
        nameLabel.text = ""
    }
    
    @objc private func didRefresh() {
        print(123)
        delegate?.didRefresh()
    }
}

extension CountryCollectionViewCell: CodeView {
    func buildViewHierarchy() {
        addSubview(flagImageView)
        addSubview(chvronImage)
        addSubview(refreshButton)
    }

    func setupConstraints() {
        setupFlagImage()
        setupLabels()

        chvronImage.anchor(
            trailing: trailingAnchor,
            padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 16)
        )
        chvronImage.centerYInSuperview()
        chvronImage.anchor(height: 19, width: 19)
        
        refreshButton.centerX(in: flagImageView)
        refreshButton.centerY(in: flagImageView)
        refreshButton.anchor(height: 50, width: 50)
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
        refreshButton.isHidden = true
    }
}
