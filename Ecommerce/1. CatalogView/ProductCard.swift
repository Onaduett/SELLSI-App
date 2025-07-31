//
//  ProductCard.swift
//  Ecommerce
//
//  Created by Daulet Yerkinov on 31.07.25.
//

import SwiftUI

struct ProductCardView: View {
    let product: Product
    @EnvironmentObject var cartManager: CartManager
    @EnvironmentObject var languageManager: LanguageManager
    @State private var showingBuyAlert = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack(alignment: .topTrailing) {
                AsyncImage(url: URL(string: product.imageUrl ?? "")) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Rectangle()
                        .fill(Color(.systemGray6))
                        .overlay(
                            VStack(spacing: 8) {
                                Image(systemName: "photo")
                                    .font(.title2)
                                    .foregroundColor(.secondary)
                                Text("loading".localized(languageManager))
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        )
                }
                .frame(height: 140)
                .clipped()
                
                Button(action: {
                    cartManager.addToCart(product: product)
                    showingBuyAlert = true
                }) {
                    Image(systemName: "plus")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(width: 24, height: 24)
                        .background(Color.black)
                        .clipShape(Circle())
                }
                .padding(8)
            }
            
            // Content area
            VStack(alignment: .leading, spacing: 8) {
                // Product name
                Text(product.name)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.primary)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
                // Price and type
                HStack {
                    Text(String(format: languageManager.localizedString("price_format"), product.price))
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    if let type = product.type {
                        Text(type.uppercased())
                            .font(.system(size: 10, weight: .medium))
                            .foregroundColor(.secondary)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(Color(.systemGray6))
                            .clipShape(Capsule())
                    }
                }
                
                // Description
                if let description = product.description {
                    Text(description)
                        .font(.system(size: 13))
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                }
                
                // Date
                Text(product.createdAt.formattedDate(languageManager: languageManager))
                    .font(.system(size: 11))
                    .foregroundStyle(.tertiary)
            }
            .padding(12)
        }
        .frame(width: 170)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(.systemGray5), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.04), radius: 8, x: 0, y: 2)
        .alert("product_added".localized(languageManager), isPresented: $showingBuyAlert) {
            Button("ok".localized(languageManager), role: .cancel) { }
        } message: {
            Text(String(format: languageManager.localizedString("product_added_message"), product.name))
        }
        .scaleEffect(showingBuyAlert ? 0.98 : 1.0)
        .animation(.easeInOut(duration: 0.15), value: showingBuyAlert)
    }
}

