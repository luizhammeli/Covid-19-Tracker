//
//  ChartHeaderCell.swift
//  Covid-19 Tracker
//
//  Created by Luiz on 10/04/20.
//  Copyright © 2020 Luiz Hammerli. All rights reserved.
//

import UIKit

class ChartHeaderCell: UICollectionViewCell {
   static let cellID = "headerCellID"

    let countryLabel: UILabel = {
        let label = UILabel()
        label.text = "Brazil"
        label.font = .systemFont(ofSize: 22, weight: .heavy)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()

    let chartView: UIView = {
        let view = UIView()
        view.backgroundColor = .cyan
        return view
    }()

    let chartsDetailStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .equalCentering
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

extension ChartHeaderCell: CodeView {
    func buildViewHierarchy() {
        addSubview(countryLabel)
        addSubview(chartView)
        addSubview(chartsDetailStackView)
    }

    func setupConstraints() {
        countryLabel.anchor(top: topAnchor,
                            leading: leadingAnchor,
                            trailing: trailingAnchor,
                            padding: UIEdgeInsets(top: 14, left: 20, bottom: 0, right: 20))

        countryLabel.centerXInSuperview()

        setupStackView()

        chartView.anchor(top: countryLabel.bottomAnchor, leading: leadingAnchor, bottom: chartsDetailStackView.topAnchor, trailing: trailingAnchor, padding: UIEdgeInsets(top: 20, left: 40, bottom: 20, right: 40))
    }

    func setupAdditionalConfiguration() {
        backgroundColor = UIColor(named: "Foreground")

        layer.cornerRadius = 8

        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 9
        layer.shadowOpacity = 0.3
    }


    func setupStackView() {
        chartsDetailStackView.addArrangedSubview(ChartsDetailView(dotColor: #colorLiteral(red: 0.2666666667, green: 0.5882352941, blue: 0.9254901961, alpha: 1), type: "Active"))
        chartsDetailStackView.addArrangedSubview(ChartsDetailView(dotColor: #colorLiteral(red: 0.337254902, green: 0.5647058824, blue: 0.3019607843, alpha: 1), type: "Recovered"))
        chartsDetailStackView.addArrangedSubview(ChartsDetailView(dotColor: #colorLiteral(red: 0.8901960784, green: 0.3215686275, blue: 0.2549019608, alpha: 1), type: "Deaths"))

        chartsDetailStackView.anchor(top: nil,
                                     leading: leadingAnchor,
                                     bottom: bottomAnchor,
                                     trailing: trailingAnchor,
                                     padding: UIEdgeInsets(top: 0, left: 25, bottom: 8, right: 25))
        
    }
}

class ChartsDetailView: UIView {
    let dotView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.8901960784, green: 0.3215686275, blue: 0.2549019608, alpha: 1)
        view.layer.cornerRadius = 5
        return view
    }()

    let typeLabel: UILabel = {
        let label = UILabel()
        label.text = "Active"
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

    init(dotColor: UIColor, type: String){
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

final class Spacer: UIView {

    let space: CGFloat

    override var intrinsicContentSize: CGSize {
        return CGSize(width: space, height: space)
    }

    init(_ space: CGFloat) {
        self.space = space
        super.init(frame: .zero)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

