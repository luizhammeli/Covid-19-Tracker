//
//  WorldCasesPresenterTests.swift
//  Covid-19 TrackerTests
//
//  Created by Luiz Diniz Hammerli on 08/09/22.
//  Copyright © 2022 Luiz Hammerli. All rights reserved.
//

import XCTest

@testable import Covid_19_Tracker

final class WorldCasesPresenterTests: XCTestCase {
    func test_init_shouldNotLoadData() {
        let (_, spy, _) = makeSUT()
        
        XCTAssertTrue(spy.messages.isEmpty)
    }

    func test_loadCases_shouldCallAlertViewDelegateIfLoadFails() {
        let (sut, spy, viewSpy) = makeSUT()
        let expectedData: [AlertViewSpy.Messages] = [
            .loading(.init(isLoading: true)),
            .loading(.init(isLoading: false)),
            .alert(.init(description: "The data received from the server was invalid. Please try again."))
        ]
        
        sut.loadCases()
        spy.complete(with: .failure(.invalidData))
        
        XCTAssertEqual(viewSpy.messages, expectedData)
    }

    func test_loadCases_shouldDeliverDataIfLoadSucceedWithEmptyData() {
        let (sut, spy, viewSpy) = makeSUT()
        let expectedData: [AlertViewSpy.Messages] = [
            .loading(.init(isLoading: true)),
            .loading(.init(isLoading: false)),
            .view(.init(header: nil, items: []))
        ]
        
        sut.loadCases()
        spy.complete(with: .success(AllCases(worldCases: nil, countryCases: [])))
        
        XCTAssertEqual(viewSpy.messages, expectedData)
    }
    
    func test_loadCases_shouldDeliverDataIfLoadSucceedWithNonEmptyData() {
        let (sut, spy, viewSpy) = makeSUT()
        
        sut.loadCases()
        spy.complete(with: .success(AllCases(worldCases: makeWorldCases(), countryCases: [makeCountryCase().model])))
        
        guard case .view = viewSpy.messages.last else {
            XCTFail("Expected View message as last event instead got \(String(describing: viewSpy.messages.last))")
            return
        }
    }
    
    func test_loadCases_shouldNotCompleteIfInstanceHasBeenDealocated() {
        let useCaseSpy = LoadAllCasesSpy()
        let viewSpy = AlertViewSpy()
        var sut: WorldCasesPresenter? = WorldCasesPresenter(loader: useCaseSpy, alertView: viewSpy, worldCasesView: viewSpy, loadingView: viewSpy)
        
        sut?.loadCases()
        sut = nil
        useCaseSpy.complete(with: .success(makeAllCases()))
        
        XCTAssertEqual(viewSpy.messages, [.loading(.init(isLoading: true))])
    }
}

private extension WorldCasesPresenterTests {
    func makeSUT() -> (WorldCasesPresenter, LoadAllCasesSpy, AlertViewSpy) {
        let useCaseSpy = LoadAllCasesSpy()
        let alertViewSpy = AlertViewSpy()
        let sut = WorldCasesPresenter(loader: useCaseSpy, alertView: alertViewSpy, worldCasesView: alertViewSpy, loadingView: alertViewSpy)

        trackForMemoryLeaks(instance: useCaseSpy)
        trackForMemoryLeaks(instance: alertViewSpy)
        trackForMemoryLeaks(instance: sut)
        
        return (sut, useCaseSpy, alertViewSpy)
    }
}

final class AlertViewSpy: AlertView, WorldCasesView, LoadingView {
    var messages = [Messages]()
    
    enum Messages: Equatable {
        case alert(AlertViewModel)
        case view(WorldCasesViewModel)
        case loading(LoadingViewModel)
    }

    func display(message: AlertViewModel) {
        messages.append(.alert(message))
    }
    
    func display(viewModel: WorldCasesViewModel) {
        messages.append(.view(viewModel))
    }

    func isLoading(viewModel: LoadingViewModel) {
        messages.append(.loading(viewModel))
    }
}

final class LoadAllCasesSpy: WorldCasesWithCountriesLoader {
    var messages: [(WorldCasesWithCountriesLoader.Result) -> Void] = []

    func load(completion: @escaping (WorldCasesWithCountriesLoader.Result) -> Void) {
        messages.append(completion)
    }
    
    func complete(with result: WorldCasesWithCountriesLoader.Result, at index: Int = 0) {
        messages[index](result)
    }
}
