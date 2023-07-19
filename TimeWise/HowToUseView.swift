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
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack {
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
                
                Spacer()
                
                if let howtoString = readHowToUse() {
                    Text("How To Use")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding()
                    
                    ScrollView(showsIndicators: true) {
                        // Use a Text view to display the terms of usage
                        Text(howtoString)
                            .font(.caption)
                            .padding()
                    }
                    .background(Material.ultraThick)
                    .background(Color.accentColor)
                    .cornerRadius(20)
                    .padding(.horizontal, 10)
                    
                } else {
                    Text("How to Use not available.")
                }
                
                Spacer()
                
                Button {
                    dismiss()
                } label: {
                    Text("Accept & Close")
                        .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 7)

                }
                .buttonBorderShape(.capsule)
                .buttonStyle(.borderedProminent)
                .padding(.horizontal, 50)
                .padding(.top, 20)
            }
        }
    }
    
    func readHowToUse() -> String? {
        let howtoFileName = "HowToUse"
        let howtoFileExtension = "txt"

        
        if let howtoURL = Bundle.main.url(forResource: howtoFileName, withExtension: howtoFileExtension),
           let howtoData = try? Data(contentsOf: howtoURL),
           let howtoString = String(data: howtoData, encoding: .utf8)
        {
            return howtoString
        }
        
        return nil
    }
}

struct HowToUseView_Previews: PreviewProvider {
    static var previews: some View {
        HowToUseView()
    }
}
