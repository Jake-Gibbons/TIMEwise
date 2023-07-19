import SwiftUI
import CoreLocation
import MapKit
import SceneKit

class LocationDelegate: NSObject, CLLocationManagerDelegate {
    private let completion: (String?) -> Void
    
    init(completion: @escaping (String?) -> Void) {
        self.completion = completion
        super.init()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            self.completion(nil)
            return
        }
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { [self] placemarks, error in
            guard error == nil, let placemark = placemarks?.first else {
                self.completion(nil)
                return
            }
            
            let cityName = placemark.locality ?? ""
            self.completion(cityName)
            print(cityName)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.completion(nil)
    }
}


struct PartySetupView: View {
    @AppStorage("TermsAccepted") private var termsAccepted = false
    @SceneStorage("partySetupView") private var partySetupView: String?
    
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
    @State private var partyUUID = UUID()
    
    @State private var currentLocation: String = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    Section(header: Text("Enter party details")) {
                        HStack {
                            TextField("Enter Location", text: $cityName)
                                .textFieldStyle(PlainTextFieldStyle())
                            HStack {
                                Button(action: {
                                   // requestLocation()
                                }) {
                                    if isFetchingLocation {
                                        ProgressView()
                                            .tint(Color.white)
                                            .padding(5)
                                    } else {
                                        HStack {
                                            Image(systemName: "location.fill")
                                                .foregroundColor(.white)
                                                .padding(5)
//                                            Text("GET")
//                                                .foregroundColor(.white)
//                                                .font(.caption)
//                                                .fontWeight(.black)
//                                                .padding(.leading, -5)
//                                                .padding([.top, .trailing, .bottom], 5)
                                        }
                                    }
                                }
                            }
                            .background(Color.accentColor)
                            .cornerRadius(10)
                        }
                    }
                    
                    
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                    DatePicker("Start Time", selection: $startTime, displayedComponents: .hourAndMinute)
                    DatePicker("End Time", selection: $endTime, displayedComponents: .hourAndMinute)
                    
                    //                    Section(header: Text("Set GHB Limit")) {
                    //                        Stepper(value: $ghbLimit, in: 0.0...3.0, step: 0.1) {
                    //                            Text("\(ghbLimit, specifier: "%.1f") ml")
                    //                        }
                    //                        if ghbLimit > 1.5 {
                    //                            HStack {
                    //                                Image(systemName: "exclamationmark.triangle")
                    //                                    .foregroundColor(.red)
                    //                                    .padding(.all, 0.1)
                    //                                Text("   Warning: Limit exceeds 1.5 ml").foregroundColor(.red)
                    //                            }
                    //                        } else if ghbLimit <= 1.5 {
                    //                            HStack {
                    //                                Image(systemName: "checkmark.circle")
                    //                                    .foregroundColor(.green)
                    //                                Text("   Limit is within range").foregroundColor(.green)
                    //                            }
                    //                        }
                    //                    }
                    //
                    //                    Section(header: Text("Additional Substances")) {
                    //                        Toggle("Charlie", isOn: $C)
                    //                        Toggle("Mike", isOn: $MK)
                    //                        Toggle("Tina", isOn: $T)
                    //                        Toggle("Viagra", isOn: $V)
                    //                    }
                    
                    Section(header: Text("")) {
                        NavigationLink(
                            destination: GuestManagementView(),
                            isActive: $guestManagement
                        ) {
                            Button(action: {
                                guestManagement = true
                            }) {
                                Text("Save Party ")
                            }
                        }
                        .background(
                            Group {
                                if guestManagement {
                                    NavigationLink(
                                        destination: EmptyView(),
                                        isActive: $guestManagement
                                    ) {
                                        EmptyView()
                                    }
                                    .hidden()
                                }
                            }
                        )
                    }
//                    Section(header: Text("")) {
//                        HStack {
//                            Text("Party ID: ")
//                                .font(.caption)
//                                .foregroundColor(Color.secondary)
//                            Text(partyUUID.uuidString)
//                                .font(.caption)
//                                .foregroundColor(Color.secondary)
//                                .textSelection(.allowsSelection)
//                        }
//                    }
                    
                    
                    
                }
                .navigationBarTitle("Party Setup")
                .toolbarBackground(Color.accentColor, for: .navigationBar)
                .navigationBarItems(trailing:
                                        Button(action: {
                    navigateToSettings = true
                }) {
                    Image(systemName: "gearshape")
                        .foregroundColor(Color.accentColor)
                }
                    .background(
                        NavigationLink(destination: SettingsView(), isActive: $navigateToSettings) {
                            EmptyView()
                        }
                            .hidden()
                    )
                        .buttonStyle(PlainButtonStyle())
                )
            }
            
        }
    }
    
    private let locationManager = CLLocationManager()
    
//    private func requestLocation() {
//        isFetchingLocation = true
//        
//        let delegate = LocationDelegate { cityName in
//            DispatchQueue.main.async {
//                if let cityName = cityName {
//                    self.currentLocation = cityName
//                } else {
//                    self.currentLocation = "Location Unavailable"
//                }
//                self.isFetchingLocation = false
//            }
//        }
//        locationManager.delegate = delegate
//
//        if locationManager.authorizationStatus == .authorizedWhenInUse {
//            locationManager.startUpdatingLocation() {
//                if let cityName = $0.city {
//                    self.currentLocation = cityName
//                } else {
//                    self.currentLocation = "Location Unavailable"
//                }
//            }
//        } else {
//            locationManager.requestWhenInUseAuthorization()
//            while locationManager.authorizationStatus != .authorizedWhenInUse {
//                DispatchQueue.main.async {
//                    // Show an alert to the user that they need to grant location permissions
//                }
//            }
//            locationManager.startUpdatingLocation() {
//                if let cityName = $0.city {
//                    self.currentLocation = cityName
//                } else {
//                    self.currentLocation = "Location Unavailable"
//                }
//            }
//        }
//    }
//
}


struct PartySetupView_Previews: PreviewProvider {
    static var previews: some View {
        PartySetupView()
    }
}
