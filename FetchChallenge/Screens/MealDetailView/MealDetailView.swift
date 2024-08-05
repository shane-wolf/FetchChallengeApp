//
//  MealDetailView.swift
//  FetchChallenge
//
//  Created by Shane Wolf on 7/30/24.
//

import SwiftUI

struct MealDetailView: View {
    
    @StateObject private var mealDetailViewModel = MealDetailViewModel()
    
    @State private var ingredientsContentYOffset: CGFloat = 0
    @State private var instructionsContentYOffset: CGFloat = 0
    @State private var contentXOffset: CGFloat = 0
    @State private var headerYOffset: CGFloat = 0
    @State private var currentTab = 0
    @State private var showError = false
    
    var meal: Meal
    private let scrollViewTopPaddingHeight: CGFloat = 270
    
    var body: some View {
        GeometryReader { geo in
            
            let progressViewYOffset = (geo.size.height - scrollViewTopPaddingHeight - 100) / 2
            
            ZStack {
                Color(.systemBackground).ignoresSafeArea() // This line, with the ZStack above is needed due to a potential OS bug with how ScrollViews behave in a paged TabView
                
                TabView(selection: $currentTab) {
                    
                    // MARK: - Ingredients Page ScrollView
                    ScrollView {
                        VStack {
                            Color(.systemBackground).frame(height: scrollViewTopPaddingHeight)
                            
                            IngredientsView(isLoading: $mealDetailViewModel.isLoading,
                                            mealDetail: mealDetailViewModel.mealDetail,
                                            progressViewYOffset: progressViewYOffset,
                                            showError: showError)
                        }
                        .padding(.bottom, 50)
                        .background(GeometryReader { geo in
                            Color.clear
                                .onChange(of: geo.bounds(of: .scrollView)!.minY) { oldValue, newValue in
                                    ingredientsContentYOffset = -newValue
                                    headerYOffset = ingredientsContentYOffset
                                }
                        })
                    }
                    .tag(0)
                    // This GeometryReader handles the TabViews horizontal scrolling
                    .background(GeometryReader { geo in
                        Color.clear
                            .onChange(of: geo.frame(in: .global).minX) { oldValue, newValue in
                                contentXOffset = newValue
                                
                                let ratio = abs(newValue) / geo.size.width
                                
                                if newValue <= 0 {
                                    headerYOffset = linearInterpolation(value1: ingredientsContentYOffset,
                                                                        value2: instructionsContentYOffset,
                                                                        ratio: ratio)
                                }
                            }
                    })
                    
                    
                    // MARK: - Instructions Page ScrollView
                    ScrollView {
                        VStack {
                            Color(.systemBackground).frame(height: scrollViewTopPaddingHeight)
                            
                            InstructionsView(isLoading: $mealDetailViewModel.isLoading,
                                             instructions: mealDetailViewModel.mealDetail?.strInstructions,
                                             progressViewYOffset: progressViewYOffset,
                                             showError: showError)
                        }
                        .padding(.bottom, 50)
                        .background(GeometryReader { geo in
                            Color.clear
                                .onChange(of: geo.bounds(of: .scrollView)!.minY) { oldValue, newValue in
                                    instructionsContentYOffset = -newValue
                                    headerYOffset = instructionsContentYOffset
                                }
                        })
                    }
                    .tag(1)
                }
                .animation(.easeOut, value: currentTab)
                .ignoresSafeArea()
                .navigationTitle(meal.strMeal)
                .navigationBarTitleDisplayMode(.inline)
                .scrollIndicators(.never)
                .tabViewStyle(.page(indexDisplayMode: .never))
                .overlay(alignment: .top) {
                    // MARK: - Meal Detail View Header
                    VStack() {
                        ImageView(urlString: meal.strMealThumb)
                            .frame(height: 200)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .padding()
                        
                        HStack(spacing: 0) {
                            TabHeaderCell(currentTab: $currentTab, name: "Ingredients", tab: 0)
                                .frame(width: UIScreen.main.bounds.width / 2)
                            
                            TabHeaderCell(currentTab: $currentTab, name: "Instructions", tab: 1)
                                .frame(width: UIScreen.main.bounds.width / 2)
                        }
                        
                        Color(.label)
                            .frame(width: UIScreen.main.bounds.width / 2, height: 2)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .offset(x: contentXOffset > 0 ? 0 : -contentXOffset / 2)
                        
                    }
                    .background(Color(.systemBackground))
                    .offset(y: headerYOffset)
                }
            }
            .task {
                mealDetailViewModel.getMealBy(id: meal.id)
            }
            .alert("Server Error", isPresented: $mealDetailViewModel.isAlertPresented) {
                Button("Okay", role: .cancel) { 
                    mealDetailViewModel.isAlertPresented = false
                    showError = true
                }
            } message: {
                Text(mealDetailViewModel.errorMessage)
            }
            
        }
    }
    
    func linearInterpolation(value1: CGFloat, value2: CGFloat, ratio: CGFloat) -> CGFloat{
        value1 + (value2 - value1) * abs(ratio)
    }
}

#Preview {
    MealDetailView(meal: MockData.sampleMeal)
}
