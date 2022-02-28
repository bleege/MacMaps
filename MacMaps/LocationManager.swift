//
//  LocationManager.swift
//  MacMaps
//
//  Created by Brad Leege on 12/21/21.
//

import Foundation
import Combine
import CoreLocation

class LocationManager: NSObject {
    
    public static let shared = LocationManager()
    
    private let manager = CLLocationManager()
    
    var currentLocation = CurrentValueSubject<CLLocation, Never>(CLLocation(latitude: 50.45031, longitude: 30.53992))

    @Published
    var isMonitoringLocation = false
    
    private override init() {
        super.init()
        manager.delegate = self
    }

    func startLocationMonitoring() {
        print("startLocationMonitoring")
        if CLLocationManager.locationServicesEnabled() {
            print("locationServicesEnabled == true")
            manager.requestWhenInUseAuthorization()
            isMonitoringLocation = true
        } else {
            print("locationServicesEnabled == false")
            isMonitoringLocation = false
        }
    }
    
    func stopLocationMonitoring() {
        print("stopLocationMonitoring")
        manager.stopUpdatingLocation()
        isMonitoringLocation = false
    }
    
}
