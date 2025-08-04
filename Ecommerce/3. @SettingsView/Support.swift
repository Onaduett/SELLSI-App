//
//  Support.swift
//  Ecommerce
//
//  Created by Daulet Yerkinov on 04.08.25.
//

import SwiftUI

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
