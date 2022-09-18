//
//  UserDefaultCacheManager.swift
//  Covid-19 Tracker
//
//  Created by Luiz Hammerli on 18/09/22.
//  Copyright © 2022 Luiz Hammerli. All rights reserved.
//

import Foundation

protocol CacheManager {
    func save(key: String, data: Data)
    func fetch(key: String) -> Data?
    func delete(key: String)
}

final class UserDefaultsCacheManager: CacheManager {
    let userDefaults: UserDefaults

    init(userDefaults: UserDefaults = UserDefaults.standard) {
        self.userDefaults = userDefaults
    }

    func save(key: String, data: Data) {        
        userDefaults.set(data, forKey: key)
    }
    
    func fetch(key: String) -> Data? {
        print("Fetching Cache for key: \(key)")
        return userDefaults.data(forKey: key)
    }
    
    func delete(key: String) {
        userDefaults.removeObject(forKey: key)
    }
}
