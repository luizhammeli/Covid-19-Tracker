//
//  ChartHeaderCell.swift
//  Covid-19 Tracker
//
//  Created by Luiz on 10/04/20.
//  Copyright © 2020 Luiz Hammerli. All rights reserved.
//

import UIKit
import Charts

final class ChartHeaderCell: UICollectionViewCell {
    static let cellID = "headerCellID"

    let countryLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 23, weight: .heavy)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()

    let chartView: UIView = {
        let view = UIView()
        return view
    }()

    let chartsDetailBar = ChartsDetailBar()

    let pieChart = PieChartView()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ChartHeaderCell: CodeView {
    func buildViewHierarchy() {
        addSubview(countryLabel)
        addSubview(chartView)
        addSubview(chartsDetailBar)
        chartView.addSubview(pieChart)
    }

    func setupConstraints() {
        countryLabel.anchor(top: topAnchor,
                            leading: leadingAnchor,
                            trailing: trailingAnchor,
                            padding: UIEdgeInsets(top: 14, left: 20, bottom: 0, right: 20))
        countryLabel.centerXInSuperview()

        chartView.anchor(top: countryLabel.bottomAnchor,
                         leading: leadingAnchor,
                         bottom: bottomAnchor,
                         trailing: trailingAnchor,
                         padding: UIEdgeInsets(top: 6, left: 16, bottom: 18, right: 16))

        chartsDetailBar.anchor(top: nil,
                               leading: leadingAnchor,
                               bottom: bottomAnchor,
                               trailing: trailingAnchor,
                               padding: UIEdgeInsets(top: 0, left: 0, bottom: 8, right: 0))

        pieChart.fillSuperview()
    }

    func setupAdditionalConfiguration() {
        backgroundColor = UIColor(named:  Colors.foreground)

        layer.cornerRadius = 8
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 9
        layer.shadowOpacity = 0.3
    }
}
