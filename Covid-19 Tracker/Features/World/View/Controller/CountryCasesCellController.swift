//
//  CountryCasesCellController.swift
//  Covid-19 Tracker
//
//  Created by Luiz Diniz Hammerli on 09/09/22.
//  Copyright © 2022 Luiz Hammerli. All rights reserved.
//

import UIKit

final class CountryCasesCellController {
    static let cellID = "typerCllID"
    
    private let viewModel: CountryCasesViewModel
    private var cell: CountryCollectionViewCell?
    
    var loadImage: ((String) -> Void)?
    
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
        loadImage?(viewModel.countryFlagUrl)
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
        cell?.delegate = nil
        cell = nil
    }
}

extension CountryCasesCellController: CountryCollectionViewCellDelegate {
    func didRefresh() {
        loadImage?(viewModel.countryFlagUrl)
    }
}

extension CountryCasesCellController: ImageView {
    func display(image: UIImage?) {
        
        guard let image = image else {
            cell?.refreshButton.isHidden = false
            cell?.delegate = self
            return
        }
        
        cell?.flagImageView.alpha = 0
        cell?.flagImageView.image = image
         cell?.refreshButton.isHidden = true

        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            self?.cell?.flagImageView.alpha = 1
        })
    }
}
