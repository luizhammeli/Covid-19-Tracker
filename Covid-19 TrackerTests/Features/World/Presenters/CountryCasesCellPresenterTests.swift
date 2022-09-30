//
//  CountryCasesCellPresenterTests.swift
//  Covid-19 TrackerTests
//
//  Created by Luiz Diniz Hammerli on 12/09/22.
//  Copyright © 2022 Luiz Hammerli. All rights reserved.
//

import XCTest

@testable import Covid_19_Tracker

final class CountryCasesCellPresenterTests: XCTestCase {
    func test_init_shouldNotMakeRequest() {
        let (_, spy, _) = makeSUT()
        
        XCTAssertTrue(spy.messages.isEmpty)
    }
    
    func test_load_shouldSendCorrectURL() {
        let (sut, spy, _) = makeSUT()
        let fakeURL = makeURL().description
        
        sut.loadImage(url: fakeURL)
        
        XCTAssertEqual(spy.urls, [fakeURL])
    }
    
    func test_load_shouldNotCompeteIfLoaderCompletesIfFailure() {
        let (sut, spy, viewSpy) = makeSUT()
        
        sut.loadImage(url: makeURL().description)
        spy.complete(with: .failure(.invalidData))
        
        XCTAssertTrue(viewSpy.receivedImages.isEmpty)
    }
    
    func test_load_shouldCompleteWithCorrectImageData() {
        let (sut, spy, viewSpy) = makeSUT()
        let fakeData = makeData()
        let fakeImage = FakeImage(data: fakeData)
        
        sut.loadImage(url: makeURL().description)
        spy.complete(with: .success(fakeData))
        
        XCTAssertEqual(viewSpy.receivedImages, [fakeImage])
    }
}

private extension CountryCasesCellPresenterTests {
    func makeSUT() -> (CountryCasesCellPresenter<ImageViewSpy, FakeImage>, ImageLoaderSpy, ImageViewSpy) {
        let viewSpy = ImageViewSpy()
        let spy = ImageLoaderSpy()
        let sut = CountryCasesCellPresenter(loader: spy, imageView: viewSpy, imageTransformer: FakeImage.init)
        
        return (sut, spy, viewSpy)
    }
}

final class ImageLoaderSpy: ImageLoader {
    var messages: [(url: String, completion: (ImageLoader.Result) -> Void)] = []
    var urls: [String] { messages.map { $0.url } }
    
    func load(url: String, completion: @escaping (ImageLoader.Result) -> Void) -> ImageLoaderTask? {
        messages.append((url, completion))
        return nil
    }
    
    func complete(with result: ImageLoader.Result, at index: Int = 0) {
        messages[index].completion(result)
    }
}

final class ImageViewSpy: ImageView {
    typealias Image = FakeImage
    var receivedImages: [Image?] = []
    
    func display(image: Image?) {
        if let image = image {
            receivedImages.append(image)
        }
    }
}

final class FakeImage: Equatable {
    let data: Data
    
    init(data: Data) {
        self.data = data
    }
    
    static func == (lhs: FakeImage, rhs: FakeImage) -> Bool {
        return lhs.data == rhs.data
    }
}
