//
//  InstructionsView.swift
//  FetchChallenge
//
//  Created by Shane Wolf on 7/31/24.
//

import SwiftUI

struct InstructionsView: View {
    
    @Binding var isLoading: Bool
    
    var instructions: String?
    var progressViewYOffset: CGFloat
    var showError: Bool = false
    
    var body: some View {
        if let instructions {
            Text(instructions
                .replacingOccurrences(of: "\r", with: "")
                .replacingOccurrences(of: "\n", with: "")
                .replacingOccurrences(of: ". ", with: ".")
                .replacingOccurrences(of: ".", with: ".\n\n"))
            .padding()
        } else if isLoading{
            ProgressView()
                .controlSize(.large)
                .offset(y: progressViewYOffset)
        } else if showError {
            ErrorView()
                .offset(y: progressViewYOffset - 80)
        }
    }
}

#Preview {
    InstructionsView(isLoading: .constant(false),
                     instructions: MockData.sampleMealDetail.strInstructions,
                     progressViewYOffset: 0)
}
