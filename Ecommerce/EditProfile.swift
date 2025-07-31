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
