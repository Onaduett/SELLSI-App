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

// MARK: - Main Tab View
struct MainTabView: View {
    @StateObject private var cartManager = CartManager()
    @StateObject private var productService = ProductService()
    
    var body: some View {
        TabView {
            // Main Products Page
            ProductsView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Главная")
                }
                .environmentObject(cartManager)
                .environmentObject(productService)
            
            // Shopping Cart
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
            
            // Settings and Profile
            ProfileView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Профиль")
                }
        }
        .accentColor(.blue)
    }
}

// MARK: - Products View (Main Page)
struct ProductsView: View {
    @EnvironmentObject var productService: ProductService
    @EnvironmentObject var cartManager: CartManager
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.1), Color.purple.opacity(0.1)]),
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
                    .foregroundColor(.primary)
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
    var columns = [GridItem(.adaptive(minimum: 180), spacing: 20)]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(products) { product in
                    ProductCardView(product: product)
                }
            }
            .padding()
        }
    }
}

// MARK: - Product Card View
struct ProductCardView: View {
    let product: Product
    @EnvironmentObject var cartManager: CartManager
    @State private var showingBuyAlert = false
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            ZStack(alignment: .bottom) {
                AsyncImage(url: URL(string: product.imageUrl ?? "")) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.gray.opacity(0.2))
                        .overlay(
                            VStack {
                                Image(systemName: "photo")
                                    .font(.title)
                                    .foregroundColor(.gray)
                                Text("Загрузка...")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        )
                }
                .frame(width: 180, height: 200)
                .clipped()
                .cornerRadius(20)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(product.name)
                        .font(.headline)
                        .bold()
                        .foregroundColor(.primary)
                        .lineLimit(1)
                    
                    HStack {
                        Text(product.formattedPrice)
                            .font(.title3)
                            .bold()
                            .foregroundColor(.green)
                        
                        Spacer()
                        
                        if let type = product.type {
                            Text(type.uppercased())
                                .font(.caption2)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Color.blue.opacity(0.2))
                                .foregroundColor(.blue)
                                .cornerRadius(4)
                        }
                    }
                    
                    if let description = product.description {
                        Text(description)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .lineLimit(2)
                    }
                    
                    Text(product.formattedDate)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                .padding()
                .frame(width: 180, alignment: .leading)
                .background(.ultraThinMaterial)
                .cornerRadius(20)
            }
            .frame(width: 180, height: 280)
            .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
            
            Button(action: {
                cartManager.addToCart(product: product)
                showingBuyAlert = true
            }) {
                Image(systemName: "cart.badge.plus")
                    .font(.system(size: 16, weight: .bold))
                    .padding(12)
                    .foregroundColor(.white)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.blue, Color.purple]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .cornerRadius(25)
                    .shadow(color: .blue.opacity(0.3), radius: 4, x: 0, y: 2)
            }
            .padding()
            .alert("Товар добавлен", isPresented: $showingBuyAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Товар \"\(product.name)\" добавлен в корзину!")
            }
        }
        .scaleEffect(showingBuyAlert ? 0.95 : 1.0)
        .animation(.easeInOut(duration: 0.1), value: showingBuyAlert)
    }
}

// MARK: - Cart View
struct CartView: View {
    @EnvironmentObject var cartManager: CartManager
    @State private var showingCheckoutAlert = false
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color.green.opacity(0.1), Color.blue.opacity(0.1)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                if cartManager.items.isEmpty {
                    EmptyCartView()
                } else {
                    VStack {
                        List {
                            ForEach(cartManager.items) { item in
                                CartItemView(item: item)
                            }
                            .onDelete(perform: deleteItems)
                        }
                        .listStyle(PlainListStyle())
                        
                        CartSummaryView()
                    }
                }
            }
            .navigationTitle("🛒 Корзина")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                if !cartManager.items.isEmpty {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Очистить") {
                            cartManager.clearCart()
                        }
                        .foregroundColor(.red)
                    }
                }
            }
        }
    }
    
    func deleteItems(offsets: IndexSet) {
        for index in offsets {
            cartManager.removeFromCart(item: cartManager.items[index])
        }
    }
}

// MARK: - Cart Item View
struct CartItemView: View {
    let item: CartItem
    @EnvironmentObject var cartManager: CartManager
    
    var body: some View {
        HStack(spacing: 15) {
            AsyncImage(url: URL(string: item.product.imageUrl ?? "")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.2))
                    .overlay(
                        Image(systemName: "photo")
                            .foregroundColor(.gray)
                    )
            }
            .frame(width: 80, height: 80)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(item.product.name)
                    .font(.headline)
                    .lineLimit(2)
                
