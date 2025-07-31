//
//  ThemeAwareComponents.swift
//  Ecommerce
//
//  Created by v0 on 31.07.25.
//

import SwiftUI

// MARK: - Theme-Aware Loading View
struct ThemeAwareLoadingView: View {
    @EnvironmentObject var languageManager: LanguageManager
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(spacing: 20) {
            ProgressView()
                .scaleEffect(1.5)
                .tint(.blue)
            
            Text("loading".localized(languageManager))
                .font(.headline)
                .foregroundColor(AppTheme.primaryColor(for: colorScheme))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppTheme.backgroundColor(for: colorScheme))
    }
}

// MARK: - Theme-Aware Error View
struct ThemeAwareErrorView: View {
    let message: String
    let retryAction: () -> Void
    @EnvironmentObject var languageManager: LanguageManager
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 50))
                .foregroundColor(.orange)
            
            Text("error_title".localized(languageManager))
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(AppTheme.primaryColor(for: colorScheme))
            
            Text(message)
                .font(.body)
                .foregroundColor(AppTheme.secondaryColor(for: colorScheme))
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Button("retry_button".localized(languageManager)) {
                retryAction()
            }
            .padding(.horizontal, 30)
            .padding(.vertical, 12)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(25)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppTheme.backgroundColor(for: colorScheme))
    }
}

// MARK: - Theme-Aware Empty State View
struct ThemeAwareEmptyStateView: View {
    let retryAction: () -> Void
    @EnvironmentObject var languageManager: LanguageManager
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "tray.fill")
                .font(.system(size: 50))
                .foregroundColor(AppTheme.secondaryColor(for: colorScheme))
            
            Text("no_products_title".localized(languageManager))
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(AppTheme.primaryColor(for: colorScheme))
            
            Text("no_products_message".localized(languageManager))
                .font(.body)
                .foregroundColor(AppTheme.secondaryColor(for: colorScheme))
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Button("refresh_button".localized(languageManager)) {
                retryAction()
            }
            .padding(.horizontal, 30)
            .padding(.vertical, 12)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(25)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppTheme.backgroundColor(for: colorScheme))
    }
}
