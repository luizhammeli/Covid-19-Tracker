//
//  ChartsDetailView.swift
//  Covid-19 Tracker
//
//  Created by Luiz on 11/04/20.
//  Copyright © 2020 Luiz Hammerli. All rights reserved.
//

import UIKit

class ChartsDetailView: UIView {
    let dotView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.8901960784, green: 0.3215686275, blue: 0.2549019608, alpha: 1)
        view.layer.cornerRadius = 5
        return view
    }()

    let typeLabel: UILabel = {
        let label = UILabel()        
        label.font = .systemFont(ofSize: 14)
        label.textColor = .white
        return label
    }()

    let countLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.font = .boldSystemFont(ofSize: 14)
        label.textColor = .white
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        return label
    }()

    let hStack: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 7
        return stackView
    }()

    let vStack: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 9
        stackView.axis = .vertical
        return stackView
    }()

    init(dotColor: UIColor?, type: String){
        super.init(frame: .zero)
        typeLabel.text = type
        dotView.backgroundColor = dotColor
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ChartsDetailView: CodeView {
    func buildViewHierarchy() {
        addSubview(vStack)

        hStack.addArrangedSubview(dotView)
        hStack.addArrangedSubview(typeLabel)

        vStack.addArrangedSubview(hStack)
    }

    func setupConstraints() {
        dotView.anchor(height: 10, width: 10)
        vStack.fillSuperview()

        let stackView = UIStackView(arrangedSubviews: [countLabel])
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 18, bottom: 0, right: 0)

        vStack.addArrangedSubview(stackView)
    }

    func setupAdditionalConfiguration() {}
}

