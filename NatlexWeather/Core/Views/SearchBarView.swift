//
//  SearchBarView.swift
//  NatlexWeather
//
//  Created by Nizami Tagiyev on 21.12.2022.
//

import SwiftUI

struct SearchBarView: View {
    
    @Binding var searchText: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
            TextField("City name", text: $searchText)
                .foregroundColor(.secondary)
        }
        .font(.headline)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(.secondary)
        )
    }
}
