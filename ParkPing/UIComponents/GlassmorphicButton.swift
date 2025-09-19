//
//  GlassmorphicButton.swift
//  ParkPing
//
//  Created by Yasin Cetin on 10.09.2025.
//

import SwiftUI

struct GlassmorphicButton: View {
    let title: String
    let action: () -> Void
    let isLoading: Bool
    
    var body: some View {
        Button(action: action) {
            HStack {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(0.8)
                } else {
                    Image(systemName: "car.fill")
                        .font(.title2)
                }
                
                Text(isLoading ? Txt.Common.saving : title)
                    .font(.headline)
                    .fontWeight(.semibold)
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 60)
            .background(
                ZStack {
                    // Glassmorphic background
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.ultraThinMaterial)
                        .background(
                            LinearGradient(
                                colors: [.blue.opacity(0.8), .purple.opacity(0.6)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                    
                    // Subtle border
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(
                            LinearGradient(
                                colors: [.white.opacity(0.3), .clear],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                }
            )
            .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
        }
        .disabled(isLoading)
        .scaleEffect(isLoading ? 0.95 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: isLoading)
    }
}
