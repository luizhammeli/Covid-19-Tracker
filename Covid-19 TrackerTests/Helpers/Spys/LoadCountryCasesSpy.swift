//
//  LoadCountryCasesSpy.swift
//  Covid-19 TrackerTests
//
//  Created by Luiz Hammerli on 16/04/22.
//  Copyright © 2022 Luiz Hammerli. All rights reserved.
//

@testable import Covid_19_Tracker

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
