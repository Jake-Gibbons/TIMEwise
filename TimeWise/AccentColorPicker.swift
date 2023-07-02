//
//  AccentColorPicker.swift
//  AccentColorPicker
//
//  Created by Alex Lenkei on 1/25/23.
//

import SwiftUI

struct AccentColorPicker: View {
    
    @ObservedObject var viewModel: AccentColorManager

    var body: some View {
        NavigationStack{
            List {
                Picker(selection: $viewModel.accentColor, label: EmptyView()) {
                    ForEach(viewModel.zippedColors, id:\.1) { option in
                        HStack(spacing: 20) {
                            Circle()
                                .fill(option.0)
                                .frame(width: 15, height: 15)
                                .padding(.vertical, 0)
                            Text(option.1)
                        }.tag(option.1)
                    }
                    .onChange(of: viewModel.accentColor, perform: { value in
                        viewModel.convertColor(color: value)
                    })
                }
                .pickerStyle(InlinePickerStyle())
            }
            .listStyle(InsetGroupedListStyle())
            
        }
        .navigationTitle("Accent Color")

    }

}


struct AccentColorPicker_Previews: PreviewProvider {
    static var previews: some View {
        AccentColorPicker(viewModel: AccentColorManager())
    }
}