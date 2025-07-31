//
//  NavigationBar.swift
//  Ecommerce
//
//  Created by v0 on 31.07.25.
//

import SwiftUI

struct NavigationBar: View {
    @EnvironmentObject var languageManager: LanguageManager
    @StateObject private var themeManager = ThemeManager()
    @StateObject private var cartManager: CartManager
    @StateObject private var productService: ProductService
    
    init() {
        _cartManager = StateObject(wrappedValue: CartManager(languageManager: LanguageManager()))
        _productService = StateObject(wrappedValue: ProductService(languageManager: LanguageManager()))
    }

    var body: some View {
        TabView {
            ProductsView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("main_tab_title".localized(languageManager))
                }
                .environmentObject(cartManager)
                .environmentObject(productService)
                .environmentObject(languageManager)
                .environmentObject(themeManager)
            
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
                    Text("cart_tab_title".localized(languageManager))
                }
                .environmentObject(cartManager)
                .environmentObject(languageManager)
                .environmentObject(themeManager)
            
            ProfileView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("profile_tab_title".localized(languageManager))
                }
                .environmentObject(languageManager)
                .environmentObject(themeManager)
        }
        .accentColor(.blue)
        .onAppear {
            cartManager.languageManager = languageManager
            productService.languageManager = languageManager
        }
    }
}


struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
      NavigationBar()
          .environmentObject(LanguageManager())
  }
}




