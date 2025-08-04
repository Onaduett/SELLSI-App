//
//  LoadingView.swift
//  Ecommerce
//
//  Created by Daulet Yerkinov on 31.07.25.
//

import SwiftUI


struct LoadingView: View {
    @State private var isAnimating = false
    @EnvironmentObject var languageManager: LanguageManager
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(spacing: 20) {
            ZStack {
                Circle()
                    .stroke(Color.blue.opacity(0.3), lineWidth: 4)
                    .frame(width: 50, height: 50)
                
                Circle()
                    .trim(from: 0, to: 0.7)
                    .stroke(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.blue, Color.purple]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        style: StrokeStyle(lineWidth: 4, lineCap: .round)
                    )
                    .frame(width: 50, height: 50)
                    .rotationEffect(.degrees(isAnimating ? 360 : 0))
                    .animation(.linear(duration: 1).repeatForever(autoreverses: false), value: isAnimating)
            }
            
            Text("loading_products".localized(languageManager)) 
                .font(.headline)
                .foregroundColor(.primary)
        }
        .onAppear {
            isAnimating = true
        }
    }
}


