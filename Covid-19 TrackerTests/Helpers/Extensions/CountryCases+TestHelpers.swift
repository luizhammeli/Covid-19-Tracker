//
//  CountryCases+TestHelpers.swift
//  Covid-19 TrackerTests
//
//  Created by Luiz Diniz Hammerli on 12/04/22.
//  Copyright © 2022 Luiz Hammerli. All rights reserved.
//

import Foundation
@testable import Covid_19_Tracker

extension CountryCases {
    func toData() -> Data {
        return try! JSONEncoder().encode(self)
    }
}
