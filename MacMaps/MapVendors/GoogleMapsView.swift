//
//  GoogleMapsView.swift
//  MacMaps
//
//  Created by Brad Leege on 2/1/22.
//

import Foundation
import SwiftUI
import WebKit
import CoreLocation

final class GoogleMapsView: NSViewRepresentable {
    
    private let webView: WKWebView = {
        let web = WKWebView()
        web.translatesAutoresizingMaskIntoConstraints = false
        return web
    }()
    
    func makeNSView(context: Context) -> some NSView {
        let view = NSView()

        view.addSubview(webView)
        
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        return view
    }
    
    func updateNSView(_ nsView: NSViewType, context: Context) {
        guard let url = Bundle.main.url(forResource: "google-maps", withExtension: "html") else { return }
        webView.load(URLRequest(url: url))
    }
    
    func changeMapStyle(_ mapStyle: MapContentViewModel.GoogleMapStyles) {
        print("\(#function) - mapStyle = \(mapStyle); styleURL = \(mapStyle.styleURL)")
        let javaScript = "changeStyle('\(mapStyle.styleURL)');"
        webView.evaluateJavaScript(javaScript, completionHandler: nil)
    }
    
    func setCenter(_ center: CLLocationCoordinate2D) {
        print("\(#function) - center = \(center)")
        let javaScript = "changeCenter(\(center.latitude), \(center.longitude));"
        webView.evaluateJavaScript(javaScript)
    }

    func showMarker(_ feature: GoogleMapsGeocodingResponse) {
        print("\(#function) - feature = \(feature)")
        let point = feature.results[0].geometry
        let javaScript = "addMarker(\(point.location.lat), \(point.location.lng));"
        webView.evaluateJavaScript(javaScript)
    }
    
    func clearMarker() {
        print("\(#function)")
        let javaScript = "clearMarker();"
        webView.evaluateJavaScript(javaScript)
    }

    
}
