//
//  CardSummary.swift
//  Ecommerce
//
//  Created by Daulet Yerkinov on 31.07.25.
//

import SwiftUI


struct CartSummaryView: View {
    @EnvironmentObject var cartManager: CartManager
    @EnvironmentObject var languageManager: LanguageManager // Added for localization
    @State private var showingCheckoutAlert = false
    
    var body: some View {
        VStack(spacing: 15) {
            Divider()
            
            HStack {
                Text("total_price_label".localized(languageManager)) // Localized
                    .font(.title2)
                    .bold()
                
                Spacer()
                
                Text(cartManager.formattedTotalPrice)
                    .font(.title2)
                    .bold()
                    .foregroundColor(.green)
            }
            .padding(.horizontal)
            
            Button("checkout_button_title".localized(languageManager)) { // Localized
                showingCheckoutAlert = true
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color.green, Color.blue]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .foregroundColor(.white)
            .cornerRadius(12)
            .padding(.horizontal)
            .alert("order_placed_alert_title".localized(languageManager), isPresented: $showingCheckoutAlert) { // Localized
                Button("ok".localized(languageManager)) { // Localized
                    cartManager.clearCart()
                }
            } message: {
                Text(String(format: languageManager.localizedString("order_placed_alert_message"), cartManager.formattedTotalPrice)) // Localized with format
            }
        }
        .padding(.bottom)
        .background(.ultraThinMaterial)
    }
}

