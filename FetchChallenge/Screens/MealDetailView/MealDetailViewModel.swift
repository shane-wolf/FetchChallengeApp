//
//  MealDetailViewModel.swift
//  FetchChallenge
//
//  Created by Shane Wolf on 8/4/24.
//

import Foundation

@MainActor class MealDetailViewModel: ObservableObject {
    
    @Published var mealDetail: MealDetail?
    @Published var isLoading = false
    @Published var errorMessage: String = "There was an error, please try again later."
    @Published var isAlertPresented = false
    
    func getMealBy(id: Int) {
        isLoading = true
        
        Task {
            do {
                mealDetail = try await NetworkManager.shared.getMealBy(id: id)
            } catch {
                if let mealError = error as? MealError {
                    errorMessage = mealError.rawValue
                } else {
                    errorMessage = MealError.unknown.rawValue
                }
                
                isAlertPresented = true
            }
            
            isLoading = false
        }
    }
}
