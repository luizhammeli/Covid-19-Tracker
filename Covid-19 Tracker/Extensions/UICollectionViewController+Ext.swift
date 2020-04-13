//
//  UICollectionViewController+Ext.swift
//  ios-base-architecture
//
//  Created by Luiz on 12/04/20.
//  Copyright © 2020 Luiz Hammerli. All rights reserved.
//

import UIKit

extension UICollectionViewController {
    func reloadDataOnMainThread() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }

    func endRefreshingOnMainThread() {
        DispatchQueue.main.async {
            self.collectionView.refreshControl?.endRefreshing()
        }
    }
}
