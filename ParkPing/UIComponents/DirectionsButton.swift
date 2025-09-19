//
//  DirectionsButton.swift
//  ParkPing
//
//  Created by Yasin Cetin on 12.09.2025.
//

import SwiftUI

struct DirectionsButton: View {
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            HStack {
                Image(systemName: "location.fill")
                Text(Txt.Directions.title)
                    .fontWeight(.semibold)
            }
            .foregroundColor(.white)
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(
                LinearGradient(
                    colors: [.blue, .purple],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .clipShape(Capsule())
            .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
        }
    }
}
