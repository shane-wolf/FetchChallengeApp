//
//  MealError.swift
//  FetchChallenge
//
//  Created by Shane Wolf on 7/30/24.
//

import Foundation

enum MealError: String, Error {
    case invalidURL         = "A connection to the server could not be established. Please try again later."
    case invalidResponse    = "Invalid response from the server. Please check your internet connection or try again later."
    case invalidData        = "The data received from the server was invalid. Please try again later."
    case unknown            = "There was an unknown error. Please try again later."
}
