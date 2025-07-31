//
//  EmptyCard.swift
//  Ecommerce
//
//  Created by Daulet Yerkinov on 31.07.25.
//

import SwiftUI


struct EmptyCartView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "cart")
                .font(.system(size: 60))
                .foregroundColor(.gray.opacity(0.7))
            
            Text("Корзина пуста")
                .font(.title)
                .bold()
                .foregroundColor(.primary)
            
            Text("Добавьте товары из каталога")
                .font(.body)
                .foregroundColor(.secondary)
        }
    }
}
