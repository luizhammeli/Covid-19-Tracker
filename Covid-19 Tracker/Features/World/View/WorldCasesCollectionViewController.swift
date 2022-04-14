//
//  WorldCasesCollectionViewController.swift
//  Covid-19 Tracker
//
//  Created by Luiz on 12/04/20.
//  Copyright © 2020 Luiz Hammerli. All rights reserved.
//

import UIKit

class WorldCasesCollectionViewController: UICollectionViewController {
    let viewModel: WorldCasesViewModel
    init(viewModel: WorldCasesViewModel) {
        self.viewModel = viewModel
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupRefreshControl()
        registerCells()
        getCasesData()
    }

    func registerCells() {
        collectionView.register(ChartHeaderCell.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: ChartHeaderCell.cellID)
        collectionView.register(CountryCollectionViewCell.self, forCellWithReuseIdentifier: CountryCollectionViewCell.cellID)
    }

    func setupLayout() {
        collectionView.backgroundColor = UIColor(named: Colors.background)
        navigationItem.title = Labels.covid19
        collectionView.contentInset = UIEdgeInsets(top: 15, left: 12, bottom: 30, right: 12)
    }

    func setupRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .lightGray
        refreshControl.addTarget(self, action: #selector(getCasesData), for: UIControl.Event.valueChanged)
        collectionView.refreshControl =  refreshControl
    }
    

    @objc func getCasesData() {
        if !(collectionView.refreshControl?.isRefreshing ?? false) {
            showLoader()
        }
        viewModel.getWorldCasesData { [weak self] (success, errorMessage) in
            self?.removeLoader()
            self?.endRefreshingOnMainThread()
            guard success else {
                self?.showDefaultAlertOnMainThread(title: ErrorMessages.titleError.rawValue,
                                             message: errorMessage ?? ErrorMessages.genericError.rawValue)
                return
            }
            self?.reloadDataOnMainThread()
        }
    }
}

extension WorldCasesCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getNumberOfItems()
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 viewForSupplementaryElementOfKind kind: String,
                                 at indexPath: IndexPath) -> UICollectionReusableView {
        let cell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                                                   withReuseIdentifier: ChartHeaderCell.cellID,
                                                                   for: indexPath) as! ChartHeaderCell
        guard let headerViewModelItem = viewModel.countryCasesHeaderViewModelItem else { return cell }
        //cell.setupChartView(viewModelItem: headerViewModelItem, country: Labels.world)
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CountryCollectionViewCell.cellID,
                                                      for: indexPath) as! CountryCollectionViewCell
        cell.set(item: viewModel.getViewModelItem(with: indexPath))
        return cell
    }
}

extension WorldCasesCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        let size = view.bounds.width-24
        return CGSize(width: size, height: size-20)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 14, left: 0, bottom: 30, right: 0)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.bounds.width-28)
        return CGSize(width: width, height: width*0.22)
    }
}
