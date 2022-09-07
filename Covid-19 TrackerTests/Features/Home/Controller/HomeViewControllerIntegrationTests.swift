//
//  HomeViewControllerIntegrationTests.swift
//  Covid-19 TrackerTests
//
//  Created by Luiz Hammerli on 16/04/22.
//  Copyright © 2022 Luiz Hammerli. All rights reserved.
//

import XCTest
@testable import Covid_19_Tracker

final class HomeViewControllerIntegrationTests: XCTestCase {
    func test_init_doesNotLoadData() {
        let (_, spy) = makeSUT(loadView: false)
        
        XCTAssertTrue(spy.completions.isEmpty)
    }
    
    func test_loadData_shouldNotRenderAnyCell() {
        let (sut, spy) = makeSUT()
        
        spy.complete(with: .failure(.invalidData), at: 0)
        
        XCTAssertEqual(sut.numberOfRenderedViews(), 0)
    }
    
    func test_refreshData_shouldShowAndHideLoaderCorrectly() {
        let (sut, spy) = makeSUT()
        
        XCTAssertFalse(sut.isRefreshing())
        
        sut.simulateRefreshing()
        
        XCTAssertTrue(sut.isRefreshing())
        
        spy.complete(with: .failure(.invalidData), at: 0)
        XCTAssertFalse(sut.isRefreshing())
    }
    
    func test_showLoader_shouldShowAndHideLoaderCorrectly() {
        let (sut, spy) = makeSUT()
        
        XCTAssertTrue(sut.isLoading())
        
        spy.complete(with: .failure(.invalidData), at: 0)
        
        XCTAssertFalse(sut.isLoading())
        XCTAssertFalse(sut.isRefreshing())
    }
    
    func test_loadData_shouldRenderCorrectNumberOfCells() {
        let (sut, spy) = makeSUT()
        
        XCTAssertEqual(sut.numberOfRenderedViews(), 0)
        
        spy.complete(with: .success(makeCountryCase().model), at: 0)
        
        XCTAssertEqual(sut.numberOfRenderedViews(), 6)
    }
    
    func test_loadData_shouldRenderFirstCellCorrectly() {
        let cases = makeCountryCase()
        let (sut, spy) = makeSUT()
        
        spy.complete(with: .success(cases.model), at: 0)
        
        let cell = sut.viewCell(at: IndexPath(item: 0, section: 0))
        
        XCTAssertEqual(cell.numberOfCases, cases.viewModel[0].count)
        XCTAssertEqual(cell.title, cases.viewModel[0].title)
        XCTAssertEqual(cell.backgroundColor, UIColor(named: cases.viewModel[0].color!))
    }
    
    func test_loadData_shouldRenderHeaderCellCorrectly() {
        let cases = makeCountryCase()
        let (sut, spy) = makeSUT()
        
        spy.complete(with: .success(cases.model), at: 0)
        
        let cell = sut.headerViewCell(at: IndexPath(item: 0, section: 0))
        
        XCTAssertEqual(cell.country, "Brazil")
        XCTAssertEqual(cell.totalCases, cases.header.strTotalCount)
        XCTAssertEqual(cell.activeCases, "Active \(cases.header.strActiveCount)")
        XCTAssertEqual(cell.recoveredCases, "Recovered \(cases.header.strRecoveredCount)")
    }
}

private extension HomeViewControllerIntegrationTests {
    func makeSUT(loadView: Bool = true) -> (HomeViewController, LoadCountryCasesSpy) {
        let spy = LoadCountryCasesSpy()
        let sut  = HomeControllerFactory.makeHomeController(loader: spy)
        
        if loadView { sut.loadViewIfNeeded() }
        
        return (sut, spy)
    }
}

extension HomeViewController {
    func numberOfRenderedViews(at section: Int = 0) -> Int {
        if collectionView.numberOfSections == 0 {
            return 0
        }
        return collectionView.numberOfItems(inSection: section)
    }
    
    @discardableResult
    func viewCell(at indexPath: IndexPath) -> TotalTypesCasesCell {
        let dataSource = collectionView.dataSource
        return dataSource?.collectionView(collectionView, cellForItemAt: indexPath) as! TotalTypesCasesCell
    }
    
    func headerViewCell(at indexPath: IndexPath) -> ChartHeaderCell {
        viewCell(at: indexPath)
        let dataSource = collectionView.dataSource
        return dataSource!.collectionView!(collectionView,
                                           viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader,
                                           at: indexPath) as! ChartHeaderCell
    }
    
    func isLoading() -> Bool {
        return (view.subviews.last is UIActivityIndicatorView)
    }
    
    func isRefreshing() -> Bool {
        return collectionView.refreshControl!.isRefreshing
    }
    
    func simulateRefreshing() {
        collectionView.refreshControl?.simulatePullToRefresh()
    }
}

extension TotalTypesCasesCell {
    var title: String {
        return typeLabel.text ?? ""
    }
    
    var numberOfCases: String {
        return countLabel.text ?? ""
    }
    
    var bgColor: UIColor? {
        return backgroundColor
    }
}

extension ChartHeaderCell {
    var country: String {
        countryLabel.text ?? ""
    }
    
    var totalCases: String {
        pieChart.centerText ?? ""
    }
    
    var activeCases: String? {
        guard let stackView = chartsDetailBar.subviews.first as? UIStackView,
              let activeCasesView = stackView.arrangedSubviews.first as? ChartsDetailView else { return nil }
        return "\(String(describing: activeCasesView.typeLabel.text ?? "")) \(activeCasesView.countLabel.text ?? "")"
    }
    
    var recoveredCases: String? {
        guard let stackView = chartsDetailBar.subviews.first as? UIStackView,
              let recoveredCasesView = stackView.arrangedSubviews[1] as? ChartsDetailView else { return nil }
        return "\(String(describing: recoveredCasesView.typeLabel.text ?? "")) \(recoveredCasesView.countLabel.text ?? "")"
    }
}

private extension UIRefreshControl {
    func simulatePullToRefresh() {
        allTargets.forEach { target in
            actions(forTarget: target, forControlEvent: .valueChanged)?.forEach {
                (target as NSObject).perform(Selector($0))
            }
        }
    }
}
