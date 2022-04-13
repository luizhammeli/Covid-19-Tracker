//
//  HttpClientSpy.swift
//  Covid-19 TrackerTests
//
//  Created by Luiz Diniz Hammerli on 12/04/22.
//  Copyright © 2022 Luiz Hammerli. All rights reserved.
//

import Foundation
@testable import Covid_19_Tracker

final class HttpClientSpy: HttpClient {
    var messages = [(url: URL, completion: (HttpClient.Result) -> Void)]()
    
    var urls: [URL] { messages.map { $0.url } }
    
    func get(from url: URL, completion: @escaping (HttpClient.Result) -> Void) {
        messages.append((url, completion))
    }
    
    func complete(with result: HttpClient.Result, at index: Int = 0) {
        messages[index].completion(result)
    }
}
