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
    @EnvironmentObject var languageManager: LanguageManager // Added for localization
    @State private var showingBuyAlert = false
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            ZStack(alignment: .bottom) {
                AsyncImage(url: URL(string: product.imageUrl ?? "")) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.gray.opacity(0.2))
                        .overlay(
                            VStack {
                                Image(systemName: "photo")
                                    .font(.title)
                                    .foregroundColor(.gray)
                                Text("loading".localized(languageManager)) // Localized
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        )
                }
                .frame(width: 180, height: 200)
                .clipped()
                .cornerRadius(20)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(product.name)
                        .font(.headline)
                        .bold()
                        .foregroundColor(.primary)
                        .lineLimit(1)
                    
                    HStack {
                        Text(String(format: languageManager.localizedString("price_format"), product.price)) // Localized price format
                            .font(.title3)
                            .bold()
                            .foregroundColor(.green)
                        
                        Spacer()
                        
                        if let type = product.type {
                            Text(type.uppercased()) // Product type might need localization if it's a fixed set of categories
                                .font(.caption2)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Color.blue.opacity(0.2))
                                .foregroundColor(.blue)
                                .cornerRadius(4)
                        }
                    }
                    
                    if let description = product.description {
                        Text(description)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .lineLimit(2)
                    }
                    
                    Text(product.createdAt.formattedDate(languageManager: languageManager)) // Localized date format
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                .padding()
                .frame(width: 180, alignment: .leading)
                .background(.ultraThinMaterial)
                .cornerRadius(20)
            }
            .frame(width: 180, height: 280)
            .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
            
            Button(action: {
                cartManager.addToCart(product: product)
                showingBuyAlert = true
            }) {
                Image(systemName: "cart.badge.plus")
                    .font(.system(size: 16, weight: .bold))
                    .padding(12)
                    .foregroundColor(.white)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.blue, Color.purple]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .cornerRadius(25)
                    .shadow(color: .blue.opacity(0.3), radius: 4, x: 0, y: 2)
            }
            .padding()
            .alert("product_added".localized(languageManager), isPresented: $showingBuyAlert) { // Localized
                Button("ok".localized(languageManager), role: .cancel) { } // Localized
            } message: {
                Text(String(format: languageManager.localizedString("product_added_message"), product.name)) // Localized with format
            }
        }
        .scaleEffect(showingBuyAlert ? 0.95 : 1.0)
        .animation(.easeInOut(duration: 0.1), value: showingBuyAlert)
    }
}


