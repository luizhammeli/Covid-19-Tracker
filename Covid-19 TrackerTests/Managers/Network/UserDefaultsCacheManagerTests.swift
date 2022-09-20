//
//  UserDefaultsCacheManagerTests.swift
//  Covid-19 TrackerTests
//
//  Created by Luiz Hammerli on 19/09/22.
//  Copyright © 2022 Luiz Hammerli. All rights reserved.
//

import XCTest

@testable import Covid_19_Tracker

final class UserDefaultsCacheManagerTests: XCTestCase {
    let key: String = "TestKey"
    
    override func setUp() {
        super.setUp()
        UserDefaults.standard.removeObject(forKey: key)
    }
    
    func test_save_shouldSaveDaTaCorrectly() {
        let fakeData = makeData()
        let sut = makeSUT()
        
        sut.save(key: key, data: fakeData)
        
        XCTAssertEqual(UserDefaults.standard.data(forKey: key), fakeData)
    }
    
    func test_fetch_shouldFetchDataCorrectly() {
        let fakeData = makeData()
        let sut = makeSUT()
        
        sut.save(key: key, data: fakeData)
        let fetchedFakeData = sut.fetch(key: key)
        
        XCTAssertEqual(fetchedFakeData, fakeData)
        XCTAssertEqual(UserDefaults.standard.data(forKey: key), fakeData)
    }
    
    func test_fetch_shouldReturnNilIfKeyNotExists() {
        let sut = makeSUT()
        let fetchedFakeData = sut.fetch(key: key)
        
        XCTAssertNil(fetchedFakeData)
        XCTAssertNil(UserDefaults.standard.data(forKey: key))
    }
    
    func test_delete_shouldDeleteDataCorrectly() {
        let fakeData = makeData()
        let sut = makeSUT()
        
        sut.save(key: key, data: fakeData)
        sut.delete(key: key)
        let fetchedFakeData = sut.fetch(key: key)
        
        XCTAssertNil(UserDefaults.standard.data(forKey: key))
        XCTAssertNil(fetchedFakeData)
    }
}

private extension UserDefaultsCacheManagerTests {
    func makeSUT() -> UserDefaultsCacheManager {
        return UserDefaultsCacheManager()
    }
}
