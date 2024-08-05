//
//  DessertListViewModel.swift
//  FetchChallenge
//
//  Created by Shane Wolf on 7/30/24.
//

import Foundation

@MainActor final class MealListViewModel: ObservableObject {
    
    @Published var meals: [Meal] = []
    @Published var isLoading = false
    @Published var errorMessage: String = "There was an error, please try again later."
    @Published var isAlertPresented = false
    
    func getMeals() {
        isLoading = true
        
        Task {
            do {
                meals = try await NetworkManager.shared.getMeals()
            } catch {
                if let mealError = error as? MealError {
                    errorMessage = mealError.rawValue
                }
                else {
                    errorMessage = MealError.unknown.rawValue
                }
                
                isAlertPresented = true
            }
            
            isLoading = false
        }
    }
}
