//
//  EditProfile.swift
//  Ecommerce
//
//  Created by Daulet Yerkinov on 31.07.25.
//

import SwiftUI

struct EditProfileView: View {
  @Binding var userProfile: UserProfile
  @Environment(\.presentationMode) var presentationMode
  @EnvironmentObject var languageManager: LanguageManager // Added for localization
  
  @State private var name: String = ""
  @State private var email: String = ""
  @State private var phone: String = ""
  @State private var address: String = ""
  
  var body: some View {
      NavigationView {
          Form {
              Section("basic_info_section_title".localized(languageManager)) { // Localized
                  TextField("name_field_placeholder".localized(languageManager), text: $name) // Localized
                  TextField("email_field_placeholder".localized(languageManager), text: $email) // Localized
                      .keyboardType(.emailAddress)
              }
              
              Section("contacts_section_title".localized(languageManager)) { // Localized
                  TextField("phone_field_placeholder".localized(languageManager), text: $phone) // Localized
                      .keyboardType(.phonePad)
                  TextField("address_field_placeholder".localized(languageManager), text: $address) // Localized
              }
          }
          .navigationTitle("edit_profile_title".localized(languageManager)) // Localized
          .navigationBarTitleDisplayMode(.inline)
          .toolbar {
              ToolbarItem(placement: .navigationBarLeading) {
                  Button("cancel".localized(languageManager)) { // Localized
                      presentationMode.wrappedValue.dismiss()
                  }
              }
              
              ToolbarItem(placement: .navigationBarTrailing) {
                  Button("save".localized(languageManager)) { // Localized
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

