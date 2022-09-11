//
//  WorldCasesCollectionControllerUIIntegrationTests.swift
//  Covid-19 TrackerTests
//
//  Created by Luiz Hammerli on 10/09/22.
//  Copyright © 2022 Luiz Hammerli. All rights reserved.
//

import XCTest

@testable import Covid_19_Tracker

final class WorldCasesCollectionControllerUIIntegrationTests: XCTestCase {
    func test_viewDidLoad_shouldStartLoading() {
        let (sut, _) = makeSUT()
        
        XCTAssertTrue(sut.isLoading())
    }
    
    func test_loadData_shouldStopLoadingWhenDataRequestCompletesWithSuccess() {
        let (sut, spy) = makeSUT()
                
        spy.complete(with: .success(makeAllCases()))
        
        XCTAssertFalse(sut.isLoading())
        XCTAssertFalse(sut.isRefresing())
    }
    
    func test_loadData_shouldStopLoadingWhenDataRequestCompletesWithError() {
        let (sut, spy) = makeSUT()
                
        spy.complete(with: .failure(.genericError))
        
        XCTAssertFalse(sut.isLoading())
        XCTAssertFalse(sut.isRefresing())
    }
    
    func test_loadData_shouldShowAlertWhenDataRequestCompletesWithError() {
        let (sut, spy) = makeSUT()
                
        spy.complete(with: .failure(.invalidData))
        
        let alertData = sut.fetchAlertData()
        
        XCTAssertEqual(alertData?.title, "Error!")
        XCTAssertEqual(alertData?.message, "The data received from the server was invalid. Please try again.")
    }
    
    func test_loadData_shouldStartLoadingWhenRefresh() {
        let (sut, spy) = makeSUT()
        
        sut.loadViewIfNeeded()
        spy.complete(with: .failure(.invalidData))
        sut.simulateRefresh()
                
        XCTAssertTrue(sut.isLoading())
    }
    
    func test_loadData_shouldStartDataRequestWhenRefresh() {
        let (sut, spy) = makeSUT()
                
        spy.complete(with: .failure(.invalidData))
        sut.simulateRefresh()
                
        XCTAssertEqual(spy.messages.count, 2)
    }
    
    func test_setup_shouldSetCorrectTitle() {
        let (sut, _) = makeSUT()
                
        XCTAssertEqual(sut.controllerTitle, "Covid19")
    }
    
    func test_numberOfItems_shouldReturnCorrectValue() {
        let fakeCountryCase = [makeCountryCase().model, makeCountryCase().model]
        let (sut, spy) = makeSUT()
        
        spy.complete(with: .success(.init(worldCases: makeWorldCases(), countryCases: fakeCountryCase)))
                
        XCTAssertEqual(sut.collectionView.numberOfSections, 1)
        XCTAssertEqual(sut.numberOfItems(), 2)
    }
    
    func test_headerView_shouldReturnCorrectValue() {
        let fakeCountryCase = [makeCountryCase().model, makeCountryCase().model]
        let (sut, spy) = makeSUT()
        
        spy.complete(with: .success(.init(worldCases: makeWorldCases(), countryCases: fakeCountryCase)))
                
        XCTAssertNotNil(sut.header(at: IndexPath(row: 0, section: 0)))        
    }
}

private extension WorldCasesCollectionControllerUIIntegrationTests {
    func makeSUT(loadView: Bool = true) -> (WorldCasesCollectionViewController, LoadAllCasesSpy) {
        let loaderSpy = LoadAllCasesSpy()
        let controller = WorldCasesViewControllerFactory.makeWorldCasesViewControllerFactory(loader: loaderSpy)
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.makeKeyAndVisible()
        window.rootViewController = controller
        
        
        if loadView {
            controller.loadViewIfNeeded()
        }
        
        return (controller, loaderSpy)
    }
}

extension WorldCasesCollectionViewController {
    var controllerTitle: String? {
        navigationItem.title
    }
    
    func isLoading() -> Bool {
        guard let ac = view.subviews.last  as? UIActivityIndicatorView else { return false }
        return ac.isAnimating
    }
    
    func simulateRefresh() {
        collectionView.refreshControl?.simulatePullToRefresh()
    }
    
    func isRefresing() -> Bool {
        return collectionView.refreshControl?.isRefreshing ?? false
    }
    
    func fetchAlertData() -> (title: String?, message: String?)? {
        guard let alertController = presentedViewController as? UIAlertController else { return nil }
        
        return (title: alertController.title, message: alertController.message)
    }
    
    @discardableResult
    func cell(for indexPath: IndexPath) -> CountryCollectionViewCell? {
        return collectionView(collectionView, cellForItemAt: indexPath) as? CountryCollectionViewCell
    }
    
    func header(at indexPath: IndexPath) -> ChartHeaderCell? {
        cell(for: indexPath)
        return collectionView(collectionView,
                               viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader,
                               at: indexPath) as? ChartHeaderCell
    }
    
    func numberOfItems(section: Int = 0) -> Int {
        cell(for: IndexPath(row: 0, section: 0))
        return collectionView(collectionView, numberOfItemsInSection: 0)
    }
    
    func numberOfSection() -> Int {        
        return numberOfSections(in: collectionView)
    }
}

private extension UIRefreshControl {
    func simulatePullToRefresh() {
        allTargets.forEach { target in
            actions(forTarget: target, forControlEvent: .valueChanged)?.forEach { (target as NSObject).perform(Selector($0)) }
        }
    }
}
