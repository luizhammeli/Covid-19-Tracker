//
//  MainQueueDispatchDecorator.swift
//  Covid-19 Tracker
//
//  Created by Luiz Hammerli on 13/04/22.
//  Copyright © 2022 Luiz Hammerli. All rights reserved.
//

import Foundation

final class MainQueueDispatchDecorator<T> {
    let instance: T
    
    init(instance: T) {
        self.instance = instance
    }
    
    func dispatch(completion: @escaping () -> Void) {
        guard !Thread.isMainThread else { return completion() }
        
        DispatchQueue.main.async {
            completion()
        }
    }
}

extension MainQueueDispatchDecorator: CountryCasesLoader where T == CountryCasesLoader {
    func load(completion: @escaping (CountryCasesLoader.Result) -> Void) {
        instance.load { [weak self] result in
            self?.dispatch {
                completion(result)
            }
        }
    }
}
