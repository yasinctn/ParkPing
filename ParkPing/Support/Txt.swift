//
//  Txt.swift
//  ParkPing
//
//  Created by Yasin Cetin on 19.09.2025.
//

import Foundation

enum Txt {
    
    // MARK: - App
    enum App {
        static var name: String { String(localized: "app_name", defaultValue: "ParkPing") }
        static var tagline: String { String(localized: "app_tagline", defaultValue: "Never lose your car again") }
    }
    
    // MARK: - Settings
    enum Settings {
        static var title: String { String(localized: "settings_title", defaultValue: "Settings") }
        static var appSectionTitle: String { String(localized: "app_section_title", defaultValue: "App") }
        static var version: String { String(localized: "version_label", defaultValue: "Version") }
        static var rateApp: String { String(localized: "rate_app", defaultValue: "Rate the App") }
        static var changeAppLanguage: String { String(localized: "change_app_language", defaultValue: "Change App Language") }
        static var privacySectionTitle: String { String(localized: "privacy_section_title", defaultValue: "Privacy") }
        static var privacyLocationTitle: String { String(localized: "privacy_location_title", defaultValue: "Location Data") }
        static var privacyLocationSubtitle: String { String(localized: "privacy_location_subtitle", defaultValue: "Stored only on device") }
        static var privacyNotificationsTitle: String { String(localized: "privacy_notifications_title", defaultValue: "Notifications") }
        static var privacyNotificationsSubtitle: String { String(localized: "privacy_notifications_subtitle", defaultValue: "Local reminders only") }
    }
    
    // MARK: - Common
    enum Common {
        static var actionsTitle: String { String(localized: "actions_title", defaultValue: "Actions") }
        static var edit: String { String(localized: "edit", defaultValue: "Edit") }
        static var share: String { String(localized: "share", defaultValue: "Share") }
        static var delete: String { String(localized: "delete", defaultValue: "Delete") }
        static var cancel: String { String(localized: "cancel", defaultValue: "Cancel") }
        static var save: String { String(localized: "save", defaultValue: "Save") }
        static var ok: String { String(localized: "ok", defaultValue: "OK") }
        static var settings: String { String(localized: "settings", defaultValue: "Settings") }
        static var saving: String { String(localized: "saving", defaultValue: "Saving...") }
        
        static func savedOn(_ formattedDate: String) -> String {
            String(format: String(localized: "saved_on_format", defaultValue: "Saved on %@"), formattedDate)
        }
        
        static func spotsCount(_ n: Int) -> String {
            let format = String(localized: "spots_count", defaultValue: "%d spots")
            return String.localizedStringWithFormat(format, n)
        }

    }
    
    // MARK: - Home
    enum Home {
        static var saveParkingLocation: String { String(localized: "save_parking_location", defaultValue: "Save Parking Location") }
        static var saveParkingSpot: String { String(localized: "save_parking_spot", defaultValue: "Save Parking Spot") }
    }
    
    // MARK: - Recent Parking
    enum RecentParking {
        static var title: String { String(localized: "recent_parking_title", defaultValue: "Recent Parking") }
    }
    
    enum ParkingDetails {
        static var title: String { String(localized: "parking_details_title", defaultValue: "Parking Details") }
    }
    
    // MARK: - Parking History
    enum ParkingHistory {
        static var title: String { String(localized: "parking_history_title", defaultValue: "Parking History") }
    }
    
    // MARK: - Location Details
    enum LocationDetails {
        static var title: String { String(localized: "location_details_title", defaultValue: "Location Details") }
        static var coordinates: String { String(localized: "coordinates_label", defaultValue: "Coordinates") }
        static var saved: String { String(localized: "saved_label", defaultValue: "Saved") }
        static var address: String { String(localized: "address_label", defaultValue: "Address") }
    }
    
    // MARK: - Delete Confirmation
    enum DeleteConfirm {
        static var title: String { String(localized: "delete_confirm_title", defaultValue: "Delete Parking Spot") }
        static var message: String { String(localized: "delete_confirm_message", defaultValue: "Are you sure you want to delete this parking spot? This action cannot be undone.") }
    }
    
