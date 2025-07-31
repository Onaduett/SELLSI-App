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
    
    var formattedPrice: String {
        return String(format: "₽%.0f", price)
    }
    
    var formattedDate: String {
        let formatter = ISO8601DateFormatter()
        if let date = formatter.date(from: createdAt) {
            let displayFormatter = DateFormatter()
            displayFormatter.dateStyle = .medium
            displayFormatter.locale = Locale(identifier: "ru_RU")
            return displayFormatter.string(from: date)
        }
        return createdAt
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
    var name: String = "Пользователь"
    var email: String = "user@example.com"
    var phone: String = "+7 (XXX) XXX-XX-XX"
    var address: String = "Не указан"
}

// MARK: - Cart Manager
class CartManager: ObservableObject {
    @Published var items: [CartItem] = []
    
    var totalItems: Int {
        items.reduce(0) { $0 + $1.quantity }
    }
    
    var totalPrice: Double {
        items.reduce(0) { $0 + $1.totalPrice }
    }
    
    var formattedTotalPrice: String {
        return String(format: "₽%.0f", totalPrice)
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

// MARK: - API Service
class ProductService: ObservableObject {
    @Published var products: [Product] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let baseURL = "http://192.168.2.1:3000"
    
    func fetchProducts() async {
        await MainActor.run {
            isLoading = true
            errorMessage = nil
        }
        
        guard let url = URL(string: "\(baseURL)/api/products") else {
            await MainActor.run {
                isLoading = false
                errorMessage = "Неверный URL"
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
                self.errorMessage = "Ошибка загрузки: \(error.localizedDescription)"
            }
        }
    }
}


// MARK: - Products View (Main Page)


// MARK: - Product List View


// MARK: - Product Card View




// MARK: - Cart Item View


// MARK: - Cart Summary View


// MARK: - Empty Cart View


// MARK: - Profile View


// MARK: - Profile Info Row


// MARK: - Settings Row

// MARK: - Settings Action Row


// MARK: - Edit Profile View

// MARK: - Loading View



// MARK: - Preview
