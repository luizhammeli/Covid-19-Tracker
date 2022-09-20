//
//  UICollectionViewController+Ext.swift
//  ios-base-architecture
//
//  Created by Luiz on 12/04/20.
//  Copyright © 2020 Luiz Hammerli. All rights reserved.
//

import UIKit

extension UICollectionViewController {
    func reloadDataOnMainThread(completion: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            completion?()
        }
    }

    func endRefreshingOnMainThread(completion: (() -> Void)? = nil) {
        if Thread.isMainThread {
            self.collectionView.refreshControl?.endRefreshing()
        } else {
            DispatchQueue.main.async {
                self.collectionView.refreshControl?.endRefreshing()
                completion?()
            }
        }
    }
}
