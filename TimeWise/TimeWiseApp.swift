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
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    
    var body: some Scene {
        WindowGroup {
            WelcomeView()
                .environment(\.customColor, $accentColor)
                .preferredColorScheme(isDarkMode ? .dark : .light)
            
            //                if darkModePicker == "on" {
            //                    colorScheme == .dark
            //                } else if darkModePicker == "off" {
            //                    colorScheme == .light
            //                } else if darkModePicker == "System" {
            //
            //                } else {
            //
            //                }
            
            
            
            
        }
    }
    
    class AppDelegate: NSObject, UIApplicationDelegate {
        func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
            // Perform any necessary setup
            
            return true
        }
        
        func applicationDidBecomeActive(_ application: UIApplication) {
            if let window = application.windows.first,
               let rootViewController = window.rootViewController as? UINavigationController,
               let countdownTimerView = rootViewController.viewControllers.first(where: { $0 is CountdownTimerView }) {
                // The CountdownTimerView is already in the navigation stack, so do nothing
            } else {
                if let window = application.windows.first {
                    // Create the CountdownTimerView wrapped inside a UIHostingController
                    let countdownTimerView = CountdownTimerView(guests: ["Guest 1", "Guest 2"], ghbAmounts: ["Guest 1": "1.4", "Guest 2": "2.0"])
                    let hostingController = UIHostingController(rootView: countdownTimerView)
                    
                    // Create a UINavigationController with the hostingController as the root view controller
                    let navigationController = UINavigationController(rootViewController: hostingController)
                    
                    window.rootViewController = navigationController
                }
            }
        }

    }
}
        
