//
//  WorldCasesCollectionViewController.swift
//  Covid-19 Tracker
//
//  Created by Luiz on 12/04/20.
//  Copyright © 2020 Luiz Hammerli. All rights reserved.
//

import UIKit

class WorldCasesCollectionViewController: UICollectionViewController {
    var listSections: [WorldCasesViewListSection] = [] {
        didSet {
            collectionView.reloadData()
        }        
    }
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
        setupRefreshControl()
        registerCells()
        loadData?()
    }

    private func registerCells() {
        collectionView.register(ChartHeaderCell.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: ChartHeaderCell.cellID)
        collectionView.register(CountryCollectionViewCell.self, forCellWithReuseIdentifier: CountryCollectionViewCell.cellID)
    }

    private func setupLayout() {
        navigationItem.title = Labels.covid19
        collectionView.backgroundColor = UIColor(named: Colors.background)
        collectionView.contentInset = UIEdgeInsets(top: 15, left: 12, bottom: 30, right: 12)
    }

    private func setupRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .lightGray
        refreshControl.addTarget(self, action: #selector(fetchCasesData), for: UIControl.Event.valueChanged)
        collectionView.refreshControl =  refreshControl
    }
    
    @objc private func fetchCasesData() {
        loadData?()
    }
}

extension WorldCasesCollectionViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return listSections.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listSections[section].list.count
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 viewForSupplementaryElementOfKind kind: String,
                                 at indexPath: IndexPath) -> UICollectionReusableView {
        return listSections[indexPath.section].header.view(in: collectionView, for: indexPath)
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return listSections[indexPath.section].list[indexPath.item].view(in: collectionView, for: indexPath)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        listSections[indexPath.section].list[indexPath.item].cancelLoad()
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 didEndDisplayingSupplementaryView view: UICollectionReusableView,
                                 forElementOfKind elementKind: String,
                                 at indexPath: IndexPath) {
        listSections[indexPath.section].header.cancelLoad()
    }
}

extension WorldCasesCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        return listSections[section].header.sizeFor(frameSize: view.bounds)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return listSections[section].header.insetForSection()
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return listSections[indexPath.section].list[indexPath.item].sizeForItemAt(parentViewSize: view.bounds)
    }
}

extension WorldCasesCollectionViewController: LoadingView {
    func isLoading(viewModel: LoadingViewModel) {
        if viewModel.isLoading {
            showLoader()
        } else {
            collectionView.refreshControl?.endRefreshing()
            removeLoader()
        }
    }
}

extension WorldCasesCollectionViewController: AlertView {
    func display(message: AlertViewModel) {
        showDefaultAlertOnMainThread(title: "Error!", message: message.description)
    }
}

struct WorldCasesViewListSection {
    let header: ChartHeaderCellController
    let list: [CountryCasesCellController]
}
