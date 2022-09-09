//
//  CountryCasesCellController.swift
//  Covid-19 Tracker
//
//  Created by Luiz Diniz Hammerli on 09/09/22.
//  Copyright © 2022 Luiz Hammerli. All rights reserved.
//

import UIKit

final class CountryCasesCellController {
    private let viewModel: CountryCasesViewModel
    private var cell: CountryCollectionViewCell?
    static let cellID = "typerCllID"

    init(viewModel: CountryCasesViewModel) {
        self.viewModel = viewModel
    }

    func view(in collectionView: UICollectionView, for indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CountryCollectionViewCell.cellID,
            for: indexPath) as? CountryCollectionViewCell else { return UICollectionViewCell() }

        self.cell = cell
        set()
        return cell
    }

    func set() {
        cell?.nameLabel.text = viewModel.countryName
        cell?.totalCasesLabel.text = viewModel.totalCases
        cell?.flagImageView.fetchImage(stringUrl: viewModel.countryFlagUrl)
    }

    func sizeForItemAt(parentViewSize: CGRect) -> CGSize {
        let width = (parentViewSize.width-28)
        return CGSize(width: width, height: width*0.22)
    }

    func insetForSection() -> UIEdgeInsets {
        return UIEdgeInsets(top: 14, left: 0, bottom: 30, right: 0)
    }

    func cancelLoad() {
        releaseCellForReuse()
    }

    private func releaseCellForReuse() {
        cell = nil
    }
}
