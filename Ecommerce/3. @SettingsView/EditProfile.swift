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
  @EnvironmentObject var languageManager: LanguageManager
  
  @State private var name: String = ""
  @State private var email: String = ""
  @State private var phone: String = ""
  @State private var address: String = ""
  
  var body: some View {
      NavigationView {
          Form {
              Section("basic_info_section_title".localized(languageManager)) {
                  TextField("name_field_placeholder".localized(languageManager), text: $name)
                  TextField("email_field_placeholder".localized(languageManager), text: $email)
                      .keyboardType(.emailAddress)
              }
              
              Section("contacts_section_title".localized(languageManager)) {
                  TextField("phone_field_placeholder".localized(languageManager), text: $phone)
                      .keyboardType(.phonePad)
                  TextField("address_field_placeholder".localized(languageManager), text: $address)
              }
          }
          .navigationTitle("edit_profile_title".localized(languageManager))
          .navigationBarTitleDisplayMode(.inline)
          .toolbar {
              ToolbarItem(placement: .navigationBarLeading) {
                  Button("cancel".localized(languageManager)) {
                      presentationMode.wrappedValue.dismiss()
                  }
              }
              
              ToolbarItem(placement: .navigationBarTrailing) {
                  Button("save".localized(languageManager)) { 
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

