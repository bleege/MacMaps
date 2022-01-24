//
//  MapboxMapsView+Delegates.swift
//  MacMaps
//
//  Created by Brad Leege on 1/23/22.
//

import Foundation
import WebKit

class MapboxMapsViewDelegate: NSObject {}

extension MapboxMapsViewDelegate: WKNavigationDelegate {

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("WebView did finish loading")
    }
    
}
