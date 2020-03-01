//
//  LocationManager.swift
//  Weather
//
//  Created by Alexander Daniel on 1/4/20.
//  Copyright © 2020 adaniel. All rights reserved.
//

import Foundation
import CoreLocation
import Combine

extension CLLocation {
    var latitude: Double {
        return self.coordinate.latitude
    }
    
    var longitude: Double {
        return self.coordinate.longitude
    }
}

class LocationManager: NSObject {
    private let locationManager = CLLocationManager()
    private let geocoder = CLGeocoder()
    
    @Published var status: CLAuthorizationStatus?
    @Published var location: CLLocation?
    @Published var placemark: CLPlacemark?
    
    override init() {
        super.init()
        
        self.locationManager.delegate = self
//        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
//        self.locationManager.startUpdatingLocation()
//        self.locationManager.requestLocation()
        if CLLocationManager.significantLocationChangeMonitoringAvailable() {
            self.locationManager.startMonitoringSignificantLocationChanges()
            self.locationManager.pausesLocationUpdatesAutomatically = true
            self.locationManager.activityType = .fitness
        }
    }
    
    private func geocode() {
        guard let location = self.location else { return }
        geocoder.reverseGeocodeLocation(location, completionHandler: { (places, error) in
            if error == nil {
                self.placemark = places?[0]
                print("--> set placemark: \(self.placemark!)")
            } else {
                print(error!)
                self.placemark = nil
            }
        })
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.status = status
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.location = location
        self.geocode()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}


