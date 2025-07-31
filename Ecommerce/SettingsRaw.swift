//
//  SettingsRaw.swift
//  Ecommerce
//
//  Created by Daulet Yerkinov on 31.07.25.
//
 
import SwiftUI

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