                Text(item.product.formattedPrice)
                    .font(.subheadline)
                    .foregroundColor(.green)
                    .bold()
                
                HStack {
                    Button {
                        cartManager.updateQuantity(item: item, quantity: item.quantity - 1)
                    } label: {
                        Image(systemName: "minus.circle.fill")
                            .foregroundColor(.red)
                    }
                    
                    Text("\(item.quantity)")
                        .font(.headline)
                        .frame(minWidth: 30)
                    
                    Button {
                        cartManager.updateQuantity(item: item, quantity: item.quantity + 1)
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.blue)
                    }
                }
            }
            
            Spacer()
            
            VStack {
                Text(String(format: "₽%.0f", item.totalPrice))
                    .font(.headline)
                    .bold()
                    .foregroundColor(.primary)
            }
        }
        .padding(.vertical, 8)
        .background(Color.white.opacity(0.8))
        .cornerRadius(12)
    }
}

// MARK: - Cart Summary View
struct CartSummaryView: View {
    @EnvironmentObject var cartManager: CartManager
    @State private var showingCheckoutAlert = false
    
    var body: some View {
        VStack(spacing: 15) {
            Divider()
            
            HStack {
                Text("Итого:")
                    .font(.title2)
                    .bold()
                
                Spacer()
                
                Text(cartManager.formattedTotalPrice)
                    .font(.title2)
                    .bold()
                    .foregroundColor(.green)
            }
            .padding(.horizontal)
            
            Button("Оформить заказ") {
                showingCheckoutAlert = true
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color.green, Color.blue]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .foregroundColor(.white)
            .cornerRadius(12)
            .padding(.horizontal)
            .alert("Заказ оформлен!", isPresented: $showingCheckoutAlert) {
                Button("OK") {
                    cartManager.clearCart()
                }
            } message: {
                Text("Ваш заказ на сумму \(cartManager.formattedTotalPrice) успешно оформлен!")
            }
        }
        .padding(.bottom)
        .background(.ultraThinMaterial)
    }
}

// MARK: - Empty Cart View
struct EmptyCartView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "cart")
                .font(.system(size: 60))
                .foregroundColor(.gray.opacity(0.7))
            
            Text("Корзина пуста")
                .font(.title)
                .bold()
                .foregroundColor(.primary)
            
            Text("Добавьте товары из каталога")
                .font(.body)
                .foregroundColor(.secondary)
        }
    }
}

// MARK: - Profile View
struct ProfileView: View {
    @State private var userProfile = UserProfile()
    @State private var showingEditProfile = false
    @State private var isDarkMode = false
    @State private var notificationsEnabled = true
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color.purple.opacity(0.1), Color.pink.opacity(0.1)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 25) {
                        // Profile Header
                        VStack(spacing: 15) {
                            Image(systemName: "person.circle.fill")
                                .font(.system(size: 80))
                                .foregroundColor(.blue)
                            
                            Text(userProfile.name)
                                .font(.title2)
                                .bold()
                            
                            Text(userProfile.email)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .padding()
                        .background(.ultraThinMaterial)
                        .cornerRadius(20)
                        
                        // Profile Information
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Информация профиля")
                                .font(.headline)
                                .padding(.leading)
                            
                            ProfileInfoRow(title: "Телефон", value: userProfile.phone, icon: "phone.fill")
                            ProfileInfoRow(title: "Адрес", value: userProfile.address, icon: "location.fill")
                            
                            Button("Редактировать профиль") {
                                showingEditProfile = true
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue.opacity(0.1))
                            .foregroundColor(.blue)
                            .cornerRadius(12)
                            .padding(.horizontal)
                        }
                        .padding(.vertical)
                        .background(.ultraThinMaterial)
                        .cornerRadius(20)
                        
                        // Settings Section
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Настройки")
                                .font(.headline)
                                .padding(.leading)
                            
                            SettingsRow(
                                title: "Уведомления",
                                icon: "bell.fill",
                                toggle: $notificationsEnabled
                            )
                            
                            SettingsRow(
                                title: "Темная тема",
                                icon: "moon.fill",
                                toggle: $isDarkMode
                            )
                            
                            Divider()
                            
                            SettingsActionRow(title: "История заказов", icon: "clock.fill")
                            SettingsActionRow(title: "Служба поддержки", icon: "questionmark.circle.fill")
                            SettingsActionRow(title: "О приложении", icon: "info.circle.fill")
                        }
                        .padding(.vertical)
                        .background(.ultraThinMaterial)
                        .cornerRadius(20)
                        
                        // Logout Button
                        Button("Выйти") {
                            // Logout logic here
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red.opacity(0.1))
                        .foregroundColor(.red)
                        .cornerRadius(12)
                        .padding(.horizontal)
                    }
                    .padding()
                }
            }
            .navigationTitle("👤 Профиль")
            .navigationBarTitleDisplayMode(.large)
        }
        .sheet(isPresented: $showingEditProfile) {
            EditProfileView(userProfile: $userProfile)
        }
    }
}

