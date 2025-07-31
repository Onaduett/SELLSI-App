//
//  ProductsView.swift
//  Ecommerce
//
//  Created by Daulet Yerkinov on 31.07.25.
//

import SwiftUI

struct ProductsView: View {
    @EnvironmentObject var productService: ProductService
    @EnvironmentObject var cartManager: CartManager
    @EnvironmentObject var languageManager: LanguageManager // Added for localization
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.1), Color.purple.opacity(0.1)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack {
                    if productService.isLoading {
                        LoadingView()
                            .environmentObject(languageManager) // Pass languageManager
                    } else if let errorMessage = productService.errorMessage {
                        ErrorView(message: errorMessage) {
                            Task {
                                await productService.fetchProducts()
                            }
                        }
                        .environmentObject(languageManager) // Pass languageManager
                    } else if productService.products.isEmpty {
                        EmptyStateView {
                            Task {
                                await productService.fetchProducts()
                            }
                        }
                        .environmentObject(languageManager) // Pass languageManager to EmptyStateView
                    } else {
                        ProductListView(products: productService.products)
                            .environmentObject(languageManager) // Pass languageManager to ProductListView
                    }
                }
            }
            .navigationTitle("shop_title".localized(languageManager)) // Localized
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("refresh".localized(languageManager)) { // Localized
                        Task {
                            await productService.fetchProducts()
                        }
                    }
                    .foregroundColor(.primary)
                }
            }
        }
        .task {
            await productService.fetchProducts()
        }
    }
}


