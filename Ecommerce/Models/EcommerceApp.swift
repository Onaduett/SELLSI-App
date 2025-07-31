//
//  EcommerceApp.swift
//  Ecommerce
//
//  Created by v0 on 31.07.25.
//

import SwiftUI

@main
struct EcommerceApp: App {
    @StateObject var languageManager = LanguageManager()
    @StateObject var themeManager = ThemeManager()

    var body: some Scene {
        WindowGroup {
            NavigationBar()
                .environmentObject(languageManager)
                .environmentObject(themeManager)
                .preferredColorScheme(themeManager.isDarkMode ? .dark : .light)
        }
    }
}

