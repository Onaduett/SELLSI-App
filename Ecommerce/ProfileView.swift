//
//  ProfileView.swift
//  Ecommerce
//
//  Created by Daulet Yerkinov on 31.07.25.
//

import SwiftUI


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
