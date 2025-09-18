//
//  SettingsView.swift
//  ParkPing
//
//  Created by Yasin Cetin on 18.09.2025.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                // Background gradient
                LinearGradient(
                    colors: [
                        Color.black,
                        Color.blue.opacity(0.1),
                        Color.purple.opacity(0.05)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                    Form {
                        Section("Uygulama") {
                            HStack {
                                Image(systemName: "info.circle")
                                Text("Versiyon")
                                Spacer()
                                Text("1.0")
                                    .foregroundColor(.secondary)
                            }
                            
                            Link(destination: URL(string: "https://apps.apple.com/app/parkping")!) {
                                HStack {
                                    Image(systemName: "star")
                                    Text("Uygulamayı Değerlendir")
                                    Spacer()
                                    Image(systemName: "arrow.up.right")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                        
                        Section("Gizlilik") {
                            HStack {
                                Image(systemName: "location")
                                VStack(alignment: .leading) {
                                    Text("Konum Verileri")
                                    Text("Sadece cihazınızda saklanır")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                            
                            HStack {
                                Image(systemName: "bell")
                                VStack(alignment: .leading) {
                                    Text("Bildirimler")
                                    Text("Sadece yerel hatırlatmalar")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                    }
                    .navigationTitle("Ayarlar")
                    .scrollContentBackground(.hidden)
                    .background(.clear)
                
            }
        }
    }
}
