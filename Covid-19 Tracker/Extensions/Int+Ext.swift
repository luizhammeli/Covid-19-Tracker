//
//  Int+Formatter+Ext.swift
//  Covid-19 Tracker
//
//  Created by Luiz on 12/04/20.
//  Copyright © 2020 Luiz Hammerli. All rights reserved.
//

import Foundation

extension Int {

    func formatNumber()->String {
        let formater = NumberFormatter()
        formater.groupingSeparator = "."
        formater.numberStyle = .decimal
        guard let formattedNumber = formater.string(from: NSNumber(value: self)) else { return "0" }
        return formattedNumber
    }

}
