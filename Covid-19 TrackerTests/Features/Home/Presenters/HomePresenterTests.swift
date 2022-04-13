//
//  HomePresenterTests.swift
//  Covid-19 TrackerTests
//
//  Created by Luiz Diniz Hammerli on 12/04/22.
//  Copyright © 2022 Luiz Hammerli. All rights reserved.
//

import XCTest
@testable import Covid_19_Tracker

struct HomeViewModel {
    let header: CountryCasesHeaderViewModel
    let cases: [CountryCaseTypeViewModel]
}

struct LoadingViewModel {
    let isLoading: Bool
}

struct AlertViewModel {
    let description: String
}

protocol LoadingView {
    func isLoading(viewModel: LoadingViewModel)
}

protocol AlertView {
    func display(message: AlertViewModel)
}

protocol HomeView {
    func display(viewModel: HomeViewModel)
}

final class HomePresenter {
    private let loader: CountryCasesLoader
    private let loadingView: LoadingView
    private let homeView: HomeView
    private let alertView: AlertView
    
    init(loader: CountryCasesLoader, loadingView: LoadingView, homeView: HomeView, alertView: AlertView) {
        self.loader = loader
        self.loadingView = loadingView
        self.homeView = homeView
        self.alertView = alertView
    }
    
    func loadBrazilianCases() {
        loadingView.isLoading(viewModel: .init(isLoading: true))
        loader.load(completion: { [weak self] result in
            guard let self = self else { return }
            self.loadingView.isLoading(viewModel: .init(isLoading: false))
            switch result {
            case .success(let cases):
                let viewModel = self.toHomeViewModel(with: cases)
                self.homeView.display(viewModel: viewModel)
            case .failure(let message):
                self.alertView.display(message: .init(description: message.rawValue))
            }
        })
    }
    
    private func toHomeViewModel(with countryData: CountryCases) -> HomeViewModel {
        return HomeViewModel(header: CountryCasesViewModelMapper.toHeaderViewModel(countryData: countryData),
                             cases: CountryCasesViewModelMapper.toCaseTypeViewModel(countryData: countryData))
    }
}

final class HomePresenterTests: XCTestCase {
    func test_init_shouldNotLoadAnyCaseData() {
        let (_, spy) = makeSUT()
        
        XCTAssertTrue(spy.completions.isEmpty)
    }
    
    func test_didStartLoading_shouldReturnCorrectViewModelMessage() {
        let (sut, spy) = makeSUT()
        sut.loadBrazilianCases()
        
        XCTAssertEqual(spy.messages, [.load(isLoading: true)])
    }
    
    func test_didFinishLoadingWithSuccess_shouldReturnCorrectViewModelMessage() {
        let (sut, spy) = makeSUT()
        sut.loadBrazilianCases()
        
        spy.complete(with: .success(makeCountryCase()), at: 0)
        
        XCTAssertEqual(spy.messages, [.load(isLoading: true), .load(isLoading: false), .display])
    }
    
    func test_didFinishLoadingWithError_shouldReturnCorrectViewModelMessage() {
        let (sut, spy) = makeSUT()
        sut.loadBrazilianCases()
        
        spy.complete(with: .failure(.genericError), at: 0)
        
        XCTAssertEqual(spy.messages, [.load(isLoading: true), .load(isLoading: false), .alert(description: ErrorMessages.genericError.rawValue)])
    }
}

private extension HomePresenterTests {
    func makeSUT() -> (HomePresenter, LoadCountryCasesSpy) {
        let spy = LoadCountryCasesSpy()
        let sut = HomePresenter(loader: spy, loadingView: spy, homeView: spy, alertView: spy)
        trackForMemoryLeaks(instance: spy)
        trackForMemoryLeaks(instance: sut)
        return (sut, spy)
    }
}

final class LoadCountryCasesSpy: CountryCasesLoader, LoadingView, HomeView, AlertView {
    enum Messages: Equatable {
        case load(isLoading: Bool)
        case display
        case alert(description: String)
    }
    
    var completions = [(CountryCasesLoader.Result) -> Void]()
    var messages: [Messages] = []
    
    func load(completion: @escaping (CountryCasesLoader.Result) -> Void) {
        self.completions.append(completion)
    }
    
    func complete(with result: CountryCasesLoader.Result, at index: Int) {
        completions[index](result)
    }
    
    func isLoading(viewModel: LoadingViewModel) {
        messages.append(.load(isLoading: viewModel.isLoading))
    }
    
    func display(viewModel: HomeViewModel) {
        messages.append(.display)
    }
    
    func display(message: AlertViewModel) {
        messages.append(.alert(description: message.description))
    }
}
