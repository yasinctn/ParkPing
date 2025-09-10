//
//  ToastView.swift
//  ParkPing
//
//  Created by Yasin Cetin on 10.09.2025.
//

import SwiftUI

struct ToastView: View {
    let message: String
    @Binding var isShowing: Bool
    
    var body: some View {
        HStack {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.green)
            
            Text(message)
                .font(.subheadline)
                .fontWeight(.medium)
        }
        .foregroundColor(.primary)
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(.regularMaterial)
                .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
        )
        .scaleEffect(isShowing ? 1 : 0.8)
        .opacity(isShowing ? 1 : 0)
        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: isShowing)
    }
}
