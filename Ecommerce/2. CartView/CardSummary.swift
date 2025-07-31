//
//  CardSummary.swift
//  Ecommerce
//
//  Created by Daulet Yerkinov on 31.07.25.
//

import SwiftUI


struct CartSummaryView: View {
    @EnvironmentObject var cartManager: CartManager
    @State private var showingCheckoutAlert = false
    
    var body: some View {
        VStack(spacing: 15) {
            Divider()
            
            HStack {
                Text("Итого:")
                    .font(.title2)
                    .bold()
                
                Spacer()
                
                Text(cartManager.formattedTotalPrice)
                    .font(.title2)
                    .bold()
                    .foregroundColor(.green)
            }
            .padding(.horizontal)
            
            Button("Оформить заказ") {
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
            .alert("Заказ оформлен!", isPresented: $showingCheckoutAlert) {
                Button("OK") {
                    cartManager.clearCart()
                }
            } message: {
                Text("Ваш заказ на сумму \(cartManager.formattedTotalPrice) успешно оформлен!")
            }
        }
        .padding(.bottom)
        .background(.ultraThinMaterial)
    }
}
