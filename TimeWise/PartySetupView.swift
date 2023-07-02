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
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("Enter party details")) {
                        HStack {
                            TextField("Party Location", text: Binding(
                                get: { self.cityName },
                                set: { self.cityName = $0 }
                            ), onEditingChanged: { _ in
                                // Handle editing change if needed
                            })
                            .textFieldStyle(PlainTextFieldStyle())
                            HStack{
                                Button(action: {
                                    requestLocation()
                                }) {
                                    if isFetchingLocation {
                                        ProgressView()
                                    } else {
                                        Image(systemName: "location")
                                            .foregroundColor(.white)
                                            .padding(.trailing, -2)
                                            .padding([.top, .leading, .bottom],5)
                                    }
                                }
                                Text("GET")
                                    .foregroundColor(.white)
                                    .font(.caption)
                                    .padding(.leading, -5)
                                    .padding([.top, .trailing, .bottom],5)
                            }
                            .background(Color.accentColor)
                            .cornerRadius(5)
                            
                        }
                    }
                    
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                    DatePicker("Start Time", selection: $startTime, displayedComponents: .hourAndMinute)
                    DatePicker("End Time", selection: $endTime, displayedComponents: .hourAndMinute)
                    
                    Section(header: Text("Set GHB Limit")) {
                        Stepper(value: $ghbLimit, step: 0.1) {
                            Text("\(ghbLimit, specifier: "%.1f") ml")
                        }
                        
                        if ghbLimit > 1.5 {
                            HStack {
                                Image(systemName: "exclamationmark.triangle")
                                    .foregroundColor(.red)
                                    .padding(.all, 0.1)
                                Text("   Limit is at a dangerous level. Please consider using less.")
                                    .foregroundColor(.red)
                            }
                        } else if ghbLimit <= 1.5 {
                            HStack {
                                Image(systemName: "checkmark.circle")
                                    .foregroundColor(.green)
                                Text("   Limit is within safe range")
                                    .foregroundColor(.green)
                            }
                        }
                    }
                    
                    Section(header: Text("")) {
                        Button(action: {
                            guestManagement = true
                        }) {
                            Text("Save Party Setup")
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
                .navigationBarTitle("Party Setup", displayMode: .large)
            }
        }
    }
    
    
    private func requestLocation() {
        isFetchingLocation = true
        
        let locationManager = CLLocationManager()
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


class LocationDelegate: NSObject, CLLocationManagerDelegate {
    let completion: (String?) -> Void
    
    init(completion: @escaping (String?) -> Void) {
        self.completion = completion
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let error = error {
                print("Reverse geocoding error: \(error.localizedDescription)")
                self.completion(nil)
                return
            }
            
            if let placemark = placemarks?.first {
                if let cityName = placemark.locality {
                    self.completion(cityName)
                    return
                }
            }
            
            self.completion(nil)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        completion(nil)
    }
}


struct PartySetupView_Previews: PreviewProvider {
    static var previews: some View {
        PartySetupView()
    }
}
