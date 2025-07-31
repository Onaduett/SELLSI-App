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
                                Text("Загрузка...")
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
                        Text(product.formattedPrice)
                            .font(.title3)
                            .bold()
                            .foregroundColor(.green)
                        
                        Spacer()
                        
                        if let type = product.type {
                            Text(type.uppercased())
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
                    
                    Text(product.formattedDate)
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
            .alert("Товар добавлен", isPresented: $showingBuyAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Товар \"\(product.name)\" добавлен в корзину!")
            }
        }
        .scaleEffect(showingBuyAlert ? 0.95 : 1.0)
        .animation(.easeInOut(duration: 0.1), value: showingBuyAlert)
    }
}