    // MARK: - Empty State
    enum EmptyState {
        static var noParkingSaved: String { String(localized: "no_parking_saved", defaultValue: "No parking saved yet") }
        static var saveFirstSpot: String { String(localized: "save_first_spot", defaultValue: "Save your first parking spot to see it here") }
    }
    
    // MARK: - Edit Parking
    enum EditParking {
        static var title: String { String(localized: "edit_parking_title", defaultValue: "Edit") }
        static var infoSection: String { String(localized: "info_section", defaultValue: "Information") }
        static var titleField: String { String(localized: "title_field", defaultValue: "Title") }
        static var addressField: String { String(localized: "address_field", defaultValue: "Address") }
    }
    
    // MARK: - Alerts
    enum Alerts {
        static var locationError: String { String(localized: "location_error", defaultValue: "Location Error") }
        static var locationPermission: String { String(localized: "location_permission", defaultValue: "Location Permission") }
        static var locationPermissionMessage: String { String(localized: "location_permission_message", defaultValue: "ParkPing needs location access to save your parking spots. Please enable location services in Settings.") }
    }
    
    // MARK: - Parking Spot
    enum ParkingSpot {
        static var defaultTitle: String { String(localized: "parking_spot_default", defaultValue: "Parking Spot") }
    }
    
    // MARK: - Tab Bar
    enum TabBar {
        static var home: String { String(localized: "tab_home", defaultValue: "Home") }
        static var history: String { String(localized: "tab_history", defaultValue: "History") }
        static var settings: String { String(localized: "tab_settings", defaultValue: "Settings") }
    }
    
    // MARK: - Directions
    enum Directions {
        static var title: String { String(localized: "directions_title", defaultValue: "Directions") }
    }
    
    // MARK: - Messages
    enum Messages {
        static var parkingLocationSaved: String { String(localized: "parking_location_saved", defaultValue: "Parking location saved successfully!") }
        static var parkingSpotDeleted: String { String(localized: "parking_spot_deleted", defaultValue: "Parking spot deleted") }
        static var parkingSpotsDeleted: String { String(localized: "parking_spots_deleted", defaultValue: "Parking spots deleted") }
        static var failedToLoadSpots: String { String(localized: "failed_to_load_spots", defaultValue: "Failed to load parking spots") }
        static var failedToSaveLocation: String { String(localized: "failed_to_save_location", defaultValue: "Failed to save parking location") }
        static var failedToDeleteSpot: String { String(localized: "failed_to_delete_spot", defaultValue: "Failed to delete parking spot") }
        static var failedToDeleteSpots: String { String(localized: "failed_to_delete_spots", defaultValue: "Failed to delete parking spots") }
        static var failedToGetLocation: String { String(localized: "failed_to_get_location", defaultValue: "Failed to get location") }
        static var locationPrefix: String { String(localized: "location_prefix", defaultValue: "Location: %@") }
    }
    
    // MARK: - Mock Data
    enum MockData {
        static var parkingSpotTitle: String { String(localized: "parking_spot_title", defaultValue: "Parking Spot #%@") }
        static var downtownParking: String { String(localized: "downtown_parking", defaultValue: "Downtown Parking") }
        static var mallParking: String { String(localized: "mall_parking", defaultValue: "Mall Parking") }
        static var officeParking: String { String(localized: "office_parking", defaultValue: "Office Parking") }
        static var failedToCreateMockData: String { String(localized: "failed_to_create_mock_data", defaultValue: "Failed to create initial mock data") }
    }
    
    // MARK: - Debug
    enum Debug {
        static var errorPrefix: String { String(localized: "error_prefix", defaultValue: "❌ ParkingViewModel Error: %@") }
        static var reverseGeocodingFailed: String { String(localized: "reverse_geocoding_failed", defaultValue: "Reverse geocoding failed: %@") }
    }
}
