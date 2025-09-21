//
//  SettingsView.swift
//  ParkPing
//
//  Created by Yasin Cetin on 18.09.2025.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var vm: SettingsViewModel

    // Kalıcı ayarlar
    @AppStorage("appTheme") private var appThemeRaw: String = ThemeOption.system.rawValue
    @AppStorage("defaultRoutingApp") private var routingApp: String = Txt.RoutingApps.appleMaps

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
                    // GÖRÜNÜM
                    Section(Txt.Settings.appearance) {
                        Picker(Txt.Settings.theme, selection: Binding(
                            get: { ThemeOption(rawValue: appThemeRaw) ?? .system },
                            set: { appThemeRaw = $0.rawValue }
                        )) {
                            ForEach(ThemeOption.allCases) { option in
                                Text(option.title).tag(option)
                            }
                        }

                        // TODO: Dokunsal Geri Bildirim toggle
                        // TODO: Animasyonları Azalt toggle
                    }

                    // DİL
                    Section(Txt.Settings.language) {
                        Button {
                            if let url = URL(string: UIApplication.openSettingsURLString) {
                                UIApplication.shared.open(url)
                            }
                        } label: {
                            HStack {
                                Image(systemName: "globe")
                                Text(Txt.Settings.changeAppLanguage)
                                Spacer()
                                Image(systemName: "arrow.up.right").font(.caption).foregroundColor(.secondary)
                            }
                        }
                        Text(Txt.Settings.languageDescription)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }

                    // İZİNLER
                    Section(Txt.Settings.permissions) {
                        HStack {
                            Image(systemName: "location")
                            VStack(alignment: .leading) {
                                Text(Txt.Settings.location)
                                Text(vm.locationStatusText).font(.caption).foregroundColor(.secondary)
                            }
                            Spacer()
                            Button {
                                if let url = URL(string: UIApplication.openSettingsURLString) {
                                    UIApplication.shared.open(url)
                                }
                            } label: {
                                Text(Txt.Settings.openSettings)
                            }
                            .buttonStyle(.borderless)
                        }

                        HStack {
                            Image(systemName: "bell")
                            VStack(alignment: .leading) {
                                Text(Txt.Settings.notifications)
                                Text(vm.notificationsStatusText).font(.caption).foregroundColor(.secondary)
                            }
                            Spacer()
                            Button {
                                if #available(iOS 16.0, *) {
                                    if let url = URL(string: UIApplication.openNotificationSettingsURLString) {
                                        UIApplication.shared.open(url)
                                    } else if let url = URL(string: UIApplication.openSettingsURLString) {
                                        UIApplication.shared.open(url)
                                    }
                                } else {
                                    // Fallback on earlier versions
                                }
                            } label: {
                                Text(Txt.Settings.openSettings)
                            }
                            .buttonStyle(.borderless)
                        }
                    }

                    // HARİTA & ROTA
                    Section(Txt.Settings.routing) {
                        Picker(Txt.Settings.defaultApp, selection: $routingApp) {
                            Text(Txt.RoutingApps.appleMaps).tag(Txt.RoutingApps.appleMaps)
                            Text(Txt.RoutingApps.googleMaps).tag(Txt.RoutingApps.googleMaps)
                        }
                        Text(Txt.Settings.routingDescription)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }

                    // UYGULAMA
                    Section(Txt.Settings.appSectionTitle) {
                        HStack {
                            Image(systemName: "info.circle")
                            Text(Txt.Settings.version)
                            Spacer()
                            Text(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0")
                                .foregroundColor(.secondary)
                        }
                        //uygulama linki eklenecek
                        Link(destination: URL(string: "https://apps.apple.com")!) {
                            HStack {
                                Image(systemName: "star")
                                Text(Txt.Settings.rateApp)
                                Spacer()
                                Image(systemName: "arrow.up.right").font(.caption).foregroundColor(.secondary)
                            }
                        }

                        Link(destination: URL(string: "https://yasincetindev.github.io/ParkPingApp/Privacy/")!) {
                            HStack {
                                Image(systemName: "lock.shield")
                                Text(Txt.Settings.privacyPolicy)
                                Spacer()
                                Image(systemName: "arrow.up.right").font(.caption).foregroundColor(.secondary)
                            }
                        }
                    }
                    // TODO: Core Data geçmiş temizleme işlemi
                    // VERİ
                    /*
                    Section(Txt.Settings.data) {
                        Button(role: .destructive) {
                            confirmResetData()
                        } label: {
                            HStack {
                                Image(systemName: "trash")
                                Text(Txt.Settings.clearHistory)
                            }
                        }
                    }
                     */
                }
                .navigationTitle(Text(Txt.Settings.title))
                .background(.clear)
                .onAppear { vm.refreshStatuses() }
            }
        }
        .preferredColorScheme((ThemeOption(rawValue: appThemeRaw) ?? .system).preferredColorScheme)
    }

    private func confirmResetData() {
        // TODO: Core Data geçmiş temizleme işlemi
    }
}

