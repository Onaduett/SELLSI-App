//
//  ProfileView.swift
//  Ecommerce
//
//  Created by Daulet Yerkinov on 31.07.25.
//

import SwiftUI


struct ProfileView: View {
    @EnvironmentObject var languageManager: LanguageManager
    @State private var userProfile: UserProfile
    @State private var showingEditProfile = false
    @State private var isDarkMode = false
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
                    gradient: Gradient(colors: [Color.purple.opacity(0.1), Color.pink.opacity(0.1)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 25) {
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
                        
                        VStack(alignment: .leading, spacing: 15) {
                            Text("profile_info_section_title".localized(languageManager))
                                .font(.headline)
                                .padding(.leading)
                            
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
                        
                        VStack(alignment: .leading, spacing: 15) {
                            Text("settings_title".localized(languageManager))
                                .font(.headline)
                                .padding(.leading)
                            
                            SettingsRow(
                                title: "notifications_setting_title".localized(languageManager),
                                icon: "bell.fill",
                                toggle: $notificationsEnabled
                            )
                            
                            SettingsRow(
                                title: "dark_mode_setting_title".localized(languageManager),
                                icon: "moon.fill",
                                toggle: $isDarkMode
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
                        
                        Button("logout_button_title".localized(languageManager)) {
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

// MARK: - Placeholder Views for the sheets
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
    }
}



