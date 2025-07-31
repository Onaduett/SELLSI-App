//
//  EmptyCard.swift
//  Ecommerce
//
//  Created by Daulet Yerkinov on 31.07.25.
//

import SwiftUI



struct EmptyCartView: View {
    @EnvironmentObject var languageManager: LanguageManager
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "cart")
                .font(.system(size: 60))
                .foregroundColor(.gray.opacity(0.7))
            
            Text("empty_cart".localized(languageManager))
                .font(.title)
                .bold()
                .foregroundColor(.primary)
            
            Text("add_products_from_catalogue".localized(languageManager))
                .font(.body)
                .foregroundColor(.secondary)
        }
    }
}
