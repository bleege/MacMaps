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
    
    private let manger = CLLocationManager()
    
    var currentLocation = CurrentValueSubject<CLLocation, Never>(CLLocation(latitude: 0, longitude: 0))
    
    private override init() {
        super.init()
        manger.delegate = self
    }

    func startLocationMonitoring() {
        if CLLocationManager.locationServicesEnabled() {
            print("locationServicesEnabled == true")
            manger.requestWhenInUseAuthorization()
        } else {
            print("locationServicesEnabled == false")
        }
    }
    
}
