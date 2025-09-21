//
//  SettingsViewModel.swift
//  ParkPing
//
//  Created by Yasin Cetin on 21.09.2025.
//

import Foundation
import SwiftUI
import CoreLocation

final class SettingsViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var locationStatusText: String = Txt.PermissionStatus.unknown
    @Published var notificationsStatusText: String = Txt.PermissionStatus.unknown
    private var locationManager: CLLocationManager

    override init() {
        self.locationManager = CLLocationManager()
        super.init()
        self.locationManager.delegate = self
        refreshStatuses()
    }

    func refreshStatuses() {
        // Location - Use instance property instead of deprecated static method
        let status = locationManager.authorizationStatus
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            locationStatusText = Txt.PermissionStatus.authorized
        case .denied:
            locationStatusText = Txt.PermissionStatus.denied
        case .restricted:
            locationStatusText = Txt.PermissionStatus.restricted
        case .notDetermined:
            locationStatusText = Txt.PermissionStatus.notDetermined
        @unknown default:
            locationStatusText = Txt.PermissionStatus.unknown
        }

        // Notifications
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                switch settings.authorizationStatus {
                case .authorized, .provisional, .ephemeral:
                    self.notificationsStatusText = Txt.PermissionStatus.authorized
                case .denied:
                    self.notificationsStatusText = Txt.PermissionStatus.denied
                case .notDetermined:
                    self.notificationsStatusText = Txt.PermissionStatus.notDetermined
                @unknown default:
                    self.notificationsStatusText = Txt.PermissionStatus.unknown
                }
            }
        }
    }
}


enum ThemeOption: String, CaseIterable, Identifiable {
    case system, light, dark
    var id: String { rawValue }
    var title: String {
        switch self {
        case .system: return Txt.Theme.system
        case .light:  return Txt.Theme.light
        case .dark:   return Txt.Theme.dark
        }
    }
    var preferredColorScheme: ColorScheme? {
        switch self {
        case .system: return nil
        case .light:  return .light
        case .dark:   return .dark
        }
    }
}
