//
//  OrderHistory.swift
//  Ecommerce
//
//  Created by Daulet Yerkinov on 04.08.25.
//

import SwiftUI

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
