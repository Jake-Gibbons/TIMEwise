//
//  LocationDelegate.swift
//  TimeWise
//
//  Created by Jake Gibbons on 06/07/2023.
//

import SwiftUI
import MapKit
import CoreLocation

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

