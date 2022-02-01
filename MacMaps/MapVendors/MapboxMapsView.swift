//
//  MapboxMapsView.swift
//  MacMaps
//
//  Created by Brad Leege on 1/19/22.
//

import Foundation
import SwiftUI
import WebKit
import CoreLocation
import GeoJSON

struct MapboxMapsView: NSViewRepresentable {
     
    private let webView: WKWebView = {
        let web = WKWebView()
        web.translatesAutoresizingMaskIntoConstraints = false
        return web
    }()
    
    private let webViewNavigationDelegate = MapboxMapsViewDelegate()
    
    init() {
        webView.navigationDelegate = webViewNavigationDelegate
    }
    
    // MARK: - NSViewRepresentable
    
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
        guard let url = Bundle.main.url(forResource: "mapbox", withExtension: "html") else { return }
        webView.load(URLRequest(url: url))
    }
    
    // MARK: - Map Functions
    func changeMapStyle(_ mapStyle: MapContentViewModel.MapboxStyles) {
        print("\(#function) - mapStyle = \(mapStyle); styleURL = \(mapStyle.styleURL)")
        let javaScript = "changeStyle('\(mapStyle.styleURL)');"
        webView.evaluateJavaScript(javaScript, completionHandler: nil)
    }
    
    func setCenter(_ center: CLLocationCoordinate2D) {
        print("\(#function) - center = \(center)")
        let javaScript = "changeCenter(\(center.latitude), \(center.longitude));"
        webView.evaluateJavaScript(javaScript)
    }
    
    func showMarker(_ feature: GeoJSON.Feature) {
        print("\(#function) - feature = \(feature)")
        switch feature.geometry {
        case .point(let point):
            let javaScript = "addMarker(\(point.coordinates.latitude), \(point.coordinates.longitude));"
            webView.evaluateJavaScript(javaScript)
        default:
            print("no op")
        }
    }
}
