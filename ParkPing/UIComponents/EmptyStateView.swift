//
//  EmptyStateView.swift
//  ParkPing
//
//  Created by Yasin Cetin on 18.09.2025.
//

import SwiftUI

struct EmptyStateView: View {
    
    var body: some View {
        VStack(spacing: 16) {
            // Empty state illustration
            ZStack {
                Circle()
                    .fill(.ultraThinMaterial)
                    .frame(width: 60, height: 60)
                    .overlay(
                        Circle()
                            .stroke(.white.opacity(0.1), lineWidth: 1)
                    )
                
                Image(systemName: "car.circle")
                    .font(.title)
                    .foregroundColor(.white.opacity(0.6))
            }
            
            VStack(spacing: 8) {
                Text("No parking saved yet")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                
                Text("Save your first parking spot to see it here")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
            
            Button(action: {
                // Navigate to save parking
            }) {
                Text("Save Parking Spot")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(
                        Capsule()
                            .fill(.green.opacity(0.8))
                    )
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 24)
    }
}

#Preview {
    EmptyStateView()
}
