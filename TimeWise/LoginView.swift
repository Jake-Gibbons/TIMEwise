import SwiftUI
import AuthenticationServices
import UserNotifications

struct LoginView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @AppStorage("TermsAccepted") private var termsAccepted = false
    @State private var isLoggedIn = false
    @State private var infoSheet = false
    @State private var username = ""
    @State private var password = ""
    @State private var showErrorMessage = false
    @State private var isLoggingIn = false
    @State private var forgotPassword = false
    @State private var navigateToPartySetup = false
    @State private var navigateToSettings = false
    @State private var isPasswordVisible = false // Added state variable for password visibility
    
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                //------------------ Logo Section -----------------
                VStack {
                    HStack{
                        Image(systemName: "hourglass")
                            .font(.title)
                            .foregroundColor(.accentColor)
                            .padding(.trailing, 1)
                        Text("TIME")
                            .font(.largeTitle)
                            .fontWeight(.black)
                            .foregroundColor(Color.accentColor)
                            .padding(.trailing, -5.0)
                            .scaledToFill()
                        
                        Text("wise")
                            .font(.largeTitle)
                            .fontWeight(.regular)
                            .foregroundColor(Color.accentColor)
                            .padding(.leading, -5.0)
                    }
                    .padding(.bottom, -20)
                    
                    HStack{
                        Image(systemName: "hourglass")
                            .font(.title)
                            .foregroundColor(.accentColor)
                            .padding(.trailing, 1)
                        Text("TIME")
                            .font(.largeTitle)
                            .fontWeight(.black)
                            .foregroundColor(Color.accentColor)
                            .padding(.trailing, -5.0)
                            .scaledToFill()
                        
                        Text("wise")
                            .font(.largeTitle)
                            .fontWeight(.regular)
                            .foregroundColor(Color.accentColor)
                            .padding(.leading, -5.0)
                    }
                    .padding(.top, -20)
                    .rotation3DEffect(.degrees(180), axis: (x: 1, y: 0, z: 0))
                    .opacity(0.7)
                    .mask(LinearGradient(gradient: Gradient(colors: [Color.black.opacity(1), Color.black.opacity(0)]), startPoint: .top, endPoint: .bottom)
                    )
                }
                .scaleEffect(2)
                //------------------------------------------------
                
                Spacer()
                
                // Form fields for name and password
                TextFieldWithIcon(systemName: "person", placeholder: "Username", text: $username)
                SecureFieldWithEye(iconName: isPasswordVisible ? "eye.fill" : "eye.slash.fill", placeholder: "Password", text: $password, isSecure: isPasswordVisible)
                
                
                // "Forgot Password" option
                Button(action: {
                    // Perform forgot password logic
                    forgotPassword = true
                    NavigationLink(
                        destination: SignupView(),
                        isActive: $forgotPassword
                    ){
                        EmptyView()
                    }
                }) {
                    Text("Forgot Password")
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 7.0)
                }
                .buttonStyle(.borderless)
                .buttonBorderShape(.capsule)
                .padding([.leading, .bottom, .trailing])
                
                Spacer()
                
                
                // Login button
                Button(action: login) {
                    if isLoggingIn {
                        ProgressView() // Show the loading spinner
                    } else {
                        Text("Sign In")
                            .font(.title3)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 7.0)
                    }
                }
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.capsule)
                .padding([.leading, .bottom, .trailing])
                .disabled(isLoggingIn)
                .opacity(isLoggingIn ? 0.5 : 1)
                
                VStack {
                    SignInWithAppleButton(.signIn, onRequest: { request in
                        request.requestedScopes = [.fullName, .email]
                    }, onCompletion: { result in
                        switch result {
                        case .success(_):
                            print("Authorization Successful")
                        case .failure(let error):
                            print("Authorization Failure: " + error.localizedDescription)
                        }
                    })
                    .signInWithAppleButtonStyle(colorScheme == .dark ? .white : .black)
                    .frame(height: 50)
                    .frame(minWidth: 140, minHeight: 44)
                    .cornerRadius(.greatestFiniteMagnitude)
                    .padding(.horizontal, 15.0)
                    .disabled(true)
                    
                }
                
                
                
                if showErrorMessage == true {
                    Text("Sign In Failed. Try Again.")
                        .foregroundColor(.red)
                        .padding()
                        .transition(.opacity)
                        .animation(.easeInOut(duration: 0.5))
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                withAnimation {
                                    showErrorMessage = false
                                }
                            }
                        }
                }
            }
            .padding()
            .navigationBarTitle("Sign In", displayMode: .large)
            .navigationBarItems(trailing:
                                    Button(action: {
                navigateToSettings = true
            }) {
                Image(systemName: "gearshape")
            }
                .background(
                    NavigationLink(destination: SettingsView(), isActive: $navigateToSettings) {
                        EmptyView()
                    }
                        .hidden()
                )
            )
            
            
            .background(
                NavigationLink(
                    destination: PartySetupView(),
                    isActive: $navigateToPartySetup
                ) {
                    EmptyView()
                }
                    .hidden()
            )
        }
        .onAppear {
            checkLoggedInUser()
        }
    }
    
    func login() {
        isLoggingIn = true
        
        let user = User(username: username)
        storeLoggedInUser(user)
        
        // Simulating login delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            isLoggingIn = false
            
            if username == UserDefaults.standard.string(forKey: "UserName") &&
                password == UserDefaults.standard.string(forKey: "UserPassword") {
                navigateToPartySetup = true
                requestNotificationAuthorization()
            } else {
                showErrorMessage = true
            }
        }
    }
    
    func storeLoggedInUser(_ user: User) {
        // Store the user information using UserDefaults or a database
        // Example using UserDefaults:
        UserDefaults.standard.set(user.username, forKey: "LoggedInUsername")
    }
    
    private var loggedInUsername: String {
        UserDefaults.standard.string(forKey: "LoggedInUsername") ?? ""
    }
    
    private func checkLoggedInUser() {
        // Check if a user is logged in, e.g., by accessing the stored user information
        isLoggedIn = !loggedInUsername.isEmpty
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

struct TextFieldWithIcon: View {
    let systemName: String
    let placeholder: String
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: systemName)
                .padding(.leading)
                .foregroundColor(.secondary)
            TextField(placeholder, text: $text)
                .textFieldStyle(.plain)
                .padding()
        }
        .background(Material.ultraThick)
        .background(Color.accentColor)
        .cornerRadius(30)
    }
}

struct SecureFieldWithEye: View {
    let iconName: String
    let placeholder: String
    @Binding var text: String
    @State private var isSecure: Bool
    
    init(iconName: String, placeholder: String, text: Binding<String>, isSecure: Bool) {
        self.iconName = iconName
        self.placeholder = placeholder
        self._text = text
        self._isSecure = State(initialValue: isSecure)
    }
    
    var body: some View {
        HStack {
            Image(systemName: "key")
                .padding(.leading)
                .foregroundColor(.secondary)
            if isSecure {
                SecureField(placeholder, text: $text)
                    .padding()
            } else {
                TextField(placeholder, text: $text)
                    .padding()
            }
            Button(action: {
                isSecure.toggle()
            }) {
                Image(systemName: isSecure ? "eye.fill" : "eye.slash.fill")
                    .padding(.trailing)
            }
        }
        .background(Material.ultraThick)
        .background(Color.accentColor)
        .cornerRadius(30)
    }
}

private func requestNotificationAuthorization() {
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
        if let error = error {
            print("Error requesting notification authorization: \(error.localizedDescription)")
        } else {
            if granted {
                print("Notification authorization granted")
            } else {
                print("Notification authorization declined")
            }
        }
    }
}
