//
//  HttpError.swift
//  Covid-19 Tracker
//
//  Created by Luiz Diniz Hammerli on 08/04/22.
//  Copyright © 2022 Luiz Hammerli. All rights reserved.
//

import Foundation

public enum HttpError: Error {
    case noConnectivity
    case forbidden
    case unauthorized
    case serverError
    case badRequest
    case invalidData
}
