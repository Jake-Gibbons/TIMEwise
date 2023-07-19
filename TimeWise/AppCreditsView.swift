//
//  AppCreditsView.swift
//  TimeWise
//
//  Created by Jake Gibbons on 12/07/2023.
//

import SwiftUI

struct AppCreditsView: View {
    
    @State private var animationAmount: CGFloat = 1
    @Environment(\.openURL) var openURL
    
    
    var body: some View {
        NavigationStack{
            VStack{
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
                    .padding(.top, 20)
                    
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
                
                //                    Text("Placeholder tagline")
                //                        .font(.caption)
                
                .scaleEffect(2)
                
                
                HStack {
                    Text("Built with")
                    ZStack {
                        Image(systemName: "heart.fill")
                            .foregroundColor(.accentColor)
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
                .padding(.top, 30)
                
                Spacer()
                
                Button(action:{
                    openURL(URL(string: "https://github.com/Jake-Gibbons/TIMEwise")!)
                }) {
                    HStack{
                        ZStack{
                            RoundedRectangle(cornerRadius: 20)
                                .frame(width: 100, height: 50)
                                .foregroundColor(Color.accentColor)
                            Text("GitHub")
                                .font(.title2)
                                .foregroundColor(Color.white)
                        }
                        
                    }
                }
                
                Spacer()
                
                VStack{
                    NavigationLink(destination: LoginView()) {
                        Text("Contact the Developer")
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 7)
                            .foregroundColor(Color.white)
                        
                    }
                    .buttonBorderShape(.capsule)
                    .buttonStyle(.borderedProminent)
                    .foregroundColor(Color.accentColor)
                    .padding()
                    
                    NavigationLink(destination: LoginView()) {
                        Text("Donate to the Developer")
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 7)
                            .foregroundColor(Color.white)
                    }
                    .buttonBorderShape(.capsule)
                    .buttonStyle(.borderedProminent)
                    .foregroundColor(Color.accentColor)
                    .padding(.horizontal)
                }
                
                Text("Copyright ©2023 Jake Gibbons")
                    .foregroundColor(Color.secondary)
                    .font(.caption)
                    .padding(.top, 10)
                
                
            }
        }
        .navigationTitle(Text("App Credits"))
        .toolbarBackground(Color.accentColor, for: .navigationBar)
    }
    
}


struct AppCreditsView_Previews: PreviewProvider {
    static var previews: some View {
        AppCreditsView()
    }
}

