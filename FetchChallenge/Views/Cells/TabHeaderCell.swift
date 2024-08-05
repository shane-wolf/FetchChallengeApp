//
//  TabHeaderCell.swift
//  FetchChallenge
//
//  Created by Shane Wolf on 8/2/24.
//

import SwiftUI

struct TabHeaderCell : View {
    @Binding var currentTab: Int
    
    let name: String
    let tab: Int
    
    var body: some View {
        Text(name)
            .font(.title3)
            .fontWeight(.semibold)
            .foregroundStyle(tab == currentTab ? Color(.label) : .secondary)
            .onTapGesture {
                currentTab = tab
            }
    }
}

#Preview {
    TabHeaderCell(currentTab: .constant(0), name: "Ingredients", tab: 0)
}
