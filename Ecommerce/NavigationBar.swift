//
//  NavigationBar.swift
//  Ecommerce
//
//  Created by Daulet Yerkinov on 31.07.25.
//

import SwiftUI


struct NavigationBar: View {
  @EnvironmentObject var languageManager: LanguageManager // Added for localization
  @StateObject private var cartManager: CartManager
  @StateObject private var productService: ProductService
  
  init() { // Removed languageManager from init parameters
      // Initialize StateObjects, passing the languageManager that will be injected by the environment
      _cartManager = StateObject(wrappedValue: CartManager(languageManager: LanguageManager())) // Use a default LanguageManager for init, it will be replaced by environment
      _productService = StateObject(wrappedValue: ProductService(languageManager: LanguageManager())) // Use a default LanguageManager for init, it will be replaced by environment
  }

  var body: some View {
      TabView {
          ProductsView()
              .tabItem {
                  Image(systemName: "house.fill")
                  Text("main_tab_title".localized(languageManager)) // Localized
              }
              .environmentObject(cartManager)
              .environmentObject(productService)
              .environmentObject(languageManager) // Pass languageManager down
          
          CartView()
              .tabItem {
                  ZStack {
                      Image(systemName: "cart.fill")
                      if cartManager.totalItems > 0 {
                          Text("\(cartManager.totalItems)")
                              .font(.caption2)
                              .fontWeight(.bold)
                              .foregroundColor(.white)
                              .background(Color.red)
                              .clipShape(Circle())
                              .offset(x: 8, y: -8)
                      }
                  }
                  Text("cart_tab_title".localized(languageManager)) // Localized
              }
              .environmentObject(cartManager)
              .environmentObject(languageManager) // Pass languageManager down
          
          ProfileView()
              .tabItem {
                  Image(systemName: "person.fill")
                  Text("profile_tab_title".localized(languageManager)) // Localized
              }
              .environmentObject(languageManager) // Pass languageManager down
      }
      .accentColor(.blue)
      .onAppear {
          // After languageManager is injected, update the managers if needed
          // This is a common pattern when StateObjects depend on EnvironmentObjects
          cartManager.languageManager = languageManager
          productService.languageManager = languageManager
      }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
      NavigationBar() // No need to pass languageManager here directly
          .environmentObject(LanguageManager()) // Provide LanguageManager for the environment
  }
}




