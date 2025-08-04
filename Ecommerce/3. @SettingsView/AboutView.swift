//
//  AboutView.swift
//  Ecommerce
//
//  Created by Daulet Yerkinov on 04.08.25.
//

import SwiftUI

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
