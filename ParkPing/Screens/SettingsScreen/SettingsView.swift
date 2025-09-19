//
//  SettingsView.swift
//  ParkPing
//
//  Created by Yasin Cetin on 18.09.2025.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    colors: [Color.black, Color.blue.opacity(0.1), Color.purple.opacity(0.05)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                Form {
                    Section(Txt.Settings.appSectionTitle) {
                        HStack {
                            Image(systemName: "info.circle")
                            Text(Txt.Settings.version)
                            Spacer()
                            Text(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0")
                                .foregroundColor(.secondary)
                        }

                        Link(destination: URL(string: "https://apps.apple.com/app/parkping")!) {
                            HStack {
                                Image(systemName: "star")
                                Text(Txt.Settings.rateApp)
                                Spacer()
                                Image(systemName: "arrow.up.right")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }

                        // Apple'ın önerdiği: Dili Ayarlar'dan değiştir.
                        Button {
                            if let url = URL(string: UIApplication.openSettingsURLString) {
                                UIApplication.shared.open(url) // App settings'e açar
                            }
                        } label: {
                            HStack {
                                Image(systemName: "globe")
                                Text(Txt.Settings.changeAppLanguage)
                                Spacer()
                                Image(systemName: "arrow.up.right")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .accessibilityIdentifier("openAppSettingsForLanguage")
                    }

                    Section(Txt.Settings.privacySectionTitle) {
                        HStack {
                            Image(systemName: "location")
                            VStack(alignment: .leading) {
                                Text(Txt.Settings.privacyLocationTitle)
                                Text(Txt.Settings.privacyLocationSubtitle)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }

                        HStack {
                            Image(systemName: "bell")
                            VStack(alignment: .leading) {
                                Text(Txt.Settings.privacyNotificationsTitle)
                                Text(Txt.Settings.privacyNotificationsSubtitle)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
                .navigationTitle(Text(Txt.Settings.title))
                
                .background(.clear)
            }
        }
    }
}
