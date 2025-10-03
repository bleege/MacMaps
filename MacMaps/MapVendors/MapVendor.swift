//
//  MapVendor.swift
//  MacMaps
//
//  Created by Brad Leege on 10/2/25.
//

import Foundation
import CoreLocation

protocol MapVendor {
    var name: String { get }
    
    func setCenter(_ center: CLLocationCoordinate2D)
    func showMarker(_ placemark: CLPlacemark)
    func clearMarker()
    func showUserLocation(_ location: CLLocationCoordinate2D)
    func hideUserLocation()
}
