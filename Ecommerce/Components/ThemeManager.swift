//
//  ThemeManager.swift
//  Ecommerce
//
//  Created by Daulet Yerkinov on 31.07.25.
//

import SwiftUI
import Combine

// MARK: - Theme Manager
class ThemeManager: ObservableObject {
    @Published var isDarkMode: Bool {
        didSet {
            UserDefaults.standard.set(isDarkMode, forKey: "isDarkMode")
            updateAppearance()
        }
    }
    
    init() {
        // Load saved theme preference or default to system setting
        self.isDarkMode = UserDefaults.standard.object(forKey: "isDarkMode") as? Bool ?? false
        updateAppearance()
    }
    
    private func updateAppearance() {
        DispatchQueue.main.async {
            // Get all windows and update their appearance
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                for window in windowScene.windows {
                    window.overrideUserInterfaceStyle = self.isDarkMode ? .dark : .light
                }
            }
        }
    }
    
    func toggleTheme() {
        withAnimation(.easeInOut(duration: 0.3)) {
            isDarkMode.toggle()
        }
    }
}

// MARK: - Theme Colors
struct AppTheme {
    static func backgroundColor(for colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? Color.black : Color.white
    }
    
    static func primaryColor(for colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? Color.white : Color.black
    }
    
    static func secondaryColor(for colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? Color.gray : Color.secondary
    }
    
    static func cardBackground(for colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? Color(.systemGray6) : Color(.systemBackground)
    }
    
    static func gradientColors(for colorScheme: ColorScheme) -> [Color] {
        if colorScheme == .dark {
            return [Color.purple.opacity(0.3), Color.blue.opacity(0.3)]
        } else {
            return [Color.purple.opacity(0.1), Color.pink.opacity(0.1)]
        }
    }
}
