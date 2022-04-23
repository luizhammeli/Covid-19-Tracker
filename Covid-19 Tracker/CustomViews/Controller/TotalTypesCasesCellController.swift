//
//  TotalTypesCasesCellController.swift
//  Covid-19 Tracker
//
//  Created by Luiz Hammerli on 15/04/22.
//  Copyright © 2022 Luiz Hammerli. All rights reserved.
//

import UIKit

final class TotalTypesCasesCellController {
    private let viewModel: CountryCaseTypeViewModel
    private var cell: TotalTypesCasesCell?
    static let cellID = "typerCllID"
    
    init(viewModel: CountryCaseTypeViewModel) {
        self.viewModel = viewModel
    }
    
    func view(in collectionView: UICollectionView, for indexPath: IndexPath) -> UICollectionViewCell {
        cell = collectionView.dequeueReusableCell(withReuseIdentifier: TotalTypesCasesCellController.cellID,
                                                  for: indexPath) as? TotalTypesCasesCell
        set()
        return cell!
    }
    
    func set() {
        cell?.backgroundColor = UIColor(named: viewModel.color ?? "")
        cell?.typeLabel.text = viewModel.title
        cell?.countLabel.text = viewModel.count
    }
    
    func sizeForItemAt(parentViewSize: CGRect) -> CGSize {
        let width = (parentViewSize.width-40) / 2
        return CGSize(width: width, height: width/1.9)
    }
    
    func cancelLoad() {
        releaseCellForReuse()
    }
    
    private func releaseCellForReuse() {
        cell = nil
    }
}
