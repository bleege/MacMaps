//
//  LocationManger+Delegates.swift
//  MacMaps
//
//  Created by Brad Leege on 12/21/21.
//

import Foundation
import CoreLocation

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation.send(locations[0])
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorized {
            manager.startUpdatingLocation()
        }
    }
    
}
