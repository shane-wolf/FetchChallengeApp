//
//  MealListCell.swift
//  FetchChallenge
//
//  Created by Shane Wolf on 7/30/24.
//

import SwiftUI

struct MealListCell: View {
    
    let meal: Meal
    
    var body: some View {
        HStack {
            ImageView(urlString: meal.strMealThumb)
                .aspectRatio(contentMode: .fit)
                .frame(width: 72, height: 72)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding()
            
            Text(meal.strMeal)
                .font(.title2)
                .fontWeight(.medium)
                .padding()
        }
    }
}

#Preview {
    MealListCell(meal: MockData.sampleMeal)
}
