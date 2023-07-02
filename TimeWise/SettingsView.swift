import SwiftUI

struct SettingsView: View {
    
    @Environment(\.customColor) private var color: Binding<Color>
    @AppStorage("DarkMode") private var darkMode = DarkMode.system.rawValue
    @AppStorage("AppNotifications") private var appNotifications = true
    @AppStorage("TimerSounds") private var timerSounds = true
    @AppStorage("LocationPermission") private var locationPermission = false
    @AppStorage("NotificationPermission") private var notificationPermission = false
    @Environment(\.colorScheme) var colorScheme
    
    @State private var isTermsOfUseChosen = true
    
    
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
                        if colorScheme == .dark {
                            Image(systemName: "moon")
                                .foregroundColor(Color.accentColor)
                        } else {
                            Image(systemName: "sun.max")
                                .foregroundColor(Color.accentColor)
                        }
                        
                        Picker("Dark Mode", selection: $darkMode) {
                            Text("Yes").tag(DarkMode.yes.rawValue)
                            Text("No").tag(DarkMode.no.rawValue)
                            Text("System").tag(DarkMode.system.rawValue)
                        }
                    }
                    
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
                }
                
                Section {
                    Button("Logout") {
                        // Perform logout action
                    }
                    .foregroundColor(Color.red)
                }
            }
            .listStyle(GroupedListStyle())
            .navigationTitle("Settings")
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
