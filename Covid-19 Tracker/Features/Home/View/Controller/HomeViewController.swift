//
//  ViewController.swift
//  Covid-19 Tracker
//
//  Created by Luiz on 10/04/20.
//  Copyright © 2020 Luiz Hammerli. All rights reserved.
//

import UIKit

final class HomeViewController: UICollectionViewController {
    var listModels: [HomeViewListSection] = [] { didSet { collectionView.reloadData() } }
    var loadData: (() -> Void)?
    
    init() {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        registerCells()
        loadData?()
    }

    private func registerCells() {
        collectionView.register(ChartHeaderCell.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: ChartHeaderCellController.cellID)        
        collectionView.register(TotalTypesCasesCell.self, forCellWithReuseIdentifier: TotalTypesCasesCellController.cellID)
    }

    private func setupLayout() {
        navigationItem.title = Labels.covid19
        collectionView.backgroundColor = UIColor(named: Colors.background)
        collectionView.contentInset = UIEdgeInsets(top: 15, left: 12, bottom: 30, right: 12)
        setupRefreshControl()
    }

    private func setupRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .lightGray
        refreshControl.addTarget(self, action: #selector(refreshData), for: UIControl.Event.valueChanged)
        collectionView.refreshControl =  refreshControl
    }
    
    @objc private func refreshData() {
        collectionView.refreshControl?.beginRefreshing()
        loadData?()
    }
}

extension HomeViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listModels[section].list.count
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return listModels.count
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 viewForSupplementaryElementOfKind kind: String,
                                 at indexPath: IndexPath) -> UICollectionReusableView {
        return listModels[indexPath.section].header.view(in: collectionView, for: indexPath)
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return listModels[indexPath.section].list[indexPath.item].view(in: collectionView, for: indexPath)
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        return listModels[section].header.sizeFor(frameSize: view.bounds)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return listModels[section].header.insetForSection()
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {        
        return listModels[indexPath.section].list[indexPath.item].sizeForItemAt(parentViewSize: view.bounds)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        listModels[indexPath.section].list[indexPath.item].cancelLoad()
    }
    
    override func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        listModels[indexPath.section].header.cancelLoad()
    }
}

extension HomeViewController: AlertView {
    func display(message: AlertViewModel) {
        showDefaultAlertOnMainThread(title: "Error!", message: message.description)
    }
}

extension HomeViewController: LoadingView {
    func isLoading(viewModel: LoadingViewModel) {
        if viewModel.isLoading {
            showLoader()
        } else {
            collectionView.refreshControl?.endRefreshing()
            removeLoader()
        }
    }
}
