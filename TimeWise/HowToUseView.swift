//
//  TermsOfUseView.swift
//  SeshBuddy
//
//  Created by Jake Gibbons on 30/06/2023.
//
import SwiftUI

struct HowToUseView: View {
    
    @State private var animationAmount: CGFloat = 1
    @State private var isAcceptPressed = false
    
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
                //------------------------------------------------
                
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
                
                if let termsString = readHowToUse() {
                    Text("How To Use")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding()
                    
                    ScrollView(showsIndicators: true) {
                        // Use a Text view to display the terms of usage
                        Text(termsString)
                            .font(.caption)
                            .padding()
                    }
                    .background(Material.ultraThick)
                    .background(Color.accentColor)
                    
                } else {
                    Text("How to Use not available.")
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
    
    func readHowToUse() -> String? {
        let termsFileName = "HowtoUse"
        let termsFileExtension = "txt"
        
        if let termsURL = Bundle.main.url(forResource: termsFileName, withExtension: termsFileExtension),
           let termsData = try? Data(contentsOf: termsURL),
           let termsString = String(data: termsData, encoding: .utf8) {
            return termsString
        }
        
        return nil
    }
}

struct HowToUseView_Previews: PreviewProvider {
    static var previews: some View {
        HowToUseView()
    }
}
