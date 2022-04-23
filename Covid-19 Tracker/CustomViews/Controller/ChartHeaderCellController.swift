//
//  ChartHeaderCellController.swift
//  Covid-19 Tracker
//
//  Created by Luiz Hammerli on 15/04/22.
//  Copyright © 2022 Luiz Hammerli. All rights reserved.
//

import UIKit
import Charts

final class ChartHeaderCellController {
    static let cellID = "headerCellID"
    
    let viewModel: CountryCasesHeaderViewModel
    var cell: ChartHeaderCell?
    var country: String
    
    init(viewModel: CountryCasesHeaderViewModel, country: String) {
        self.viewModel = viewModel
        self.country = country
    }
    
    func view(in collectionView: UICollectionView, for indexPath: IndexPath) -> UICollectionViewCell {
        cell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                                                   withReuseIdentifier: ChartHeaderCellController.cellID,
                                                               for: indexPath) as? ChartHeaderCell
        setupChartView()
        return cell!
    }
    
    func setupChartView() {
        cell?.countryLabel.text = country
        let activeDataEntry = PieChartDataEntry(value: viewModel.activeCount)
        let recoveredDataEntry = PieChartDataEntry(value: viewModel.recoveredCount)
        let deathsDataEntry = PieChartDataEntry(value: viewModel.deathsCount)

        let dataSet = PieChartDataSet(entries: [activeDataEntry, recoveredDataEntry, deathsDataEntry], label: nil)
        dataSet.highlightColor = .white

        let chartData = PieChartData(dataSet: dataSet)
        chartData.setDrawValues(false)

        dataSet.colors = [UIColor(named: Colors.customBlue) ?? UIColor(),
                          UIColor(named: Colors.customGreen) ?? UIColor(),
                          UIColor(named: Colors.customRed) ?? UIColor()]

        cell?.pieChart.data = chartData
        cell?.pieChart.holeRadiusPercent = 0.85
        cell?.pieChart.holeColor = UIColor(named: Colors.foreground)
        cell?.pieChart.drawEntryLabelsEnabled = false

        setupChartCenterText(value: viewModel.strTotalCount)
        
        cell?.chartsDetailBar.set(activeCount: viewModel.strActiveCount,
                            recoveredCount: viewModel.strRecoveredCount,
                            deathsCount: viewModel.strDeathsCount)
        
        cell?.setupViews()
    }
    
    func setupChartCenterText(value: String) {
        let atributtedText = NSMutableAttributedString(string: "\(Labels.totalCases)\n",
                                                       attributes: [NSAttributedString.Key.foregroundColor : UIColor.white,
                                                                    NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12,
                                                                                                                   weight: .bold)])
        atributtedText.append(NSAttributedString(string: value,
                                                 attributes: [NSAttributedString.Key.foregroundColor : UIColor.white,
                                                              NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17,
                                                                                                             weight: .heavy)]))
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.lineSpacing = 8

        let lenght = atributtedText.string.count

        atributtedText.addAttribute(NSAttributedString.Key.paragraphStyle,
                                    value: paragraphStyle,
                                    range: NSRange(location: 0,
                                                   length: lenght))

        cell?.pieChart.centerAttributedText = atributtedText
    }
    
    func sizeFor(frameSize: CGRect) -> CGSize {
        let size = frameSize.width-24
        return CGSize(width: size, height: size-20)
    }
    
    func insetForSection() -> UIEdgeInsets {
        return UIEdgeInsets(top: 24, left: 3, bottom: 0, right: 3)
    }
    
    func cancelLoad() {
        releaseCellForReuse()
    }
    
    private func releaseCellForReuse() {
        cell = nil
    }
}
