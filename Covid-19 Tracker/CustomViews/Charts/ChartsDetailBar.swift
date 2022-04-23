//
//  ChartsDetailBar.swift
//  Covid-19 Tracker
//
//  Created by Luiz on 11/04/20.
//  Copyright © 2020 Luiz Hammerli. All rights reserved.
//

import UIKit

final class ChartsDetailBar: UIView {
    private let chartsDetailStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .equalCentering
        return stackView
    }()

    private let activeValue = ChartsDetailView(dotColor: UIColor(named: Colors.customBlue), type: "Active")
    private let recoveredValue = ChartsDetailView(dotColor: UIColor(named: Colors.customGreen), type: "Recovered")
    private let deathsValue = ChartsDetailView(dotColor:UIColor(named:  Colors.customRed), type: "Deaths")

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func set(activeCount: String, recoveredCount: String, deathsCount: String) {
        activeValue.countLabel.text = activeCount
        recoveredValue.countLabel.text = recoveredCount
        deathsValue.countLabel.text = deathsCount
    }
}

extension ChartsDetailBar: CodeView {
    func buildViewHierarchy() {
        addSubview(chartsDetailStackView)

        chartsDetailStackView.addArrangedSubview(activeValue)
        chartsDetailStackView.addArrangedSubview(recoveredValue)
        chartsDetailStackView.addArrangedSubview(deathsValue)
    }

    func setupConstraints() {
        chartsDetailStackView.fillSuperview(padding: UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 25))
    }

    func setupAdditionalConfiguration() {
        backgroundColor = UIColor(named: Colors.foreground)
    }
}
