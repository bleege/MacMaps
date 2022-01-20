//
//  AppleMapsView.swift
//  MacMaps
//
//  Created by Brad Leege on 12/11/21.
//

import SwiftUI
import MapKit
import CoreLocation

struct AppleMapsView: NSViewRepresentable {
    
    let mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.showsZoomControls = true
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()
    
    let mapViewDelegate = AppleMapsViewDelegate()
        
    init() {
        // Workaround for Structs
        mapView.delegate = mapViewDelegate
    }
    
    // MARK: - Map Utilities
    
    func showMarker(_ placemark: CLPlacemark) {
        guard let coordinate = placemark.location?.coordinate else { return }

        let nonUserAnnotations = mapView.annotations.filter({
            if $0 is MKUserLocation {
                return false
            }
            return true
        })
        mapView.removeAnnotations(nonUserAnnotations)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
    }
    
    
    // MARK: - NSViewRepresentable
    
    func makeNSView(context: Context) -> some NSView {
        let view = NSView()
        view.addSubview(mapView)
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        return view
    }
    
    func updateNSView(_ nsView: NSViewType, context: Context) { }
    
}
