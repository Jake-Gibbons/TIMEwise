//
//  TermsOfUseView.swift
//  SeshBuddy
//
//  Created by Jake Gibbons on 30/06/2023.
//
import SwiftUI

struct TermsOfUseView: View {
    @State private var animationAmount: CGFloat = 1
    @State private var isAcceptPressed = false

    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                HStack {
                    Spacer()
                    Image("AppLogo") // Replace with the name of your logo image asset
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding()
                    Spacer()
                }
                
                Spacer()
                
                HStack {
                    Text("Built with")
                    ZStack {
                        Image(systemName: "heart")
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
                
                if let termsString = readTermsOfUse() {
                    Text("Terms of Usage")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding()
                    
                    ScrollView {
                        // Use a Text view to display the terms of usage
                        Text(termsString)
                            .font(.caption)
                            .padding()
                    }
                } else {
                    Text("Terms of Use not available.")
                }
                
                Spacer()
                
                Button(action: {
                    NavigationLink(
                        destination: SettingsView(),
                        isActive: $isAcceptPressed
                    ){
                        EmptyView()
                    }
                }) {
                    Text("Accept & Close")
                        .font(.headline)
                        .padding(.all, 5)
                }
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.capsule)
            }
        }
    }
    
    func readTermsOfUse() -> String? {
        let termsFileName = "Terms"
        let termsFileExtension = "txt"
        
        if let termsURL = Bundle.main.url(forResource: termsFileName, withExtension: termsFileExtension),
           let termsData = try? Data(contentsOf: termsURL),
           let termsString = String(data: termsData, encoding: .utf8) {
            return termsString
        }
        
        return nil
    }
}

struct TermsOfUseView_Previews: PreviewProvider {
    static var previews: some View {
        TermsOfUseView()
    }
}
