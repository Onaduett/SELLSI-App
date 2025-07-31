//
//  CardItem.swift
//  Ecommerce
//
//  Created by Daulet Yerkinov on 31.07.25.
//

import SwiftUI

struct CartItemView: View {
    let item: CartItem
    @EnvironmentObject var cartManager: CartManager
    @EnvironmentObject var languageManager: LanguageManager // Added for localization
    
    var body: some View {
        HStack(spacing: 15) {
            AsyncImage(url: URL(string: item.product.imageUrl ?? "")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.2))
                    .overlay(
                        Image(systemName: "photo")
                            .foregroundColor(.gray)
                    )
            }
            .frame(width: 80, height: 80)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(item.product.name)
                    .font(.headline)
                    .lineLimit(2)
                
                Text(String(format: languageManager.localizedString("price_format"), item.product.price)) // Localized price format
                    .font(.subheadline)
                    .foregroundColor(.green)
                    .bold()
                
                HStack {
                    Button {
                        cartManager.updateQuantity(item: item, quantity: item.quantity - 1)
                    } label: {
                        Image(systemName: "minus.circle.fill")
                            .foregroundColor(.red)
                    }
                    
                    Text("\(item.quantity)")
                        .font(.headline)
                        .frame(minWidth: 30)
                    
                    Button {
                        cartManager.updateQuantity(item: item, quantity: item.quantity + 1)
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.blue)
                    }
                }
            }
            
            Spacer()
            
            VStack {
                Text(String(format: languageManager.localizedString("price_format"), item.totalPrice)) // Localized price format
                    .font(.headline)
                    .bold()
                    .foregroundColor(.primary)
            }
        }
        .padding(.vertical, 8)
        .background(Color.white.opacity(0.8))
        .cornerRadius(12)
    }
}


