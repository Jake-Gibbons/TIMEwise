import SwiftUI

struct SettingsView: View {
    
    @Environment(\.customColor) private var color: Binding<Color>
    
    @AppStorage("isDarkMode") private var isDarkMode = false
    @AppStorage("AppNotifications") private var appNotifications = true
    @AppStorage("TimerSounds") private var timerSounds = true
    @AppStorage("LocationPermission") private var locationPermission = false
    @AppStorage("NotificationPermission") private var notificationPermission = false
    @AppStorage("DarkModePicker") private var darkModePicker = String()
    
    @State private var isTermsOfUseChosen = true
    @State private var isHowToUseChosen = true
    @State private var isLogoutChosen = true
    
    public var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Accent Colour")) {
                    HStack {
                        Image(systemName: "paintbrush")
                            .foregroundColor(Color.accentColor)
                        NavigationLink(destination: AccentColorPicker(viewModel: AccentColorManager())) {
                            Text("Accent Color")
                        }
                        
                    }
                }
                
                Section(header: Text("App Settings")) {
                    HStack {
                        if isDarkMode == true {
                            Image(systemName: "moon")
                                .foregroundColor(Color.accentColor)
                        } else {
                            Image(systemName: "sun.max")
                                .foregroundColor(Color.accentColor)
                        }
                        
                        Toggle("Dark Mode", isOn: $isDarkMode)
                    }
                    
                    //                        Picker("Dark Mode", selection: $darkModePicker) {
                    //                                Text("On").tag(darkModePicker == "On")
                    //                                Text("Off").tag(darkModePicker ==  "Off")
                    //                                Text("System").tag(darkModePicker == "System")
                    //                            }
                    
                    
                    
                    HStack {
                        Image(systemName: "bell.badge")
                            .foregroundColor(Color.accentColor)
                        Toggle("App Notifications", isOn: $appNotifications)
                    }
                    
                    HStack {
                        Image(systemName: "speaker.wave.3")
                            .foregroundColor(Color.accentColor)
                        Toggle("Timer Sounds", isOn: $timerSounds)
                    }
                }
                
                Section(header: Text("Permissions")) {
                    HStack {
                        Image(systemName: "location")
                            .foregroundColor(Color.accentColor)
                        Toggle("Location Permission", isOn: $locationPermission)
                    }
                    
                    HStack {
                        Image(systemName: "app.badge")
                            .foregroundColor(Color.accentColor)
                        Toggle("Notification Permission", isOn: $notificationPermission)
                    }
                }
                
                Section(header: Text("Legal & Extra")) {
                    HStack {
                        Image(systemName: "scroll")
                            .foregroundColor(Color.accentColor)
                        if isTermsOfUseChosen == true {
                            NavigationLink(destination: TermsOfUseView()) {
                                Text("Terms of use")
                            }
                        }
                    }
                    HStack {
                        Image(systemName: "book")
                            .foregroundColor(Color.accentColor)
                        if isHowToUseChosen == true {
                            NavigationLink(destination: HowToUseView()) {
                                Text("How to Use")
                            }
                        }
                    }
                }
                
                Section {
                    HStack{
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                            .foregroundColor(Color.red)
                        if isLogoutChosen == true {
                            NavigationLink(destination: WelcomeView()) {
                                Text("Logout")
                                    .foregroundColor(Color.red)
                                
                            }
                        }
                    }
                }
            }
                .listStyle(GroupedListStyle())
                .navigationBarTitle("Settings", displayMode: .large)
                .toolbarBackground(Color.accentColor, for: .navigationBar)
            }
            .tint(color.wrappedValue)
        }
    
    public func didSelectAccentColor(_ color: Color) {
        // Handle the accent color selection here
        // For example, you can save the selected color in user defaults or apply it to the app's appearance
    }
}

enum DarkMode: Int {
    case yes = 0
    case no = 1
    case system = 2
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
