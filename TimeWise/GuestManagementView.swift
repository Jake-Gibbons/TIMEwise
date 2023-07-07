import SwiftUI

struct AddGuestSheetView: View {
    
    @Binding var isPresented: Bool
    @State private var newGuestGHBAmount: Double = 1.0
    @State private var navigateToSettings = false
    
    let newGuestName: Binding<String>
    let addGuest: () -> Void
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack{
                    Image(systemName: "person")
                        .padding(.leading, 20.0)
                        .foregroundStyle(.secondary)
                    TextField("Guest Name", text: newGuestName)
                        .textFieldStyle(PlainTextFieldStyle())
                        .padding(.leading, 0.0)
                }
                HStack {
                    Image(systemName: "mug")
                        .padding(.leading, 20.0)
                        .foregroundStyle(.secondary)
                    
                    Stepper(
                        value: $newGuestGHBAmount,
                        step: 0.1,
                        onEditingChanged: { _ in },
                        label: {
                            Text("\(newGuestGHBAmount, specifier: "%.1f") ml")
                        }
                    )
                    .padding()
                }
                
                Button(action: {
                    addGuest()
                    isPresented = false
                }) {
                    Text("Add Guest")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.all, 5.0)
                }
                .buttonBorderShape(.capsule)
                .buttonStyle(.borderedProminent)
                .padding(.bottom, 0.0)
                .padding(.horizontal)
                .padding(.top)
                
                Button(action: {
                    isPresented = false
                }) {
                    Text("Cancel")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.all, 5.0)
                }
                .buttonBorderShape(.capsule)
                .buttonStyle(.bordered)
                .padding(.top, 0.0)
                .padding(.horizontal)
                
            }
            .navigationTitle("Add Guest")
            .navigationBarItems(trailing:
                                    Button(action: {
                isPresented = false
            }) {
                Image(systemName: "xmark")
                    .font(.body)
            }
            )
        }
    }
}

struct GuestManagementView: View {
    @AppStorage("TermsAccepted") private var termsAccepted = false
    @State private var infoSheet = false
    @State private var showAddGuestSheet = false
    @State private var navigateToSettings = false
    
    @State private var hostName = ""
    @State private var newGuestName = ""
    @State private var newGuestGHBAmount: Double = 1.0
    @State private var guests: [Guest] = []
    @State private var isPartySaved = false
    
    struct Guest: Identifiable {
        let id = UUID()
        var name: String
        var GHBAmount: Double
        var timerCountdown: Int
        var timer: Timer?
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Host Name")) {
                    TextField("Host Name", text: $hostName)
                        .textFieldStyle(PlainTextFieldStyle())
                }
                
                Section(header: Text("Guests")) {
                    HStack {
                        TextField("Guest Name", text: $newGuestName)
                            .textFieldStyle(PlainTextFieldStyle())
                        Button(action: {
                            showAddGuestSheet = true
                        }) {
                            Image(systemName: "plus.circle")
                                .font(.title3)
                        }
                    }
                    
                    List {
                        ForEach(guests) { guest in
                            Text(guest.name)
                        }
                        .onDelete(perform: deleteGuests)
                    }
                }
                
                Section {
                    Button(action: {
                        saveParty()
                        isPartySaved = true // Set isPartySaved to true
                    }) {
                        Text("Save Guest List")
                    }
                    .background(
                        Group { // Wrap in a Group
                            NavigationLink(destination: CountdownTimerView(guests: guests.map(\.name), ghbAmounts: createGHBAmounts()), isActive: $isPartySaved) {
                                EmptyView()
                            }
                        }
                            .hidden()
                        
                    )
                }
            }
            .navigationBarTitle("Guest Management", displayMode: .large)
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $showAddGuestSheet) {
                AddGuestSheetView(isPresented: $showAddGuestSheet,
                                  newGuestName: $newGuestName,
                                  addGuest: addGuest)
                .presentationDetents([.medium])
                .presentationBackground(.ultraThinMaterial)
                .presentationBackgroundInteraction(.disabled)
                
            }
            
            if isPartySaved == true {
                let guestNames = guests.map { $0.name } // Extract guest names
                NavigationLink(
                    destination: CountdownTimerView(guests: guests.map(\.name), ghbAmounts: createGHBAmounts()),
                    isActive: $isPartySaved,
                    label: { EmptyView() }
                )
                .hidden()
            }
            
        }
        .onAppear {
            hostName = UserDefaults.standard.string(forKey: "UserName") ?? ""
        }
        .navigationBarTitle("Guest Management", displayMode: .large)
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
    
    
    
    private func addGuest() {
        guard !newGuestName.isEmpty else { return }
        
        let newGuest = Guest(name: newGuestName,
                             GHBAmount: newGuestGHBAmount,
                             timerCountdown: 0,
                             timer: nil)
        guests.append(newGuest)
        
        newGuestName = ""
        newGuestGHBAmount = 1.0
    }
    
    
    private func deleteGuests(at offsets: IndexSet) {
        guests.remove(atOffsets: offsets)
    }
    
    private func saveParty() {
        print("Party details and guests saved!")
        isPartySaved = true
    }
    
    private func createGHBAmounts() -> [String: String] {
        var ghbAmounts: [String: String] = [:]
        
        for guest in guests {
            ghbAmounts[guest.name] = "\(guest.GHBAmount)"
        }
        
        return ghbAmounts
    }
} 


struct GuestManagementView_Previews: PreviewProvider {
    static var previews: some View {
        GuestManagementView()
    }
}
