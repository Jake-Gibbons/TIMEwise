//
//  PartySelectorView.swift
//  TimeWise
//
//  Created by Jake Gibbons on 09/07/2023.
//

import SwiftUI

struct PartySelectorView: View {
    
    @State private var navigateToSettings = false
    @State private var newPartySetup = false

    
    public var body: some View {
        NavigationStack {
            List{
                Section(header: Text("New Party")){
                    Button(action: {
                        newPartySetup = true
                    }) {
                        Text("New Party     ")
                            .foregroundColor(Color.accentColor)
                    }
                    .background(
                        NavigationLink(
                            destination: PartySetupView(),
                            isActive: $newPartySetup
                        ) {
                            EmptyView()
                        }
                    )
                }
                
                Section(header: Text("Current Party")){
                    HStack{
                        Text("Test Party 1")
                        Spacer()
                        Text("10/10/2010")
                            .foregroundColor(Color.accentColor)
                            .font(.caption)
                    }
                }
                
                Section(header: Text("Recent Parties")){
                    Text("Test Party 1")
                    Text("Test Party 2")
                    Text("Test Party 3")
                    Text("Test Party 3")
                }
                
                Section(header: Text("Past Parties")){
                    Text("Test Party 1")
                    Text("Test Party 2")
                    Text("Test Party 3")
                    Text("Test Party 3")
                }

            }
            .listStyle(.sidebar)
            .navigationTitle(Text("Select Party"))
            .navigationBarTitleDisplayMode(.large)
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
}


struct PartySelectorView_Previews: PreviewProvider {
    static var previews: some View {
        PartySelectorView()
    }
}
