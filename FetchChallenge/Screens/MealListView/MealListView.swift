//
//  ContentView.swift
//  FetchChallenge
//
//  Created by Shane Wolf on 7/30/24.
//

import SwiftUI

struct MealListView: View {
    
    @StateObject private var mealListViewModel = MealListViewModel()
    
    @State var showError = false
    
    let navigationTitle: String
    
    var body: some View {
        ZStack {
            NavigationStack {
                List {
                    ForEach(mealListViewModel.meals) { meal in
                        NavigationLink(destination: MealDetailView(meal: meal)){
                            MealListCell(meal: meal)
                        }
                    }
                }
                .listStyle(.plain)
                .navigationTitle(navigationTitle)
            }
            
            if mealListViewModel.isLoading {
                ProgressView()
                    .controlSize(.large)
            }
            
            if showError {
                ErrorView()
            }
        }
        .task {
            mealListViewModel.getMeals()
        }
        .alert("Server Error", isPresented: $mealListViewModel.isAlertPresented) {
            Button("Okay", role: .cancel) {
                mealListViewModel.isAlertPresented = false
                showError = true
            }
        } message: {
            Text(mealListViewModel.errorMessage)
        }
    }
}

#Preview {
    MealListView(navigationTitle: "Desserts")
}
