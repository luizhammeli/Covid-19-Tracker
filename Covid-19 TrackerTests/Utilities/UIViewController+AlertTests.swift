//
//  UIViewController+AlertTests.swift
//  Covid-19 TrackerTests
//
//  Created by Luiz Hammerli on 09/09/22.
//  Copyright © 2022 Luiz Hammerli. All rights reserved.
//

import XCTest

@testable import Covid_19_Tracker

final class UIViewControllerAlertTests: XCTestCase {
    func test_showDefaultAlertOnMainThread_shouldShowALertControllerWithCorrectData() {
        let sut = makeSUT()
        let fakeData: (title: String, message: String) = (title: "Test", message: "Message")
        
        sut.showDefaultAlertOnMainThread(title: fakeData.title, message: fakeData.message)
        
        guard let alertController = sut.presentedViewController as? UIAlertController else {
            XCTFail("Expected UIAlertController as Presented Controller instead got \(String(describing: sut.presentedViewController))")
            return
        }

        XCTAssertEqual(alertController.title, fakeData.title)
        XCTAssertEqual(alertController.message, fakeData.message)
    }
    
    func test_showDefaultAlertOnMainThread_shouldShowALertControllerInTheMainThread() {
        let sut = makeSUT()
        let fakeData: (title: String, message: String) = (title: "Test", message: "Message")
        var isMainThread = false
        
        let exp = expectation(description: #function)
        
        DispatchQueue.global().async {
            sut.showDefaultAlertOnMainThread(title: fakeData.title, message: fakeData.message) {
                isMainThread = Thread.isMainThread
                exp.fulfill()
            }
        }
        
        wait(for: [exp], timeout: 1)
        XCTAssertTrue(isMainThread)
    }
    
    func test_showLoader_shouldShowLoader() {
        let sut = makeSUT()

        sut.showLoader()
        
        guard let ac = sut.view.subviews.last as? UIActivityIndicatorView else {
            XCTFail("")
            return
        }

        XCTAssertTrue(ac.isAnimating)
    }
    
    func test_showLoader_shouldRemoveLoader() {
        let sut = makeSUT()

        sut.showLoader()
        sut.removeLoader()
        
        guard let _ = sut.view.subviews.last as? UIActivityIndicatorView else { return }
        
        XCTFail("Loader should be removed")
    }
    
    func test_showLoader_shouldRemoveLoaderInTheMainThread() {
        let sut = makeSUT()

        sut.showLoader()

        let exp = expectation(description: #function)

        DispatchQueue.global().async {
            sut.removeLoader {
                guard let _ = sut.view.subviews.last as? UIActivityIndicatorView else {
                    XCTAssertTrue(Thread.isMainThread)
                    exp.fulfill()
                    return
                }
                XCTFail("Loader should be removed")
            }
        }
        
        wait(for: [exp], timeout: 1)
    }
}

private extension UIViewControllerAlertTests {
    func makeSUT() -> UIViewController {
        let sut = UIViewController()
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.makeKeyAndVisible()
        window.rootViewController = sut
        
        return sut
    }
}
