//
//  ProductList.swift
//  Ecommerce
//
//  Created by Daulet Yerkinov on 31.07.25.
//

import SwiftUI

struct ProductListView: View {
    let products: [Product]
    @EnvironmentObject var languageManager: LanguageManager
    
    private var columns: [GridItem] {
        [
            GridItem(.fixed(170), spacing: 10),
            GridItem(.fixed(170), spacing: 10)
        ]
    }
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(products) { product in
                    ProductCardView(product: product)
                        .environmentObject(languageManager)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
        }
        .scrollIndicators(.hidden)
    }
}
