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
    @EnvironmentObject var languageManager: LanguageManager
    
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
                            .environmentObject(languageManager)
                    } else if let errorMessage = productService.errorMessage {
                        ErrorView(message: errorMessage) {
                            Task {
                                await productService.fetchProducts()
                            }
                        }
                        .environmentObject(languageManager)
                    } else if productService.products.isEmpty {
                        EmptyStateView {
                            Task {
                                await productService.fetchProducts()
                            }
                        }
                        .environmentObject(languageManager)
                    } else {
                        ProductListView(products: productService.products)
                            .environmentObject(languageManager)
                    }
                }
            }
            .navigationTitle("shop_title".localized(languageManager))
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("refresh".localized(languageManager)) { 
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


