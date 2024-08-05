//
//  ErrorView.swift
//  FetchChallenge
//
//  Created by Shane Wolf on 8/5/24.
//

import SwiftUI

struct ErrorView: View {
    var body: some View {
        VStack {
            Image(systemName: "exclamationmark.circle")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 80)
            
            Text("Please try again later :)")
                .font(.title)
                .fontWeight(.semibold)
        }
    }
}

#Preview {
    ErrorView()
}
