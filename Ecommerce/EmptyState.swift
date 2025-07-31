//
//  EmptyState.swift
//  Ecommerce
//
//  Created by Daulet Yerkinov on 31.07.25.
//

import SwiftUI


struct EmptyStateView: View {
    let onRefresh: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "tray.fill")
                .font(.system(size: 50))
                .foregroundColor(.gray.opacity(0.7))
            
            Text("Нет товаров")
                .font(.title)
                .bold()
                .foregroundColor(.primary)
            
            Text("Пока нет доступных товаров.\nПопробуйте обновить список.")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            Button("Обновить") {
                onRefresh()
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue, Color.purple]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .foregroundColor(.white)
            .cornerRadius(10)
            .shadow(color: .blue.opacity(0.3), radius: 4, x: 0, y: 2)
        }
        .padding()
    }
}
