//
//  NetworkManager.swift
//  FetchChallenge
//
//  Created by Shane Wolf on 7/30/24.
//

import Foundation
import UIKit

final class NetworkManager {
    
    static let shared = NetworkManager()
    private let cache = NSCache<NSString, UIImage>()
    
    private init() {}
    
    func getMeals() async throws -> [Meal]{
        
        guard let url = URL(string: "https://themealdb.com/api/json/v1/1/filter.php?c=Dessert") else {
            throw MealError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { throw MealError.invalidResponse }
        
        do {
            let jsonDecoder = JSONDecoder()
            return try jsonDecoder.decode(MealResponse.self, from: data).meals
                .compactMap { meal in
                    var meal = meal
                    meal.strMeal = meal.strMeal.capitalized
                    return meal
                }
                .sorted(by: { $0.strMeal < $1.strMeal })
        } catch {
            throw MealError.invalidData
        }
    }
    
    
    func getMealBy(id: Int) async throws -> MealDetail {
        
        guard let url = URL(string: "https://themealdb.com/api/json/v1/1/lookup.php?i=\(id)") else {
            throw MealError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw MealError.invalidResponse
        }
        
        do {
            let jsonDecoder = JSONDecoder()
            return try jsonDecoder.decode(MealDetailResponse.self, from: data).meals.first!
        } catch {
            throw MealError.invalidData
        }
    }
    
    
    func downloadImage(urlString: String) async throws -> UIImage {
        
        let cacheKey = NSString(string: urlString)
        
        if let image = cache.object(forKey: cacheKey){
            return image
        }
        
        
        guard let url = URL(string: urlString) else { throw MealError.invalidURL }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { throw MealError.invalidResponse }
        
        if let image = UIImage(data: data) {
            
            cache.setObject(image, forKey: cacheKey)
            
            return image
        }else {
            throw MealError.invalidData
        }
    }
}
