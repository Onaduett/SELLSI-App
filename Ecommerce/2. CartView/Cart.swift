//
//  Cart.swift
//  Ecommerce
//
//  Created by Daulet Yerkinov on 31.07.25.
//

import SwiftUI

struct CartView: View {
    @EnvironmentObject var cartManager: CartManager
    @EnvironmentObject var languageManager: LanguageManager // Added for localization
    @State private var showingCheckoutAlert = false
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color.green.opacity(0.1), Color.blue.opacity(0.1)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                if cartManager.items.isEmpty {
                    EmptyCartView()
                        .environmentObject(languageManager) // Pass languageManager to EmptyCartView
                } else {
                    VStack {
                        List {
                            ForEach(cartManager.items) { item in
                                CartItemView(item: item)
                                    .environmentObject(languageManager) // Pass languageManager to CartItemView
                            }
                            .onDelete(perform: deleteItems)
                        }
                        .listStyle(PlainListStyle())
                        
                        CartSummaryView()
                            .environmentObject(languageManager) // Pass languageManager to CartSummaryView
                    }
                }
            }
            .navigationTitle("cart_tab_title".localized(languageManager)) // Localized
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                if !cartManager.items.isEmpty {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("clear_cart".localized(languageManager)) { // Localized
                            cartManager.clearCart()
                        }
                        .foregroundColor(.red)
                    }
                }
            }
        }
    }
    
    func deleteItems(offsets: IndexSet) {
        for index in offsets {
            cartManager.removeFromCart(item: cartManager.items[index])
        }
    }
}



