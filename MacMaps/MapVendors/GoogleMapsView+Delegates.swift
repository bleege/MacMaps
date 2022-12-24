//
//  GoogleMapsView+Delegates.swift
//  MacMaps
//
//  Created by Brad Leege on 2/19/22.
//

import Foundation
import WebKit

protocol GoogleMapsViewDelegate {
   
    func mapFinishedLoading()
    
}

class GoogleMapsWebViewDelegate: NSObject {

    var delegate: GoogleMapsViewDelegate?
    
}

extension GoogleMapsWebViewDelegate: WKNavigationDelegate {

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("WebView did finish loading")
        delegate?.mapFinishedLoading()
    }
    
}

extension GoogleMapsView: GoogleMapsViewDelegate {
    
    func mapFinishedLoading() {
        setCenter(LocationManager.shared.currentLocation.value.coordinate)
        setZoom(8)
    }
    
}
