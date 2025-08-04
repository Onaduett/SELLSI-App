//
//  ProfileView.swift
//  Ecommerce
//
//  Created by v0 on 31.07.25.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var languageManager: LanguageManager
    @EnvironmentObject var themeManager: ThemeManager
    @Environment(\.colorScheme) var colorScheme
    @State private var userProfile: UserProfile
    @State private var showingEditProfile = false
    @State private var notificationsEnabled = true
    @State private var showingAppSettingsSheet = false
    @State private var showingOrderHistory = false
    @State private var showingSupport = false
    @State private var showingAbout = false
    
    init() {
        _userProfile = State(initialValue: UserProfile(
            name: "default_user_name".localized(LanguageManager()),
            email: "default_user_email".localized(LanguageManager()),
            phone: "default_user_phone".localized(LanguageManager()),
            address: "default_user_address".localized(LanguageManager())
        ))
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: AppTheme.gradientColors(for: colorScheme)),
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
                                .foregroundColor(AppTheme.primaryColor(for: colorScheme))
                            
                            Text(userProfile.email)
                                .font(.subheadline)
                                .foregroundColor(AppTheme.secondaryColor(for: colorScheme))
                        }
                        .padding()
                        .background(.ultraThinMaterial)
                        .cornerRadius(20)
                        
                        // Profile Info Section
                        VStack(alignment: .leading, spacing: 15) {
                            Text("profile_info_section_title".localized(languageManager))
                                .font(.headline)
                                .padding(.leading)
                                .foregroundColor(AppTheme.primaryColor(for: colorScheme))
                            
                            ProfileInfoRow(title: "phone_field_placeholder".localized(languageManager), value: userProfile.phone, icon: "phone.fill")
                            ProfileInfoRow(title: "address_field_placeholder".localized(languageManager), value: userProfile.address, icon: "location.fill")
                            
                            Button("edit_profile_title".localized(languageManager)) {
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
                            Text("settings_title".localized(languageManager))
                                .font(.headline)
                                .padding(.leading)
                                .foregroundColor(AppTheme.primaryColor(for: colorScheme))
                            
                            // Theme Switcher Row
                            HStack {
                                HStack(spacing: 12) {
                                    Image(systemName: themeManager.isDarkMode ? "moon.fill" : "sun.max.fill")
                                        .font(.system(size: 16))
                                        .foregroundColor(themeManager.isDarkMode ? .purple : .orange)
                                        .frame(width: 24)
                                    
                                    Text("dark_mode_setting_title".localized(languageManager))
                                        .font(.system(size: 16))
                                        .foregroundColor(AppTheme.primaryColor(for: colorScheme))
                                }
                                
                                Spacer()
                                
                                Button(action: {
                                    themeManager.toggleTheme()
                                }) {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 16)
                                            .fill(themeManager.isDarkMode ? Color.purple : Color.gray.opacity(0.3))
                                            .frame(width: 50, height: 30)
                                        
                                        Circle()
                                            .fill(Color.white)
                                            .frame(width: 26, height: 26)
                                            .offset(x: themeManager.isDarkMode ? 10 : -10)
                                            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: themeManager.isDarkMode)
                                    }
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 8)
                            
                            SettingsRow(
                                title: "notifications_setting_title".localized(languageManager),
                                icon: "bell.fill",
                                toggle: $notificationsEnabled
                            )
                            
                            Divider()
                            
                            SettingsActionRow(
                                title: "language_title".localized(languageManager),
                                icon: "globe"
                            ) {
                                showingAppSettingsSheet = true
                            }
                            
                            Divider()
                            
                            SettingsActionRow(
                                title: "order_history_action_title".localized(languageManager),
                                icon: "clock.fill"
                            ) {
                                showingOrderHistory = true
                            }
                            
                            SettingsActionRow(
                                title: "support_action_title".localized(languageManager),
                                icon: "questionmark.circle.fill"
                            ) {
                                showingSupport = true
                            }
                            
                            SettingsActionRow(
                                title: "about_app_action_title".localized(languageManager),
                                icon: "info.circle.fill"
                            ) {
                                showingAbout = true
                            }
                            
                            SettingsActionRow(
                                title: "app_settings_action_title".localized(languageManager),
                                icon: "gearshape.fill"
                            ) {
                                showingAppSettingsSheet = true
                            }
                        }
                        .padding(.vertical)
                        .background(.ultraThinMaterial)
                        .cornerRadius(20)
                        
                        // Logout Button
                        Button("logout_button_title".localized(languageManager)) {
                            // Handle logout
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
            .navigationTitle("profile_tab_title".localized(languageManager))
            .navigationBarTitleDisplayMode(.large)
        }
        .sheet(isPresented: $showingEditProfile) {
            EditProfileView(userProfile: $userProfile)
                .environmentObject(languageManager)
        }
        .sheet(isPresented: $showingAppSettingsSheet) {
            SettingsView()
                .environmentObject(languageManager)
        }
        .sheet(isPresented: $showingOrderHistory) {
            OrderHistoryView()
                .environmentObject(languageManager)
        }
        .sheet(isPresented: $showingSupport) {
            SupportView()
                .environmentObject(languageManager)
        }
        .sheet(isPresented: $showingAbout) {
            AboutView()
                .environmentObject(languageManager)
        }
    }
}

struct OrderHistoryView: View {
    @EnvironmentObject var languageManager: LanguageManager
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                Text("order_history_action_title".localized(languageManager))
                    .font(.largeTitle)
                    .padding()
                
                Spacer()
                
                Text("No orders yet")
                    .font(.body)
                    .foregroundColor(.secondary)
                
                Spacer()
            }
            .navigationTitle("order_history_action_title".localized(languageManager))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("done".localized(languageManager)) {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct SupportView: View {
    @EnvironmentObject var languageManager: LanguageManager
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                Text("support_action_title".localized(languageManager))
                    .font(.largeTitle)
                    .padding()
                
                Spacer()
                
                Text("Contact us at support@example.com")
                    .font(.body)
                    .foregroundColor(.secondary)
                
                Spacer()
            }
            .navigationTitle("support_action_title".localized(languageManager))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("done".localized(languageManager)) {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct AboutView: View {
    @EnvironmentObject var languageManager: LanguageManager
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                Text("about_app_action_title".localized(languageManager))
                    .font(.largeTitle)
                    .padding()
                
                Spacer()
                
                VStack(spacing: 16) {
                    Text("Your favorite ecommerce app")
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    Text("Version 1.0.0")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
            .navigationTitle("about_app_action_title".localized(languageManager))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("done".localized(languageManager)) {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .environmentObject(LanguageManager())
            .environmentObject(ThemeManager())
    }
}



