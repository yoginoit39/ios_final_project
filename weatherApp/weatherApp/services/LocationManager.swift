//
//  LocationManager.swift
//  weatherApp
//
//  Created by Yogesh lakhani on 3/4/25.
//
//import CoreLocation
//
//class LocationManager: NSObject, CLLocationManagerDelegate {
//    static let shared = LocationManager()
//    private let manager = CLLocationManager()
//    private var currentLocation: CLLocationCoordinate2D?
//
//    override init() {
//        super.init()
//        manager.delegate = self
//        manager.desiredAccuracy = kCLLocationAccuracyBest
//        manager.requestWhenInUseAuthorization()
//        manager.startUpdatingLocation()
//    }
//
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        currentLocation = locations.first?.coordinate
//    }
//
//    func getCurrentLocation() -> CLLocationCoordinate2D? {
//        return currentLocation
//    }
//}



//below is working

//import CoreLocation
//
//class LocationManager: NSObject, CLLocationManagerDelegate {
//    static let shared = LocationManager()
//    private let locationManager = CLLocationManager()
//    private var currentLocation: CLLocation?
//
//    override init() {
//        super.init()
//        locationManager.delegate = self
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//    }
//
//    func requestLocationPermission() {
//        locationManager.requestWhenInUseAuthorization()
//    }
//
//    func getCurrentLocation() -> CLLocationCoordinate2D? {
//        if let location = locationManager.location {
//            return location.coordinate
//        } else {
//            print("❌ Location not available yet.")
//            return nil
//        }
//    }
//
//    // Update location when received
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        currentLocation = locations.last
//    }
//
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        print("❌ Location update failed: \(error.localizedDescription)")
//    }
//    
//    func requestLocationUpdate() async -> CLLocationCoordinate2D? {
//        return await withCheckedContinuation { continuation in
//            locationManager.requestLocation()
//            
//            DispatchQueue.global().asyncAfter(deadline: .now() + 5) { // Wait up to 5 seconds
//                if let location = self.locationManager.location {
//                    print("📍 Updated location received: \(location.coordinate.latitude), \(location.coordinate.longitude)")
//                    continuation.resume(returning: location.coordinate)
//                } else {
//                    print("❌ Failed to get updated location.")
//                    continuation.resume(returning: nil)
//                }
//            }
//        }
//    }
//
//}
//

import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    static let shared = LocationManager()
    private let locationManager = CLLocationManager()
    private var locationContinuation: CheckedContinuation<CLLocation?, Never>?
    private var authorizationContinuation: CheckedContinuation<CLAuthorizationStatus, Never>?
    
    private override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func getAuthorizationStatus() async -> CLAuthorizationStatus {
        return await withCheckedContinuation { continuation in
            self.authorizationContinuation = continuation
            let status = locationManager.authorizationStatus
            if status != .notDetermined {
                continuation.resume(returning: status)
            }
        }
    }
    
    func requestLocationPermission() async {
        if locationManager.authorizationStatus == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
            _ = await getAuthorizationStatus()
        }
    }
    
    func getCurrentLocation() async -> CLLocation? {
        guard locationManager.authorizationStatus == .authorizedWhenInUse ||
              locationManager.authorizationStatus == .authorizedAlways else {
            return nil
        }
        return locationManager.location
    }
    
    func requestLocationUpdate() async -> CLLocation? {
        return await withCheckedContinuation { continuation in
            self.locationContinuation = continuation
            locationManager.requestLocation()
        }
    }
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationContinuation?.resume(returning: location)
            locationContinuation = nil
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("❌ Location manager error: \(error.localizedDescription)")
        locationContinuation?.resume(returning: nil)
        locationContinuation = nil
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationContinuation?.resume(returning: manager.authorizationStatus)
        authorizationContinuation = nil
    }
}





//import CoreLocation
//
//class LocationManager: NSObject, CLLocationManagerDelegate {
//    static let shared = LocationManager()
//    private let locationManager = CLLocationManager()
//    private var currentLocation: CLLocation?
//
//    override init() {
//        super.init()
//        locationManager.delegate = self
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//    }
//
//    func requestLocationPermission() {
//        locationManager.requestWhenInUseAuthorization()
//    }
//
//    func getCurrentLocation() -> CLLocationCoordinate2D? {
//        if let location = locationManager.location {
//            return location.coordinate
//        } else {
//            print("❌ Location not available yet.")
//            return nil
//        }
//    }
//
//    func requestLocationUpdate() async -> CLLocationCoordinate2D? {
//        return await withCheckedContinuation { continuation in
//            locationManager.requestLocation()
//
//            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//                if let location = self.locationManager.location {
//                    continuation.resume(returning: location.coordinate)
//                } else {
//                    continuation.resume(returning: nil)
//                }
//            }
//        }
//    }
//
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        currentLocation = locations.last
//    }
//
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        print("❌ Location update failed: \(error.localizedDescription)")
//    }
//}
