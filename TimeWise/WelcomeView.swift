import SwiftUI
import Combine
import AuthenticationServices

struct WelcomeView: View {
    
    @Environment(\.customColor) private var color: Binding<Color>
    @Environment(\.colorScheme) var colorScheme
    @State private var animationAmount: CGFloat = 1
    @State private var infoSheet = false
    @State private var navigateToSettings = false
    
    
    var body: some View {
        NavigationStack {
            VStack {
                VStack{
                    Spacer()
                    HStack{
                        Text("TIME")
                            .font(.largeTitle)
                            .fontWeight(.black)
                            .foregroundColor(Color("AccentColor"))
                            .padding(.trailing, -5.0)
                            .scaledToFill()
                        
                        Text("wise")
                            .font(.largeTitle)
                            .fontWeight(.regular)
                            .foregroundColor(Color("AccentColor"))
                            .padding(.leading, -5.0)
                    }
                    
                    
                    Text("Placeholder tagline")
                        .font(.caption)
                    Spacer()
                }
                .scaleEffect(2)

                
                
                HStack{
                    Spacer()
                    NavigationLink(destination: LoginView()) {
                        Text("Sign In")
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 7)
                    }
                    .buttonBorderShape(.capsule)
                    .buttonStyle(.bordered)
                    .padding(.vertical)
                    .padding(.leading)
                    
                    Spacer()
                    
                    NavigationLink(destination: SignupView()) {
                        Text("Sign Up")
                            .font(.title3)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 7)
                    }
                    .buttonBorderShape(.capsule)
                    .buttonStyle(.borderedProminent)
                    .padding(.vertical)
                    .padding(.trailing)
                    
                    Spacer()
                }
                
                SignInWithAppleButton(.continue, onRequest: { request in
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
                .padding(.horizontal, 15)
                
                Spacer()
                
                HStack {
                    Text("Built with")
                    ZStack {
                        Image(systemName: "heart.fill")
                            .foregroundColor(.red)
                            .scaleEffect(animationAmount)
                            .animation(
                                Animation.spring(response: 0.2, dampingFraction: 0.3, blendDuration: 0.8)
                                    .delay(0.02)
                                    .repeatForever(autoreverses: true),
                                value: animationAmount
                            )
                            .onAppear {
                                animationAmount = 1.2
                            }
                    }
                    Text("by Jake")
                }
                Spacer()
            }
            Spacer()
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
            ) }
        .tint(color.wrappedValue)
    }
}


struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
