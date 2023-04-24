//
//  LocationManager.swift
//  HelloSwift
//
//  Created by well on 2023/4/24.
//

import Foundation
import CoreLocation

class LocationManager: NSObject {
    private let locationManager = CLLocationManager()
    private var didUpdateLocation: ((CLLocation) -> Void)?
    
    init(desiredAccuracy: CLLocationAccuracy = kCLLocationAccuracyBest) {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = desiredAccuracy
    }
    
    /// start updating locations.
    func requestLocation(didUpdateLocation: @escaping (CLLocation) -> Void) {
        self.didUpdateLocation = didUpdateLocation
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    /// stop updating locations.
    func stop() { locationManager.stopUpdatingLocation() }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        didUpdateLocation?(location)
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Location manager failed with error: \(error.localizedDescription)")
    }
}
