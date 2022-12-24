//
//  MapboxMapsView+Delegates.swift
//  MacMaps
//
//  Created by Brad Leege on 1/23/22.
//

import Foundation
import WebKit

protocol MapboxMapsViewDelegate {
   
    func mapFinishedLoading()
    
}

class MapboxMapsWebViewDelegate: NSObject {

    var delegate: MapboxMapsViewDelegate?
    
}

extension MapboxMapsWebViewDelegate: WKNavigationDelegate {

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("WebView did finish loading")
        delegate?.mapFinishedLoading()
    }
    
}

extension MapboxMapsView: MapboxMapsViewDelegate {
    
    func mapFinishedLoading() {
        setCenter(LocationManager.shared.currentLocation.value.coordinate)
    }
    
}
