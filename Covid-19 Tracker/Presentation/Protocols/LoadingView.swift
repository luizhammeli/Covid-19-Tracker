//
//  LoadingView.swift
//  Covid-19 Tracker
//
//  Created by Luiz Diniz Hammerli on 13/04/22.
//  Copyright © 2022 Luiz Hammerli. All rights reserved.
//

import Foundation

protocol LoadingView {
    func isLoading(viewModel: LoadingViewModel)
}
