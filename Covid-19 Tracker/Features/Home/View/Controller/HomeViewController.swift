//
//  ViewController.swift
//  Covid-19 Tracker
//
//  Created by Luiz on 10/04/20.
//  Copyright © 2020 Luiz Hammerli. All rights reserved.
//

import UIKit

class HomeViewController: UICollectionViewController {
    var listModel: HomeViewModel? { didSet { collectionView.reloadData() } }
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

    func registerCells() {
        collectionView.register(ChartHeaderCell.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: ChartHeaderCell.cellID)
        collectionView.register(TotalTypesCasesCell.self, forCellWithReuseIdentifier: TotalTypesCasesCell.cellID)
    }

    func setupLayout() {
        collectionView.backgroundColor = UIColor(named: Colors.background)         
        navigationItem.title = Labels.covid19
        collectionView.contentInset = UIEdgeInsets(top: 15, left: 12, bottom: 30, right: 12)
    }

    func setupRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .lightGray
        //refreshControl.addTarget(self, action: #selector(getData), for: UIControl.Event.valueChanged)
        collectionView.refreshControl =  refreshControl
    }
}

extension HomeViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listModel?.cases.count ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 viewForSupplementaryElementOfKind kind: String,
                                 at indexPath: IndexPath) -> UICollectionReusableView {
        let cell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                                                   withReuseIdentifier: ChartHeaderCell.cellID,
                                                                   for: indexPath) as! ChartHeaderCell
        if let model = listModel?.header {
            cell.setupChartView(viewModelItem: model, country: Labels.brazil)
        }
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TotalTypesCasesCell.cellID, for: indexPath) as! TotalTypesCasesCell
        if let model = listModel?.cases[indexPath.item] {
            cell.set(viewModelItem: model)
        }
        return cell
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        let size = view.bounds.width-24
        return CGSize(width: size, height: size-20)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 24, left: 3, bottom: 0, right: 3)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.bounds.width-40) / 2
        return CGSize(width: width, height: width/1.9)
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
            removeLoader()
        }
    }
}

extension HomeViewController: HomeView {
    func display(viewModel: HomeViewModel) {
        self.listModel = viewModel
    }
}
