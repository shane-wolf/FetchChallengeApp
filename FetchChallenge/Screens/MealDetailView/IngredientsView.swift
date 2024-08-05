//
//  IngredientsView.swift
//  FetchChallenge
//
//  Created by Shane Wolf on 7/31/24.
//

import SwiftUI

struct IngredientsView: View {
    
    @Binding var isLoading: Bool
    
    var mealDetail: MealDetail?
    var progressViewYOffset: CGFloat
    var showError: Bool = false
    
    var body: some View {
        if let mealDetail {
            ForEach(mealDetail.ingredientsWithMeasurements) { item in
                IngredientCell(measurement: item.measurement, ingredient: item.ingredient)
            }
        }else if isLoading {
            ProgressView()
                .controlSize(.large)
                .offset(y: progressViewYOffset)
        } else if showError {
            ErrorView()
                .offset(y: progressViewYOffset - 80)
        }
    }
}

struct IngredientCell: View {
    
    @State private var checked: Bool = false
    
    var measurement: String
    var ingredient: String
    
    var body: some View {
        HStack() {
            Image(systemName: checked ? "checkmark.square.fill" : "square")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 20)
                .padding(.horizontal)
                .foregroundColor(checked ? Color(.systemBlue) : Color.secondary)
                .onTapGesture {
                    checked.toggle()
                }
            
            Text(measurement + " ").fontWeight(.bold) +
            Text(ingredient)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding([.top, .horizontal])
    }
}

#Preview {
    IngredientsView(isLoading: .constant(false),
                    mealDetail: MockData.sampleMealDetail,
                    progressViewYOffset: 0)
}
