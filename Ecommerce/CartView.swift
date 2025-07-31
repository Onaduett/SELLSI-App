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
                        .environmentObject(languageManager)
                } else {
                    VStack {
                        List {
                            ForEach(cartManager.items) { item in
                                CartItemView(item: item)
                                    .environmentObject(languageManager)
                            }
                            .onDelete(perform: deleteItems)
                        }
                        .listStyle(PlainListStyle())
                        
                        CartSummaryView()
                            .environmentObject(languageManager)
                    }
                }
            }
            .navigationTitle("cart_tab_title".localized(languageManager))
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                if !cartManager.items.isEmpty {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("clear_cart".localized(languageManager)) {
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



