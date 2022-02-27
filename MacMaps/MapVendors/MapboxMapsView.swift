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
import Combine

final class MapboxMapsView: NSViewRepresentable {
     
    private let webView: WKWebView = {
        let web = WKWebView()
        web.translatesAutoresizingMaskIntoConstraints = false
        return web
    }()
    
    private let webViewNavigationDelegate = MapboxMapsViewDelegate()
    private var mapFinishedLoadingCancelable = Set<AnyCancellable>()
    
    init() {
        webView.navigationDelegate = webViewNavigationDelegate
        
        webViewNavigationDelegate.mapFinishedLoadingPublisher
            .sink(receiveValue: { [weak self] didFinish in
                self?.setCenter(LocationManager.shared.currentLocation.value.coordinate)
            }).store(in: &mapFinishedLoadingCancelable)
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
    
    func showMarker(_ placemark: CLPlacemark) {
        print("\(#function) - placemark = \(placemark)")
        guard let coordinate = placemark.location?.coordinate else { return }
        let javaScript = "addMarker(\(coordinate.latitude), \(coordinate.longitude));"
        webView.evaluateJavaScript(javaScript)
    }
    
    func clearMarker() {
        print("\(#function)")
        let javaScript = "clearMarker();"
        webView.evaluateJavaScript(javaScript)
    }

    func showUserLocation(_ location: CLLocationCoordinate2D) {
        print("\(#function) - location = \(location)")
        let javaScript = "showUserLocation(\(location.latitude), \(location.longitude));"
        webView.evaluateJavaScript(javaScript)
    }
    
    func hideUserLocation() {
        print("\(#function)")
        let javaScript = "hideUserLocation();"
        webView.evaluateJavaScript(javaScript)
    }

}
