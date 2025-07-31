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
                Color(.systemGroupedBackground)
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
                    Button(action: {
                        Task {
                            await productService.fetchProducts()
                        }
                    }) {
                        Image(systemName: "arrow.clockwise")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.primary)
                    }
                }
            }
        }
        .task {
            await productService.fetchProducts()
        }
    }
}


