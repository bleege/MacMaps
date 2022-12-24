//
//  AppleMapsView+Delegates.swift
//  MacMaps
//
//  Created by Brad Leege on 1/16/22.
//

import Foundation
import MapKit

class AppleMapsViewDelegate: NSObject {}

extension AppleMapsViewDelegate: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        var pin = mapView.dequeueReusableAnnotationView(withIdentifier: "Pin")
        
        if pin == nil {
            pin = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "Pin")
        }
        pin?.displayPriority = .required
        
        return pin
    }
    
}
