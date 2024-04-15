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
    private var updateLocation: ((CLLocation) -> Void)?
    private var updateStatus: ((CLAuthorizationStatus) -> Void)?
    var authStatus: CLAuthorizationStatus {
        CLLocationManager.authorizationStatus()
    }

    init(desiredAccuracy: CLLocationAccuracy = kCLLocationAccuracyBest) {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = desiredAccuracy
    }

    /// request authorization
    func requestAuthorization(status: @escaping (CLAuthorizationStatus) -> Void) {
        updateStatus = status
        locationManager.requestWhenInUseAuthorization()
    }

    /// start updating locations.
    func start(_ location: @escaping (CLLocation) -> Void) {
        updateLocation = location
        locationManager.startUpdatingLocation()
    }

    /// stop updating locations.
    func stop() { 
        locationManager.stopUpdatingLocation()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        updateStatus?(status)
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        updateLocation?(location)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        kPrint("Location manager failed with error: \(error.localizedDescription)")
    }
}
