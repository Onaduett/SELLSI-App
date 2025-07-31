//
//  ErrorView.swift
//  Ecommerce
//
//  Created by Daulet Yerkinov on 31.07.25.
//

import SwiftUI


struct ErrorView: View {
    let message: String
    let onRetry: () -> Void
    @EnvironmentObject var languageManager: LanguageManager // Added for localization
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 50))
                .foregroundColor(.red)
            
            Text("error".localized(languageManager)) // Localized
                .font(.title)
                .bold()
                .foregroundColor(.primary)
            
            Text(message) // This message is already localized by ProductService
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Button("try_again".localized(languageManager)) { // Localized
                onRetry()
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

