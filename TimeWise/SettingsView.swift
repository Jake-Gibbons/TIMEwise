import SwiftUI
import SceneKit


struct SettingsView: View {
    
    @Environment(\.customColor) private var color: Binding<Color>
    @Environment(\.colorScheme) var colorScheme
    
    @AppStorage("TermsAccepted") private var termsAccepted = false
    @AppStorage("DarkMode") private var darkMode = DarkMode.system
    
    @AppStorage("isDarkMode") private var isDarkMode = false
    @AppStorage("AppNotifications") private var appNotifications = true
    @AppStorage("TimerSounds") private var timerSounds = true
    @AppStorage("LocationPermission") private var locationPermission = false
    @AppStorage("NotificationPermission") private var notificationPermission = false
    @AppStorage("ShowingDebugSettings") private var showingDebugSettings = false
    @AppStorage("PartyUUID") private var partyUUID: String = UUID().uuidString
    
    @SceneStorage("SettingsView.selection") private var selection: String?

    @State private var isTermsOfUseChosen = true
    @State private var isHowToUseChosen = true
    @State private var isLogoutChosen = true
    @State private var navigateToCredits = false
    
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
                    //                    HStack {
                    //                        if isDarkMode == true {
                    //                            Image(systemName: "moon")
                    //                                .foregroundColor(Color.accentColor)
                    //                        } else {
                    //                            Image(systemName: "sun.max")
                    //                                .foregroundColor(Color.accentColor)
                    //                        }
                    //
                    //                           Toggle("Dark Mode", isOn: $isDarkMode)
                    //                    }
                    
                    HStack {
                        if isDarkMode == true {
                            Image(systemName: "moon")
                                .foregroundColor(Color.accentColor)
                        } else {
                            Image(systemName: "sun.max")
                                .foregroundColor(Color.accentColor)
                        }
                        
                        Picker("Dark Mode", selection: $darkMode) {
                            Text("On").tag(DarkMode.yes)
                            Text("Off").tag(DarkMode.no)
                            Text("System").tag(DarkMode.system)
                        }
                        .onChange(of: darkMode) { value in
                            switch value {
                            case .yes:
                                isDarkMode = true
                            case .no:
                                isDarkMode = false
                            case .system:
                                if colorScheme == .dark {
                                    isDarkMode = true
                                } else {
                                    isDarkMode = false
                                }
                            }
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
                    HStack{
                        Image(systemName: "gear")
                            .foregroundColor(Color.accentColor)
                        Button("Open Settings") {
                            // Get the settings URL and open it
                            if let url = URL(string: UIApplication.openSettingsURLString) {
                                UIApplication.shared.open(url)
                            }
                        }
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(Color.gray)
                            .font(.footnote)
                            .fontWeight(.semibold)
                            .opacity(0.7)
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
                
                Section(header: Text("Debug Settings")) {
                    HStack{
                        Image(systemName: "ant")
                            .foregroundColor(Color.accentColor)
                        Toggle("Debug Settings", isOn: $showingDebugSettings.animation())
                    }
                    
                    if showingDebugSettings {
                        HStack{
                            Image(systemName: "01.circle")
                                .font(.title3)
                                .foregroundColor(Color.accentColor)
                            VStack{
                                Text("Terms Accepted")
                                    .foregroundColor(Color.secondary)
                                    .font(.caption)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text("\(String(termsAccepted))")
                                    .foregroundColor(Color.secondary)
                                    .font(.caption)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                        HStack{
                            Image(systemName: "02.circle")
                                .font(.title3)
                                .foregroundColor(Color.accentColor)
                            VStack{
                                Text("Current Party UUID")
                                    .foregroundColor(Color.secondary)
                                    .font(.caption)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .lineLimit(0)
                                Text("\(String(partyUUID))")
                                    .foregroundColor(Color.secondary)
                                    .font(.caption)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                        HStack{
                            Image(systemName: "03.circle")
                                .font(.title3)
                                .foregroundColor(Color.accentColor)
                            VStack{
                                Text("settingsView")
                                    .foregroundColor(Color.secondary)
                                    .font(.caption)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .lineLimit(0)
                            }
                        }
                    }
                }
            }
            
            .listStyle(GroupedListStyle())
            .navigationBarTitle("Settings", displayMode: .large)
            .navigationBarItems(trailing:
                                    Button(action: {
                navigateToCredits = true
            }) {
                Image(systemName: "info.circle")
            }
                .background(
                    NavigationLink(destination: AppCreditsView(), isActive: $navigateToCredits) {
                        EmptyView()
                    }
                        .hidden()
                )
            )
            .onContinueUserActivity("SettingsView.selection", perform: <#T##(NSUserActivity) -> ()#>)
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
    @SceneStorage("SettingsView.selection") static var selection: String?

    static var previews: some View {
        SettingsView()
    }
}
