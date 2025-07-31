//
//  SettingsActionRaw.swift
//  Ecommerce
//
//  Created by Daulet Yerkinov on 31.07.25.
//

import SwiftUI

struct SettingsActionRow: View {
    let title: String // This title is expected to be a localized string key
    let icon: String
    let action: () -> Void // Add action parameter
    
    var body: some View {
        Button(action: action) { // Use the passed action
            HStack(spacing: 15) {
                Image(systemName: icon)
                    .foregroundColor(.blue)
                    .frame(width: 20)
                
                Text(title) // This text will now display the localized string
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