// MARK: - Profile Info Row
struct ProfileInfoRow: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 20)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(value)
                    .font(.body)
                    .foregroundColor(.primary)
            }
            
            Spacer()
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
}

// MARK: - Settings Row
struct SettingsRow: View {
    let title: String
    let icon: String
    @Binding var toggle: Bool
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 20)
            
            Text(title)
                .font(.body)
            
            Spacer()
            
            Toggle("", isOn: $toggle)
                .labelsHidden()
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
}

// MARK: - Settings Action Row
struct SettingsActionRow: View {
    let title: String
    let icon: String
    
    var body: some View {
        Button {
            // Action logic here
        } label: {
            HStack(spacing: 15) {
                Image(systemName: icon)
                    .foregroundColor(.blue)
                    .frame(width: 20)
                
                Text(title)
                    .font(.body)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
        }
    }
}

// MARK: - Edit Profile View
struct EditProfileView: View {
    @Binding var userProfile: UserProfile
    @Environment(\.presentationMode) var presentationMode
    
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var phone: String = ""
    @State private var address: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section("Основная информация") {
                    TextField("Имя", text: $name)
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                }
                
                Section("Контакты") {
                    TextField("Телефон", text: $phone)
                        .keyboardType(.phonePad)
                    TextField("Адрес", text: $address)
                }
            }
            .navigationTitle("Редактировать профиль")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Отмена") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Сохранить") {
                        userProfile.name = name
                        userProfile.email = email
                        userProfile.phone = phone
                        userProfile.address = address
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
        .onAppear {
            name = userProfile.name
            email = userProfile.email
            phone = userProfile.phone
            address = userProfile.address
        }
    }
}

// MARK: - Loading View
struct LoadingView: View {
    @State private var isAnimating = false
    
    var body: some View {
        VStack(spacing: 20) {
            ZStack {
                Circle()
                    .stroke(Color.blue.opacity(0.3), lineWidth: 4)
                    .frame(width: 50, height: 50)
                
                Circle()
                    .trim(from: 0, to: 0.7)
                    .stroke(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.blue, Color.purple]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        style: StrokeStyle(lineWidth: 4, lineCap: .round)
                    )
                    .frame(width: 50, height: 50)
                    .rotationEffect(.degrees(isAnimating ? 360 : 0))
                    .animation(.linear(duration: 1).repeatForever(autoreverses: false), value: isAnimating)
            }
            
            Text("Загружаем товары...")
                .font(.headline)
                .foregroundColor(.primary)
        }
        .onAppear {
            isAnimating = true
        }
    }
}

// MARK: - Error View
struct ErrorView: View {
    let message: String
    let onRetry: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 50))
                .foregroundColor(.red)
            
            Text("Ошибка")
                .font(.title)
                .bold()
                .foregroundColor(.primary)
            
            Text(message)
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Button("Попробовать снова") {
                onRetry()
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue, Color.purple]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .foregroundColor(.white)
            .cornerRadius(10)
            .shadow(color: .blue.opacity(0.3), radius: 4, x: 0, y: 2)
        }
        .padding()
    }
}

// MARK: - Empty State View
struct EmptyStateView: View {
    let onRefresh: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "tray.fill")
                .font(.system(size: 50))
                .foregroundColor(.gray.opacity(0.7))
            
            Text("Нет товаров")
                .font(.title)
                .bold()
                .foregroundColor(.primary)
            
            Text("Пока нет доступных товаров.\nПопробуйте обновить список.")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            Button("Обновить") {
                onRefresh()
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue, Color.purple]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .foregroundColor(.white)
            .cornerRadius(10)
            .shadow(color: .blue.opacity(0.3), radius: 4, x: 0, y: 2)
        }
        .padding()
    }
}

// MARK: - Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
