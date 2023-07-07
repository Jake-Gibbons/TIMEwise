import SwiftUI
import CoreLocation
import MapKit

struct PartySetupView: View {
    @AppStorage("TermsAccepted") private var termsAccepted = false
    @State private var infoSheet = false
    @State private var partyName = ""
    @State private var date = Date()
    @State private var startTime = Date()
    @State private var endTime = Date()
    @State private var ghbLimit = 1.0
    @State private var guestManagement = false
    @State private var cityName = ""
    @State private var isFetchingLocation = false
    @State private var navigateToSettings = false
    @State private var C = false
    @State private var MK = false
    @State private var T = false
    @State private var V = false

    private let locationManager = CLLocationManager()

    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    Section(header: Text("Enter party details")) {
                        HStack {
                            TextField("Party Location", text: $cityName)
                                .textFieldStyle(PlainTextFieldStyle())
                            HStack {
                                Button(action: {
                                    requestLocation()
                                }) {
                                    if isFetchingLocation {
                                        ProgressView()
                                            .tint(Color.white)
                                            .padding(3)
                                    } else {
                                        HStack {
                                            Image(systemName: "location")
                                                .foregroundColor(.white)
                                                .padding(.trailing, -2)
                                                .padding([.top, .leading, .bottom], 5)
                                            Text("GET")
                                                .foregroundColor(.white)
                                                .font(.caption)
                                                .fontWeight(.bold)
                                                .padding(.leading, -5)
                                                .padding([.top, .trailing, .bottom], 5)
                                        }
                                        .padding(3)
                                    }
                                }
                            }
                            .background(Color.accentColor)
                            .cornerRadius(5)
                        }
                    }
                    
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                    DatePicker("Start Time", selection: $startTime, displayedComponents: .hourAndMinute)
                    DatePicker("End Time", selection: $endTime, displayedComponents: .hourAndMinute)
                    
                    Section(header: Text("Set GHB Limit")) {
                        Stepper(value: $ghbLimit, in: 0.0...3.0, step: 0.1) {
                            Text("\(ghbLimit, specifier: "%.1f") ml")
                        }
                        if ghbLimit > 1.5 {
                            HStack {
                                Image(systemName: "exclamationmark.triangle")
                                    .foregroundColor(.red)
                                    .padding(.all, 0.1)
                                Text("   Warning: Limit exceeds 1.5 ml").foregroundColor(.red)
                            }
                        } else if ghbLimit <= 1.5 {
                            HStack {
                                Image(systemName: "checkmark.circle")
                                    .foregroundColor(.green)
                                Text("   Limit is within range").foregroundColor(.green)
                            }
                        }
                    }
                    
                    Section(header: Text("Additional Substances")) {
                        Toggle("Charlie", isOn: $C)
                        Toggle("Mike", isOn: $MK)
                        Toggle("Tina", isOn: $T)
                        Toggle("Viagra", isOn: $V)
                    }
                    
                    Section(header: Text("")) {
                        Button(action: {
                            guestManagement = true
                        }) {
                            Text("Save Party")
                        }
                        .background(
                            NavigationLink(
                                destination: GuestManagementView(),
                                isActive: $guestManagement
                            ) {
                                EmptyView()
                            }
                        )
                    }
                }
                .navigationBarTitle("Party Setup")
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
    
    private func requestLocation() {
        isFetchingLocation = true
        
        let delegate = LocationDelegate { cityName in
            DispatchQueue.main.async {
                self.cityName = cityName ?? ""
                self.isFetchingLocation = false
            }
        }
        locationManager.delegate = delegate
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
}

struct PartySetupView_Previews: PreviewProvider {
    static var previews: some View {
        PartySetupView()
    }
}
