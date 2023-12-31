import SwiftUI
import AuthenticationServices

struct SignupView: View {
    @Environment(\.colorScheme) var colorScheme

    @AppStorage("TermsAccepted") private var termsAccepted = false
    @State private var name = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var isSignUpComplete = false
    @State private var signUpError = false
    @State private var infoSheet = false
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
                
                // Form fields for party host's name, email, and password
                    
                    HStack {
                        Image(systemName: "person")
                            .padding(.leading)
                            .foregroundColor(.secondary)
                        TextField("Username", text: $name)
                            .textFieldStyle(.plain)
                    }
                    .padding()
                    .background(Material.ultraThick)
                    .background(Color.accentColor)
                    .cornerRadius(30)

                SecureFieldWithEyeSignup(iconName: isPasswordVisible ? "eye.fill" : "eye.slash.fill", placeholder: "Password", text: $password, isSecure: !isPasswordVisible)
                    
                
                SecureFieldWithEyeSignup(iconName: isPasswordVisible ? "eye.fill" : "eye.slash.fill", placeholder: "Confirm Password", text: $confirmPassword, isSecure: !isPasswordVisible)
                
                
                Button(action: {
                    signUp()
                }) {
                    Text("Sign Up")
                        .font(.title3)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 7)
                }
                .buttonBorderShape(.capsule)
                .buttonStyle(.borderedProminent)
                .padding(.top, 50)
                .padding([.leading, .bottom, .trailing])

                
                VStack {
                    SignInWithAppleButton(.signUp, onRequest: { request in
                        request.requestedScopes = [.fullName, .email]
                    },
                    onCompletion: { result in
                        switch result {
                        case .success(_):
                            print("Authorization Successful")
                        case .failure(let error):
                            print("Authorization Failure: " + error.localizedDescription)
                        }
                    }
                    )
                    .signInWithAppleButtonStyle(colorScheme == .dark ? .white : .black)
                    .frame(height: 50)
                    .frame(minWidth: 140, minHeight: 44)
                    .cornerRadius(.greatestFiniteMagnitude)
                    .padding(.horizontal, 15)
                    .disabled(true)
                    
                }
                
                
                if isSignUpComplete {
                    Text("Sign up successful!")
                        .foregroundColor(.green)
                        .padding()
                }
                
                if signUpError {
                    Text("Sign up unsuccessful!")
                        .foregroundColor(.red)
                    Text("Please try again")
                        .foregroundColor(.red)
                        .padding()
                }
            }
            .navigationBarTitle("Sign Up", displayMode: .large)
            .padding()
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
        }
    }
    
    private func signUp() {
        if password == confirmPassword {
            UserDefaults.standard.set(name, forKey: "UserName")
            UserDefaults.standard.set(password, forKey: "UserPassword")
            isSignUpComplete = true
        } else {
            signUpError = true
        }
    }
}

struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        SignupView()
    }
}

struct SecureFieldWithEyeSignup: View {
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
            } else {
                TextField(placeholder, text: $text)
            }
            Button(action: {
                isSecure.toggle()
            }) {
                Image(systemName: isSecure ? "eye.fill" : "eye.slash.fill")
                    .padding(.trailing)
            }
        }
        .padding()
        .background(Material.ultraThick)
        .background(Color.accentColor)
        .cornerRadius(30)
    }
}

struct User {
    let username: String
    // Add other properties as needed
}
