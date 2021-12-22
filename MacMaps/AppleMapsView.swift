//
//  AppleMapsView.swift
//  MacMaps
//
//  Created by Brad Leege on 12/11/21.
//

import SwiftUI
import MapKit

struct AppleMapsView: NSViewRepresentable {
    
    let mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.showsZoomControls = true
        mapView.showsUserLocation = true
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()
    
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
