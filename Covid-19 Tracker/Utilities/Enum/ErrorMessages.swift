//
//  ErrorMessages.swift
//  Covid-19 Tracker
//
//  Created by Luiz on 11/04/20.
//  Copyright © 2020 Luiz Hammerli. All rights reserved.
//

import Foundation

enum ErrorMessages: String, Error, Equatable {
    case invalidUsername = "This username created a invalid request. Please try again."
    case unableToComplete = "Unable to complete your request. Please check your internet connection. "
    case invalidResponse = "Invalid response from the server. Please try again"
    case invalidData = "The data received from the server was invalid. Please try again."
    case titleError = "Bad Stuff Happend"
    case userExist = "This user has already been saved as Favorite. Try add another user. 😉"
    case genericError = "Error to processing your request. Please try again later."
    case invalidURL = "Invalid URL"
}
