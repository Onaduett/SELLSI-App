//
//  SettingsView.swift
//  Ecommerce
//
//  Created by Daulet Yerkinov on 31.07.25.
//


import SwiftUI

struct SettingsView: View {
  @EnvironmentObject var languageManager: LanguageManager
  @Environment(\.dismiss) private var dismiss
  
  var body: some View {
      NavigationView {
          VStack(spacing: 0) {
              // Header
              VStack(spacing: 16) {
                  Image(systemName: "gearshape.fill")
                      .font(.system(size: 50))
                      .foregroundColor(.blue)
                  
                  Text("settings_title".localized(languageManager))
                      .font(.largeTitle)
                      .bold()
                      .foregroundColor(.primary)
              }
              .padding(.top, 20)
              .padding(.bottom, 30)
              
              // Settings Content
              VStack(spacing: 20) {
                  // Language Section
                  VStack(alignment: .leading, spacing: 16) {
                      HStack {
                          Image(systemName: "globe")
                              .foregroundColor(.blue)
                              .font(.title2)
                          
                          Text("language_title".localized(languageManager))
                              .font(.headline)
                              .foregroundColor(.primary)
                          
                          Spacer()
                      }
                      .padding(.horizontal)
                      
                      VStack(spacing: 12) {
                          LanguageOptionView(
                              language: "ru",
                              title: "russian".localized(languageManager), // Localized
                              subtitle: "russian_subtitle".localized(languageManager), // Localized
                              isSelected: languageManager.currentLanguage == "ru"
                          ) {
                              withAnimation(.easeInOut(duration: 0.3)) {
                                  languageManager.currentLanguage = "ru"
                              }
                          }
                          
                          LanguageOptionView(
                              language: "en",
                              title: "english".localized(languageManager), // Localized
                              subtitle: "english_subtitle".localized(languageManager), // Localized
                              isSelected: languageManager.currentLanguage == "en"
                          ) {
                              withAnimation(.easeInOut(duration: 0.3)) {
                                  languageManager.currentLanguage = "en"
                              }
                          }
                      }
                  }
                  .padding()
                  .background(Color(.systemGray6))
                  .cornerRadius(16)
                  .padding(.horizontal)
                  
                  Spacer()
                  
                  // App Info
                  VStack(spacing: 8) {
                      Text("app_version".localized(languageManager))
                          .font(.caption)
                          .foregroundColor(.secondary)
                      
                      Text("1.0.0")
                          .font(.caption)
                          .foregroundColor(.secondary)
                  }
                  .padding(.bottom, 30)
              }
              
              Spacer()
          }
          .background(
              LinearGradient(
                  gradient: Gradient(colors: [Color.blue.opacity(0.05), Color.purple.opacity(0.05)]),
                  startPoint: .topLeading,
                  endPoint: .bottomTrailing
              )
              .ignoresSafeArea()
          )
          .navigationTitle("")
          .navigationBarHidden(true)
          .toolbar {
              ToolbarItem(placement: .navigationBarTrailing) {
                  Button("done".localized(languageManager)) {
                      dismiss()
                  }
                  .foregroundColor(.blue)
              }
          }
      }
  }
}

struct LanguageOptionView: View {
  let language: String
  let title: String
  let subtitle: String
  let isSelected: Bool
  let action: () -> Void
  
  var body: some View {
      Button(action: action) {
          HStack(spacing: 16) {
              // Flag or Language Icon
              ZStack {
                  Circle()
                      .fill(isSelected ? Color.blue : Color.gray.opacity(0.3))
                      .frame(width: 40, height: 40)
                  
                  Text(language == "ru" ? "🇷🇺" : "🇺🇸")
                      .font(.title2)
              }
              
              VStack(alignment: .leading, spacing: 2) {
                  Text(title)
                      .font(.headline)
                      .foregroundColor(.primary)
                  
                  Text(subtitle)
                      .font(.caption)
                      .foregroundColor(.secondary)
              }
              
              Spacer()
              
              if isSelected {
                  Image(systemName: "checkmark.circle.fill")
                      .foregroundColor(.blue)
                      .font(.title2)
              }
          }
          .padding()
          .background(Color(.systemBackground))
          .cornerRadius(12)
          .overlay(
              RoundedRectangle(cornerRadius: 12)
                  .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2)
          )
      }
      .buttonStyle(PlainButtonStyle())
  }
}

struct SettingsView_Previews: PreviewProvider {
  static var previews: some View {
      SettingsView()
          .environmentObject(LanguageManager())
  }
}

