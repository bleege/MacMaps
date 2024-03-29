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
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()
    
    let mapViewDelegate = AppleMapsViewDelegate()
        
    private var marker = MKPointAnnotation()
    
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

        marker.coordinate = coordinate
        mapView.addAnnotation(marker)
    }
    
    func clearMarker() {
        mapView.removeAnnotation(marker)
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
    
    func updateNSView(_ nsView: NSViewType, context: Context) {
        
        mapView.setRegion(MKCoordinateRegion(center: LocationManager.shared.currentLocation.value.coordinate,
                                             latitudinalMeters: 100000,
                                             longitudinalMeters: 100000), animated: false)
        
    }
    
}
