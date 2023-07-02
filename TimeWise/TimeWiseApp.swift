//
//  TimeWiseApp.swift
//  TimeWise
//
//  Created by Jake Gibbons on 30/06/2023.
//

import SwiftUI

@main
struct TimeWiseApp: App {
    @Environment(\.customColor) private var color: Binding<Color>
    @AppStorage("color") var accentColor: Color = Color.blue
    
    
        var body: some Scene {
            WindowGroup {
                WelcomeView()
                    .environment(\.customColor, $accentColor)
                
            }
        }
    }

