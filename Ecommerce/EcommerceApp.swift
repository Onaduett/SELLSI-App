//
//  EcommerceApp.swift
//  Ecommerce
//
//  Created by Daulet Yerkinov on 31.07.25.
//

import SwiftUI

@main
struct EcommerceApp: App {
    @StateObject var languageManager = LanguageManager()

    var body: some Scene {
        WindowGroup {
            NavigationBar()
                .environmentObject(languageManager)
        }
    }
}
