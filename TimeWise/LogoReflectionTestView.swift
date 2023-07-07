//
//  LogoReflectionTestView.swift
//  TimeWise
//
//  Created by Jake Gibbons on 03/07/2023.
//

import SwiftUI



private struct GroundReflectionViewModifier: ViewModifier {
    let offsetY: CGFloat
    func body(content: Content) -> some View {
        
        HStack{
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
        
        
        
        content // base content
            .background( // using background to duplicate the content with the View
                content // using the same content here to duplicate
                    // this will create a flip in the axis Y with the anchor in the bottom
                    .scaleEffect(x: 1.0, y: -1.0, anchor: .bottom)
                    // adding the opacity
                    .opacity(0.3)
                    // and receiving the offsetY as parameter
                    .offset(y: offsetY)
            )
    }
}

struct LogoReflectionTestView_Previews: PreviewProvider {
    static var previews: some View {
        
        //------------------ Logo Section -----------------
        VStack {
            HStack{
                Image(systemName: "hourglass")
                    .font(.title)
                    .foregroundColor(.accentColor)
                    .padding(.trailing, -10)
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
                        .padding(.trailing, -10)
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
        }.scaleEffect(2)
        //------------------------------------------------

        
    }
}
