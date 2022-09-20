//
//  UICollectionViewController+ExtTests.swift
//  Covid-19 TrackerTests
//
//  Created by Luiz Diniz Hammerli on 20/09/22.
//  Copyright © 2022 Luiz Hammerli. All rights reserved.
//

import XCTest

@testable import Covid_19_Tracker

final class UICollectionViewControllerExtensionTests: XCTestCase {
    
    func test() {
        let sut = makeSUT()
        
        sut.collectionView.refreshControl?.beginRefreshing()
                
        sut.endRefreshingOnMainThread()
        
        XCTAssertFalse(sut.collectionView.refreshControl!.isRefreshing)
    }
    
    func test_() {
        let sut = makeSUT()
        
        sut.collectionView.refreshControl?.beginRefreshing()
        XCTAssertTrue(sut.collectionView.refreshControl!.isRefreshing)
        
        let exp = expectation(description: #function)
        DispatchQueue.global().async {
            sut.endRefreshingOnMainThread() {
                XCTAssertFalse(sut.collectionView.refreshControl!.isRefreshing)
                exp.fulfill()
            }
        }
        
        wait(for: [exp], timeout: 1)
    }
}

private extension UICollectionViewControllerExtensionTests {
    func makeSUT() -> CollectionViewControllerSpy {
        let sut = CollectionViewControllerSpy(collectionViewLayout: UICollectionViewFlowLayout())
        sut.collectionView.refreshControl = UIRefreshControl()
        
        return sut
    }
}

final class CollectionViewControllerSpy: UICollectionViewController {
    
}
