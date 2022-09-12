//
//  ImageLoader.swift
//  Covid-19 Tracker
//
//  Created by Luiz Diniz Hammerli on 12/09/22.
//  Copyright © 2022 Luiz Hammerli. All rights reserved.
//

import Foundation

protocol ImageLoaderTask {
    func cancel()
}

protocol ImageLoader {
    typealias Result = Swift.Result<Data, ErrorMessages>

    @discardableResult
    func load(url: String, completion: @escaping (Result) -> Void) -> ImageLoaderTask?
}
