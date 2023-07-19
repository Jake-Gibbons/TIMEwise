//
//  TimeWiseApp.swift
//  TimeWise
//
//  Created by Jake Gibbons on 30/06/2023.
//

import SwiftUI

@main
struct TimeWiseApp: App {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.customColor) private var color: Binding<Color>
    
    @AppStorage("color") var accentColor: Color = Color.blue
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    @SceneStorage("currentView") var currentView: String?
    
    var body: some Scene {
        WindowGroup {
            WelcomeView()
                .environment(\.customColor, $accentColor)
                .preferredColorScheme(isDarkMode ? .dark : .light)
            
            if currentView == "settings" {
                SettingsView()
            } else if currentView == "guestmanagement"{
                GuestManagementView()
            } else {

            }
            
            
            
            
            
        }
    }
}

