//
//  ContentView.swift
//  Ecommerce
//
//  Created by Daulet Yerkinov on 31.07.25.
//

import SwiftUI
import Foundation

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
    
    // Форматированная цена
    var formattedPrice: String {
        return String(format: "₽%.2f", price)
    }
    
    // Форматированная дата
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

// MARK: - API Service
class ProductService: ObservableObject {
    @Published var products: [Product] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    // Ваш локальный сервер
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


// MARK: - Content View
struct ContentView: View {
    @StateObject private var productService = ProductService()
    
    var body: some View {
        NavigationView {
            ZStack {
                // Градиентный фон
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.8), Color.purple.opacity(0.8)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack {
                    if productService.isLoading {
                        LoadingView()
                    } else if let errorMessage = productService.errorMessage {
                        ErrorView(message: errorMessage) {
                            Task {
                                await productService.fetchProducts()
                            }
                        }
                    } else if productService.products.isEmpty {
                        EmptyStateView {
                            Task {
                                await productService.fetchProducts()
                            }
                        }
                    } else {
                        ProductListView(products: productService.products)
                    }
                }
            }
            .navigationTitle("🛍️ Магазин")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Обновить") {
                        Task {
                            await productService.fetchProducts()
                        }
                    }
                    .foregroundColor(.white)
                }
            }
        }
        .task {
            await productService.fetchProducts()
        }
    }
}

// MARK: - Product List View
struct ProductListView: View {
    let products: [Product]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 16),
                GridItem(.flexible(), spacing: 16)
            ], spacing: 16) {
                ForEach(products) { product in
                    ProductCardView(product: product)
                }
            }
            .padding(.horizontal, 16)
        }
    }
}

// MARK: - Product Card View
struct ProductCardView: View {
    let product: Product
    @State private var showingBuyAlert = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Изображение товара
            AsyncImage(url: URL(string: product.imageUrl ?? "")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.3))
                    .overlay(
                        Image(systemName: "photo")
                            .foregroundColor(.gray)
                            .font(.title)
                    )
            }
            .frame(height: 120)
            .clipped()
            .cornerRadius(12)
            
            VStack(alignment: .leading, spacing: 8) {
                // Название товара
                Text(product.name)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .lineLimit(2)
                
                // Категория
                if let type = product.type {
                    Text(type.uppercased())
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.blue.opacity(0.2))
                        .foregroundColor(.blue)
                        .cornerRadius(8)
                }
                
                // Описание
                if let description = product.description {
                    Text(description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(3)
                }
                
                Spacer()
                
                // Цена и дата
                VStack(alignment: .leading, spacing: 4) {
                    Text(product.formattedPrice)
                        .font(.title2)
                        .bold()
                        .foregroundColor(.green)
                    
                    Text(product.formattedDate)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
            
            // Кнопка купить
            Button(action: {
                showingBuyAlert = true
            }) {
                HStack {
                    Image(systemName: "cart.badge.plus")
                    Text("Купить")
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
        }
        .padding()
        .background(Color(.systemBackground).opacity(0.9))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
        .alert("Товар добавлен", isPresented: $showingBuyAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Товар \"\(product.name)\" добавлен в корзину!")
        }
    }
}

// MARK: - Loading View
struct LoadingView: View {
    var body: some View {
        VStack(spacing: 20) {
            ProgressView()
                .scaleEffect(1.5)
                .tint(.white)
            
            Text("Загружаем товары...")
                .font(.headline)
                .foregroundColor(.white)
        }
    }
}

// MARK: - Error View
struct ErrorView: View {
    let message: String
    let onRetry: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 50))
                .foregroundColor(.red)
            
            Text("Ошибка")
                .font(.title)
                .bold()
                .foregroundColor(.white)
            
            Text(message)
                .font(.body)
                .foregroundColor(.white.opacity(0.8))
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Button("Попробовать снова") {
                onRetry()
            }
            .padding()
            .background(Color.white.opacity(0.2))
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding()
    }
}

// MARK: - Empty State View
struct EmptyStateView: View {
    let onRefresh: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "tray")
                .font(.system(size: 50))
                .foregroundColor(.white.opacity(0.7))
            
            Text("Нет товаров")
                .font(.title)
                .bold()
                .foregroundColor(.white)
            
            Text("Пока нет доступных товаров.\nПопробуйте обновить список.")
                .font(.body)
                .foregroundColor(.white.opacity(0.8))
                .multilineTextAlignment(.center)
            
            Button("Обновить") {
                onRefresh()
            }
            .padding()
            .background(Color.white.opacity(0.2))
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding()
    }
}

// MARK: - Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
