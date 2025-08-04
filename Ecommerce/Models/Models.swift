//
//  SellSi.swift
//  Ecommerce
//
//  Created by Daulet Yerkinov on 31.07.25.
//

import SwiftUI

// MARK: - Models
struct Product: Codable, Identifiable {
    let id: String
    let name: String
    let description: String?
    let price: Double
    let type: String?
    let imageUrl: String?
    let createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, description, price, type
        case imageUrl = "image_url"
        case createdAt = "created_at"
    }
}

struct CartItem: Identifiable {
    let id = UUID()
    let product: Product
    var quantity: Int
    
    var totalPrice: Double {
        return product.price * Double(quantity)
    }
}

struct UserProfile {
    var name: String
    var email: String
    var phone: String
    var address: String

    init(name: String, email: String, phone: String, address: String) {
        self.name = name
        self.email = email
        self.phone = phone
        self.address = address
    }
}

// MARK: - Cart Manager
class CartManager: ObservableObject {
    @Published var items: [CartItem] = []
    var languageManager: LanguageManager // Dependency injection

    init(languageManager: LanguageManager) {
        self.languageManager = languageManager
    }
    
    var totalItems: Int {
        items.reduce(0) { $0 + $1.quantity }
    }
    
    var totalPrice: Double {
        items.reduce(0) { $0 + $1.totalPrice }
    }
    
    var formattedTotalPrice: String {
        return String(format: languageManager.localizedString("price_format"), totalPrice)
    }
    
    func addToCart(product: Product) {
        if let index = items.firstIndex(where: { $0.product.id == product.id }) {
            items[index].quantity += 1
        } else {
            items.append(CartItem(product: product, quantity: 1))
        }
    }
    
    func removeFromCart(item: CartItem) {
        items.removeAll { $0.id == item.id }
    }
    
    func updateQuantity(item: CartItem, quantity: Int) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            if quantity > 0 {
                items[index].quantity = quantity
            } else {
                items.remove(at: index)
            }
        }
    }
    
    func clearCart() {
        items.removeAll()
    }
}

class ProductService: ObservableObject {
    @Published var products: [Product] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let baseURL = "http://192.168.2.1:3000"
    var languageManager: LanguageManager // Dependency injection

    init(languageManager: LanguageManager) {
        self.languageManager = languageManager
    }
    
    func fetchProducts() async {
        await MainActor.run {
            isLoading = true
            errorMessage = nil
        }
        
        guard let url = URL(string: "\(baseURL)/api/products") else {
            await MainActor.run {
                isLoading = false
                errorMessage = languageManager.localizedString("invalid_url") // Localized
            }
            return
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw URLError(.badServerResponse)
            }
            
            guard httpResponse.statusCode == 200 else {
                throw URLError(.badServerResponse)
            }
            
            let decoder = JSONDecoder()
            let fetchedProducts = try decoder.decode([Product].self, from: data)
            
            await MainActor.run {
                self.products = fetchedProducts
                self.isLoading = false
            }
            
        } catch {
            await MainActor.run {
                self.isLoading = false
                self.errorMessage = String(format: languageManager.localizedString("loading_error"), error.localizedDescription) // Localized
            }
        }
    }
}

extension String {
    func formattedDate(languageManager: LanguageManager) -> String {
        let formatter = ISO8601DateFormatter()
        if let date = formatter.date(from: self) {
            let displayFormatter = DateFormatter()
            displayFormatter.dateStyle = .medium
            displayFormatter.locale = languageManager.currentLocale // Use localized locale
            return displayFormatter.string(from: date)
        }
        return self
    }
}

