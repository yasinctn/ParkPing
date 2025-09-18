//
//  MainTabBarView.swift
//  ParkPing
//
//  Created by Yasin Cetin on 18.09.2025.
//

import SwiftUI

struct MainTabBarView: View {
    @EnvironmentObject var parkingViewModel: ParkingViewModel
    var body: some View {
        
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                .environmentObject(parkingViewModel)
                .tag(0)
            
                     
            ParkingHistoryView()
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("History")
                }
                .environmentObject(parkingViewModel)
                .tag(1)
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
                .tag(2)
        }
    }
}

#Preview {
    MainTabBarView()
}
