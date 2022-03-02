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
import Combine

final class GoogleMapsView: NSViewRepresentable {
    
    private let webView: WKWebView = {
        let web = WKWebView()
        web.translatesAutoresizingMaskIntoConstraints = false
        return web
    }()
    
    private let webViewNavigationDelegate = GoogleMapsViewDelegate()
    private var mapFinishedLoadingCancelable = Set<AnyCancellable>()
    
    init() {
        webView.navigationDelegate = webViewNavigationDelegate
        
        webViewNavigationDelegate.mapFinishedLoadingPublisher
            .sink(receiveValue: { [weak self] didFinish in
                self?.setCenter(LocationManager.shared.currentLocation.value.coordinate)
                self?.setZoom(8)
            }).store(in: &mapFinishedLoadingCancelable)
    }
    
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
        if let filePath = Bundle.main.path(forResource: "google-maps", ofType: "html"),
           let googleApiKey = Bundle.main.object(forInfoDictionaryKey: "GOOGLE_MAPS_KEY") as? String {
            do {
                let fileContents = try String(contentsOfFile: filePath)
                let contentToLoad = fileContents.replacingOccurrences(of: "GOOGLE_MAPS_KEY", with: googleApiKey)
                webView.loadHTMLString(contentToLoad, baseURL: nil)
            } catch {
                print("Error loading Google Maps HTML: \(error)")
            }
        }
    }
    
    func changeMapStyle(_ mapStyle: MapContentViewModel.GoogleMapStyles) {
        print("\(#function) - mapStyle = \(mapStyle); styleURL = \(mapStyle.styleURL)")
        let javaScript = "changeStyle('\(mapStyle.styleURL)');"
        webView.evaluateJavaScript(javaScript, completionHandler: nil)
    }
    
    func setCenter(_ center: CLLocationCoordinate2D) {
        print("\(#function) - center = \(center)")
        let javaScript = "setCenter(\(center.latitude), \(center.longitude));"
        webView.evaluateJavaScript(javaScript)
    }
    
    func setZoom(_ zoom: Int) {
        print("\(#function) - zoom = \(zoom)")
        let javaScript = "setZoom(\(zoom));"
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
