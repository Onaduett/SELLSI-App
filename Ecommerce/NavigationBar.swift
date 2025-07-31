//
//  NavigationBar.swift
//  Ecommerce
//
//  Created by Daulet Yerkinov on 31.07.25.
//

import SwiftUI


struct NavigationBar: View {
    @StateObject private var cartManager = CartManager()
    @StateObject private var productService = ProductService()
    
    var body: some View {
        TabView {
            ProductsView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Главная")
                }
                .environmentObject(cartManager)
                .environmentObject(productService)
            
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
                    Text("Корзина")
                }
                .environmentObject(cartManager)
            
            ProfileView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Профиль")
                }
        }
        .accentColor(.blue)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationBar()
    }
}
