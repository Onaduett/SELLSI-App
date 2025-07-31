//
//  ProductList.swift
//  Ecommerce
//
//  Created by Daulet Yerkinov on 31.07.25.
//

import SwiftUI

struct ProductListView: View {
    let products: [Product]
    var columns = [GridItem(.adaptive(minimum: 180), spacing: 20)]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(products) { product in
                    ProductCardView(product: product)
                }
            }
            .padding()
        }
    }
}
