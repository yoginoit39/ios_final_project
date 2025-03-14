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

import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    static let shared = LocationManager()
    private let locationManager = CLLocationManager()
    private var currentLocation: CLLocation?

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

    func requestLocationPermission() {
        locationManager.requestWhenInUseAuthorization()
    }

    func getCurrentLocation() -> CLLocationCoordinate2D? {
        if let location = locationManager.location {
            return location.coordinate
        } else {
            print("❌ Location not available yet.")
            return nil
        }
    }

    func requestLocationUpdate() async -> CLLocationCoordinate2D? {
        return await withCheckedContinuation { continuation in
            locationManager.requestLocation()

            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                if let location = self.locationManager.location {
                    continuation.resume(returning: location.coordinate)
                } else {
                    continuation.resume(returning: nil)
                }
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.last
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("❌ Location update failed: \(error.localizedDescription)")
    }
}
