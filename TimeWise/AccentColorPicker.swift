//
//  AccentColorPicker.swift
//  AccentColorPicker
//
//  Created by Alex Lenkei on 1/25/23.
//

import SwiftUI

struct AccentColorPicker: View {
    
    @ObservedObject var viewModel: AccentColorManager
    
    @State private var bgColor =
           Color(.sRGB, red: 0.98, green: 0.9, blue: 0.2)

    var body: some View {
        NavigationStack{
            List {
                Section(header: Text("Pre-Set Colors")){
                    Picker(selection: $viewModel.accentColor, label: EmptyView()) {
                        ForEach(viewModel.zippedColors, id:\.1) { option in
                            HStack(spacing: 20) {
                                Circle()
                                    .fill(option.0)
                                    .frame(width: 20, height: 20)
                                    .padding(.vertical, 0)
                                    .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                                Text(option.1)
                            }.tag(option.1)
                        }
                        .onChange(of: viewModel.accentColor, perform: { value in
                            viewModel.convertColor(color: value)
                        })
                    }
                }
                .pickerStyle(InlinePickerStyle())
                Section(header: Text("Custom Color")){
                    ColorPicker("Custom Accent Color", selection: $bgColor)
                        .padding(.trailing, 35)
                }
                .pickerStyle(InlinePickerStyle())
            }
            .navigationBarTitle("Accent Color", displayMode: .large)
            .listStyle(InsetGroupedListStyle())
            
        }

    }

}


struct AccentColorPicker_Previews: PreviewProvider {
    static var previews: some View {
        AccentColorPicker(viewModel: AccentColorManager())
    }
}
