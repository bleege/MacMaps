//
//  MKMapType+Extensions.swift
//  MacMaps
//
//  Created by Brad Leege on 12/10/21.
//

import Foundation
import MapKit

extension MKCoordinateRegion: @retroactive Equatable {
    public static func == (lhs: MKCoordinateRegion, rhs: MKCoordinateRegion) -> Bool {
        lhs.center.latitude == rhs.center.latitude
            && lhs.center.longitude == rhs.center.longitude
            && lhs.span.latitudeDelta == rhs.span.latitudeDelta
            && lhs.span.longitudeDelta == rhs.span.longitudeDelta
    }
}

extension MKMapType: Identifiable {

    // Identifiable
    public var id: Self { self }
    
    // Custom Name
    var name: String {
        
        switch self {
        case .standard:
            return "Standard"
        case .satellite:
            return "Satellite"
        case .hybrid:
            return "Hybrid"
        case .satelliteFlyover:
            return "Satellite Flyover"
        case .hybridFlyover:
            return "Hybrid Flyover"
        case .mutedStandard:
            return "Muted Standard"
        @unknown default:
            return "Unkown Default"
        }
        
    }
    
}
